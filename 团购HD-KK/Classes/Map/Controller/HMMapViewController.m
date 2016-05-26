//
//  HMMapViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/30.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HMDeal.h"
#import "HMDealTool.h"
#import "HMFindDealsParam.h"
#import "HMBusiness.h"
#import "HMDealAnnotation.h"
#import "HMAnnoViewRightBtn.h"
#import "HMDealDetailViewController.h"


#import "HMDealsTopMenuView.h"
#import "HMCategory.h"
#import "HMCategoriesViewController.h"



@interface HMMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)CLGeocoder *geocoder;
@property (nonatomic,copy) NSString *locateCity;

@property (nonatomic,strong)HMCategory *selectedCategory;
@property (nonatomic,copy) NSString *selectedSubCategory;
@property (nonatomic,weak) HMDealsTopMenuView *categoryMenu;
@property (nonatomic,strong)UIPopoverController *categoryVc;


/**是否在请求中*/
@property (nonatomic,assign,getter=isDealingDeals) BOOL dealingDeals;

- (IBAction)userLocationBtn;

@end

@implementation HMMapViewController

#pragma mark - 懒加载

- (CLGeocoder *)geocoder{
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UIPopoverController *)categoryVc{
    
    if (_categoryVc == nil) {
        HMCategoriesViewController *cv = [[HMCategoriesViewController alloc] init];
        self.categoryVc = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryVc;
}


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    //    if ([CLLocationManager locationServicesEnabled]){
    
    [self setNav];
    [self setMap];
    
}

- (void)setMap{
    
    CLLocationManager *locationManager=[[CLLocationManager alloc] init];
    self.locationManager = locationManager;
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
    locationManager.distanceFilter=10; //控制定位服务更新频率。单位是“米”
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestAlwaysAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        //当用户使用的时候授权
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];//开启定位
    
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
}



#pragma  mark - CLLocationManagerDelegate
//定位到用户位置时调用 定位比较频繁
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
//    CLLocation *currLocation = [locations lastObject];
//    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
//    NSLog(@"locationManager---%ld",locations.count);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息---%@",error);
    }
}



#pragma mark - MKMapViewDelegate
//获取用户位置 //执行2
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //显示区域
//    CLLocationCoordinate2D center = userLocation.location.coordinate;
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);//跨度
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//    
//    [mapView setRegion:region animated:YES];

    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count == 0) return;
        CLPlacemark *placemark = [placemarks firstObject];
        
        NSString *cityStr = placemark.addressDictionary[@"City"];
        self.locateCity = [cityStr substringToIndex:cityStr.length - 1];
        NSLogg(@"self.locateCity----%@", self.locateCity);
    }];
    
    
}

//执行1
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (self.locateCity == nil || self.isDealingDeals ) return;
    
    self.dealingDeals = YES;//开始处理
    
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    CLLocationCoordinate2D center = mapView.region.center;
    param.latitude = @(center.latitude);
    param.longitude = @(center.longitude);
    param.city = self.locateCity ;
    param.radius = @5000;
    //分类
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategory && ![self.selectedSubCategory isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategory;
        }else{
            
            param.category = self.selectedCategory.name;
        }
    }

    
    [HMDealTool findDeals:param succsess:^(HMFindDealsResult *result) {
        
        [self setDeals:result.deals];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试~"];
    }];
    
    
//    [mapView removeFromSuperview];
//    [self.view addSubview:mapView];
//     [self applyMapViewMemoryHotFix];
    
}

- (void)setDeals:(NSArray *)deals{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (HMDeal *deal in deals) {
            for (HMBusiness *business in deal.businesses) {
                
                HMDealAnnotation *anno = [[HMDealAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
               
                if ([self.mapView.annotations containsObject:anno]) continue;//已经存在就跳过
                
                anno.title = deal.title;
                anno.subtitle = business.name;
                anno.deal = deal;//自定义一个值 绑定右边按钮，进入详情
                
                dispatch_sync(dispatch_get_main_queue(), ^{
//                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                    [self.mapView addAnnotation:anno];
                    
                });
                
            }
        }
        
        self.dealingDeals = NO;//处理完毕
        
    });
   
}

#pragma mark - 内存释放
- (void)dealloc{
 
    [self.mapView removeFromSuperview];
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//     [self.mapView removeFromSuperview];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    [self.view addSubview:self.mapView];
//}



#pragma mark - setNav
- (void)setNav{
    
    //1.左上返回按钮
    UIBarButtonItem *backBtn = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
//    2.分类
    
    self.selectedCategory = [[HMMetaDataTool sharedMetaDataTool].categories firstObject];
  
    
    HMDealsTopMenuView *categoryMenu = [HMDealsTopMenuView menu];
    categoryMenu.titleLabel.text = [NSString stringWithFormat:@"%@",self.selectedCategory.name];
//    categoryMenu.subTiltleLabel.text = [NSString stringWithFormat:@"%@",self.selectedSubCategory];
    categoryMenu.imageButton.image = self.selectedCategory.image;
    categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlightedImage;
    
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    self.categoryMenu = categoryMenu;
    
    self.navigationItem.leftBarButtonItems = @[backBtn,categoryItem];
    
    
    
    //2.title
    self.title = @"地图";
    
}

- (void)categoryMenuClick{
    
    HMCategoriesViewController *cs = (HMCategoriesViewController *)self.categoryVc.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategory = self.selectedSubCategory;
    
    [self.categoryVc presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


#pragma mark - 监听通知

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //监听通知
    [self setupNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupNotifications{
    //监听第一个 选择分类category
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidSelect:) name:HMCategoryDidSelectNotification object:nil];

}

- (void)categoryDidSelect:(NSNotification *)note{
    
    HMCategory *selectedCategory = note.userInfo[HMCategorySelected];
    NSString *selectedSubCategory = note.userInfo[HMSubCategoryNameSelected];
    
    self.selectedCategory = selectedCategory;
    self.selectedSubCategory = selectedSubCategory;
    
    self.categoryMenu.titleLabel.text = selectedCategory.name;
    self.categoryMenu.subTiltleLabel.text = selectedSubCategory;
    
    self.categoryMenu.imageButton.image = selectedCategory.icon;
    self.categoryMenu.imageButton.highlightedImage = selectedCategory.highlighted_icon;
    
    //关闭POP
    [self.categoryVc dismissPopoverAnimated:YES];
    
    //分类改了 清空之前所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //加载最新数据
//    [self.collectionView.mj_header beginRefreshing];
    
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)userLocationBtn {
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
}



#pragma mark - 自定义大头针

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(HMDealAnnotation *)annotation{
    
    if (![annotation isKindOfClass:[HMDealAnnotation class]]) return nil;//如果是定位的那个按钮则返回，其本质是一颗大头针
        
    static NSString *ID = @"dealAnno";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    HMAnnoViewRightBtn *rightBtn = nil;
    
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        //显示
        annoView.canShowCallout = YES;
        //添加右边自定义按钮
        rightBtn = [HMAnnoViewRightBtn buttonWithType:UIButtonTypeDetailDisclosure];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        annoView.rightCalloutAccessoryView = rightBtn;
    }else{
        rightBtn = (HMAnnoViewRightBtn *)annoView.rightCalloutAccessoryView;
    }
    //覆盖模型数据
    annoView.annotation = annotation;
    //设置图标
    if ([self.selectedCategory.name isEqualToString:@"全部分类"]) {//刚进来的时候才要全部显示，选择某个分类图标就按分类显示就可以了
    
    HMCategory *category = [[HMMetaDataTool sharedMetaDataTool] categoryWithName:[annotation.deal.categories firstObject]];
        if (category.map_icon) {
            annoView.image = [UIImage imageNamed:category.map_icon];
        }else{//没有的分类随便搞个图标
            annoView.image = [UIImage imageNamed:@"icon_pathMenu_collect_highlighted"];
        }
    }else{//特定的类别
        if (self.selectedCategory.map_icon) {
           annoView.image = [UIImage imageNamed:self.selectedCategory.map_icon];
        }
    }
    rightBtn.deal = annotation.deal;
    
    return annoView;
}

- (void)rightBtnClick:(HMAnnoViewRightBtn *)btn{
    
    HMDealDetailViewController *dealDetailVc = [[HMDealDetailViewController alloc] init];
    dealDetailVc.deal = btn.deal;
    [self presentViewController:dealDetailVc animated:YES completion:nil];
    
}







@end
