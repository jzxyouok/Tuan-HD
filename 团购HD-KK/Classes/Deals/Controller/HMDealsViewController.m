//
//  HMDealsViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealsViewController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"

#import "UIBarButtonItem+Extension.h"
#import "HMDealsTopMenuView.h"


#import "HMRegionsViewController.h"
#import "HMCategoriesViewController.h"
#import "HMSortsViewController.h"
#import "HMChangeCitiesViewController.h"
#import "HMCity.h"
#import "HMSort.h"
#import "HMCategory.h"
#import "HMRegion.h"

#import "HMDealTool.h"
#import "MBProgressHUD+MJ.h"

#import "HMNavigationController.h"


#import "MJRefresh.h"


#import "HMHistoryViewController.h"
#import "HMCollectViewController.h"

#import "HMSearchViewController.h"
#import "HMMapViewController.h"

@interface HMDealsViewController ()<AwesomeMenuDelegate,AwesomeMenuItemDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) HMDealsTopMenuView *categoryMenu;
@property (nonatomic,weak) HMDealsTopMenuView *regionMenu;
@property (nonatomic,weak) HMDealsTopMenuView *sortMenu;

@property (nonatomic,strong)UIPopoverController *categoryVc;
@property (nonatomic,strong)UIPopoverController *regionVc;
@property (nonatomic,strong)UIPopoverController *sortVc;

//保存选择
@property (nonatomic,weak) HMCity *selectedCity;

@property (nonatomic,strong)HMRegion *selectedRegion;
@property (nonatomic,copy) NSString *selectedSubRegion;

@property (nonatomic,strong)HMSort *selectedSort;

@property (nonatomic,strong)HMCategory *selectedCategory;
@property (nonatomic,copy) NSString *selectedSubCategory;

//用于存放上一次请求参数，确定page
@property (nonatomic,strong)HMFindDealsParam *lastParam;

@end

@implementation HMDealsViewController



#pragma mark - 懒加载下拉框
- (UIPopoverController *)categoryVc{
    
    if (_categoryVc == nil) {
        HMCategoriesViewController *cv = [[HMCategoriesViewController alloc] init];
        self.categoryVc = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryVc;
}

- (UIPopoverController *)regionVc{
    
    if (_regionVc == nil) {
        HMRegionsViewController *rv = [[HMRegionsViewController alloc] init];
        
        __weak typeof (self) vc = self;
        rv.changeCityBlock = ^{
            
            [vc.regionVc dismissPopoverAnimated:YES];
            HMChangeCitiesViewController *cityVc = [[HMChangeCitiesViewController alloc] init];
            cityVc.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:cityVc animated:YES completion:nil];
           
        };

        
        self.regionVc = [[UIPopoverController alloc] initWithContentViewController:rv];
        
        
    }
    return _regionVc;
}

- (UIPopoverController *)sortVc{
    
    if (_sortVc == nil) {
        HMSortsViewController *sv = [[HMSortsViewController alloc] init];
        self.sortVc = [[UIPopoverController alloc] initWithContentViewController:sv];
    }
    return _sortVc;
}




#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置默认
    HMMetaDataTool *tool = [HMMetaDataTool sharedMetaDataTool];
    self.selectedCity =  tool.readSavedCity;
    HMRegionsViewController *revc = (HMRegionsViewController *)self.regionVc.contentViewController;
    revc.regions = self.selectedCity.regions;

    
    self.selectedRegion = tool.readSavedRegion;
    self.selectedSubRegion = tool.readSavedSubRegionName;
    
    
    self.selectedCategory = tool.readSavedCategory;
    self.selectedSubCategory = tool.readSavedsubCategoryName;
    
    self.selectedSort = tool.readSavedSort;
    
    
    //集成刷新控件
    [self setupRefresh];
    
    [self setupUserMenu];
    
    [self setupLeftItem];
    
    [self setupRightItem];
    
    
    
    
}

#pragma mark - 集成刷新控件
- (void)setupRefresh{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
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
    //监听第二个区域 选择城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidSelect:) name:HMCityDidSelectNotification object:nil];
    //监听第三个排序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidSelect:) name:HMSortDidSelectNotification object:nil];
    //监听第一个 选择分类category
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidSelect:) name:HMCategoryDidSelectNotification object:nil];
    
    //监听第二个 从city传入的region 选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidSelect:) name:HMRegionDidSelectNotification object:nil];
}

#pragma mark - 监听通知de方法
//city监听通知
- (void)cityDidSelect:(NSNotification *)note{
    
    HMCity *selectedCity = note.userInfo[HMCitySelected];
    
    self.selectedCity = selectedCity;
    self.selectedRegion = [self.selectedCity.regions firstObject]; //默认选中第一个
    self.regionMenu.subTiltleLabel.text = nil;
    
    [self citySelectedWillDo];

     NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:HMSelectedRegionFilePath error:nil];
    [fileManager removeItemAtPath:HMSelectedSubRegionFilePath error:nil];
}
//city拆分方法
- (void)citySelectedWillDo{
    
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",self.selectedCity.name,@"全部"];
    
    //更换选择的区域数据
    HMRegionsViewController *regionsVc = (HMRegionsViewController *)self.regionVc.contentViewController;
    regionsVc.regions = self.selectedCity.regions;
    
    //加载最新数据
    [self.collectionView.mj_header beginRefreshing];
    //存入沙盒
    [[HMMetaDataTool sharedMetaDataTool] saveCityWithName:self.selectedCity.name];
    
}
//region监听通知
- (void)regionDidSelect:(NSNotification *)note{
    
    HMRegion *selectedRegion = note.userInfo[HMRegionSelected];
    NSString *selectedSubRegion = note.userInfo[HMSubRegionNameSelected];
    
    self.selectedRegion = selectedRegion;
    self.selectedSubRegion = selectedSubRegion;
    //关闭POP
    [self.regionVc dismissPopoverAnimated:YES];
    [self regionDidSelectedWillDo];
}
//region拆分
- (void)regionDidSelectedWillDo{
    
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",self.selectedCity.name,self.selectedRegion.name];
    self.regionMenu.subTiltleLabel.text =self.selectedSubRegion;
    
    //加载最新数据
    [self.collectionView.mj_header beginRefreshing];
    
    //存入沙盒
    [[HMMetaDataTool sharedMetaDataTool] saveRegion:self.selectedRegion];
    [[HMMetaDataTool sharedMetaDataTool] saveSubRegionName:self.selectedSubRegion];
}



- (void)sortDidSelect:(NSNotification *)note{
    
    HMSort *selectedSort = note.userInfo[HMSortSelected];
    self.sortMenu.subTiltleLabel.text = selectedSort.label;
    
    self.selectedSort = selectedSort;
    
    //关闭POP
    [self.sortVc dismissPopoverAnimated:YES];
    //加载最新数据
     [self.collectionView.mj_header beginRefreshing];
    
    //存入沙盒
    [[HMMetaDataTool sharedMetaDataTool] saveSort:self.selectedSort];
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
    
    //加载最新数据
     [self.collectionView.mj_header beginRefreshing];
    
    [[HMMetaDataTool sharedMetaDataTool] saveCategory:self.selectedCategory ];
    [[HMMetaDataTool sharedMetaDataTool] saveSubCategoryName:self.selectedSubCategory];
}



#pragma mark -数据加载-刷新

- (void)loadNewData{
    
    HMFindDealsParam *param = [self buildParam];
//    param.limit = @3;

    NSLog(@"--请求参数--%@",param.mj_keyValues);
    
    [HMDealTool findDeals:param succsess:^(HMFindDealsResult *result) {
        
        [self.collectionView.mj_header endRefreshing];
       
        //开始之前可能换了数据，要清空
        [self.deals removeAllObjects];
        
        [self.deals addObjectsFromArray:result.deals];
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
       
        [MBProgressHUD showError:@"加载团购失败，请稍后再试~"];
    }];
    
    //3.保存请求参数
    self.lastParam = param;
}

- (void)loadMoreData{
    
    HMFindDealsParam *param = [self buildParam];
    param.page = @(self.lastParam.page.integerValue + 1);
    
    NSLog(@"--请求参数--%@",param.mj_keyValues);
    
    [HMDealTool findDeals:param succsess:^(HMFindDealsResult *result) {
        if (param != self.lastParam) return;
        
        //最新数据加到旧的数据后面
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        //不符合就返回，防止多次请求,请求过期情况
        if (param != self.lastParam) return;
        [self.collectionView.mj_footer endRefreshing];
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试~"];
        //页码要返回之前的~
        param.page = @(param.page.integerValue - 1);
    }];
    
    //3.设置请求参数
    self.lastParam = param;
}



//上拉和下拉的公共参数方法
- (HMFindDealsParam *)buildParam{
    
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    //城市
    param.city = self.selectedCity.name;
    //排序
    if (self.selectedSort) {
        param.sort = @(self.selectedSort.value);
    }
    //分类
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategory && ![self.selectedSubCategory isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategory;
        }else{
            
            param.category = self.selectedCategory.name;
        }
    }
    //区域
    if (self.selectedRegion && ![self.selectedRegion.name isEqualToString:@"全部"]) {
        if (self.selectedSubRegion && ![self.selectedSubRegion isEqualToString:@"全部"]) {
            param.region = self.selectedSubRegion;
        }else{
            
            param.region = self.selectedRegion.name;
        }
    }
    param.page = @1;
    return param;
}


#pragma mark -左导航

- (void)setupLeftItem{
    
    //1.LOGO
    
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithImageName:@"icon_meituan_logo" highImageName:@"icon_meituan_logo" target:nil     action:nil];
    logoItem.customView.userInteractionEnabled = NO;
    
    //2.分类
    HMDealsTopMenuView *categoryMenu = [HMDealsTopMenuView menu];
    categoryMenu.titleLabel.text = [NSString stringWithFormat:@"%@",self.selectedCategory.name];
    categoryMenu.subTiltleLabel.text = [NSString stringWithFormat:@"%@",self.selectedSubCategory];
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    self.categoryMenu = categoryMenu;
    
    //3.区域 icon_district_highlighted
    HMDealsTopMenuView *regionMenu = [HMDealsTopMenuView menu];
    regionMenu.imageButton.image = @"icon_district";
    regionMenu.imageButton.highlightedImage = @"icon_district_highlighted";
    regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",self.selectedCity.name,@"全部"];
    if (self.selectedRegion) {
        regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",self.selectedCity.name,self.selectedRegion.name];
    }
    if (self.selectedSubRegion) {
        regionMenu.subTiltleLabel.text = [NSString stringWithFormat:@"%@",self.selectedSubRegion];
    }

    [regionMenu addTarget:self action:@selector(regionMenuClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionMenu];
    self.regionMenu = regionMenu;
    
    //4.排序
    HMDealsTopMenuView *sortMenu = [HMDealsTopMenuView menu];
    sortMenu.imageButton.image = @"icon_sort";
    sortMenu.imageButton.highlightedImage = @"icon_sort_highlighted";
    sortMenu.titleLabel.text = @"排序";
    sortMenu.subTiltleLabel.text = self.selectedSort.label;
    [sortMenu addTarget:self action:@selector(sortMenuClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortMenu];
    self.sortMenu = sortMenu;
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,regionItem,sortItem];
    
    //加载最新数据
    [self.collectionView.mj_header beginRefreshing];
}

- (void)categoryMenuClick{
    
    HMCategoriesViewController *cs = (HMCategoriesViewController *)self.categoryVc.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategory = self.selectedSubCategory;
    
    [self.categoryVc presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

- (void)regionMenuClick{
    
    //传入选入的标签
    HMRegionsViewController *revc = (HMRegionsViewController *)self.regionVc.contentViewController;
#warning mark - 顺序不能错
    revc.selectedRegion = self.selectedRegion;//顺序不能错
    revc.selectedSubRegion = self.selectedSubRegion;
    //展示POP
    [self.regionVc presentPopoverFromRect:self.regionMenu.bounds inView:self.regionMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

- (void)sortMenuClick{
    
    HMSortsViewController *svc = (HMSortsViewController *)self.sortVc.contentViewController;
    svc.selectedSort = self.selectedSort;
    
    
     [self.sortVc presentPopoverFromRect:self.sortMenu.bounds inView:self.sortMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}



#pragma mark -右导航

- (void)setupRightItem{
    
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImageName:@"icon_map" highImageName:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = 70;
    mapItem.customView.height = 35;
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImageName:@"icon_search" highImageName:@"icon_search" target:self action:@selector(searchClick)];
    searchItem.customView.width = 70;
    searchItem.customView.height = 35;
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
    
}


- (void)mapClick{
    
    NSLog(@"mapClick");
    
    HMMapViewController *mapVc = [[HMMapViewController alloc] init];
    
    HMNavigationController *navVc = [[HMNavigationController alloc] initWithRootViewController:mapVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)searchClick{
    
    NSLog(@"searchClick");
    
    HMSearchViewController *searchVc = [[HMSearchViewController alloc] init];
    searchVc.selectedCity = self.selectedCity;
    HMNavigationController *navVc = [[HMNavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:navVc animated:YES completion:nil];
    
    
}




#pragma mark -菜单

- (AwesomeMenuItem *)itemWithContentImage:(NSString *)ContentImage highlightedContentImage:(NSString *)highlightedContentImage{
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    return [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:nil ContentImage:[UIImage imageNamed:ContentImage]                                                    highlightedContentImage:[UIImage imageNamed:highlightedContentImage]];
    
}


- (void)setupUserMenu{
    
//     Default Menu
    
    AwesomeMenuItem *mineMenuItem = [self itemWithContentImage:@"icon_pathMenu_mainMine_normal" highlightedContentImage:@"icon_pathMenu_mine_highlighted"];
    AwesomeMenuItem *collectMenuItem = [self itemWithContentImage:@"icon_pathMenu_collect_normal" highlightedContentImage:@"icon_pathMenu_collect_highlighted"];
    AwesomeMenuItem *scanMenuItem = [self itemWithContentImage:@"icon_pathMenu_scan_normal" highlightedContentImage:@"icon_pathMenu_scan_highlighted"];
    AwesomeMenuItem *moreMenuItem = [self itemWithContentImage:@"icon_pathMenu_more_normal" highlightedContentImage:@"icon_pathMenu_more_highlighted"];
   
    
    NSArray *menuItems = @[mineMenuItem, collectMenuItem, scanMenuItem, moreMenuItem];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                                       highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                                           ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:menuItems];
//    menu.backgroundColor = [UIColor redColor];
    menu.menuWholeAngle = M_PI_2;
    [self.view addSubview:menu];
    
    CGFloat menuH = 200;
    [menu autoSetDimensionsToSize:CGSizeMake(200, menuH)];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    //添加一个背景
    UIImageView *menBg = [[UIImageView alloc] init];
    menBg.image = [UIImage imageNamed:@"icon_pathMenu_background"];
    [menu insertSubview:menBg atIndex:0];
    
    //约束
    [menBg autoSetDimensionsToSize:menBg.image.size];
    [menBg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menBg autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    menu.startPoint = CGPointMake(menBg.image.size.width * 0.5,menuH - menBg.image.size.height * 0.5);
    
    //禁止中间按钮旋转
    menu.rotateAddButton = NO;
    menu.delegate = self;
    menu.alpha = 0.1;
    
}

#pragma mark -菜单代理

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    
    NSLogg(@"awesomeMenuWillAnimateOpen");
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    
    [UIView animateWithDuration:0.25 animations:^{
        menu.alpha = 1;
    }];
    
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    
     NSLogg(@"awesomeMenuWillAnimateClose");
    
    [UIView animateWithDuration:0.5 animations:^{
        menu.alpha = 0.1;
    }];
}


- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    
    
    if (idx == 1) {
        HMCollectViewController *hisVc = [[HMCollectViewController alloc] init];
        HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:hisVc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (idx == 2){
        
        HMHistoryViewController *hisVc = [[HMHistoryViewController alloc] init];
        HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:hisVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    
    NSLogg(@"didSelectIndex--%ld",idx);
    [self awesomeMenuWillAnimateClose:menu];
    
    
}

#pragma mark - 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
//    self.collectionView.mj_footer.hidden = 
    
    return [super collectionView:collectionView numberOfItemsInSection:section];
}


- (NSString *)emptyIcon{
    
    return @"icon_deals_empty";
}












//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//   
//    
//    int columns = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? 2 : 3;
//    int totalWidth = self.view.height;
//    [self layout:totalWidth conlumns:columns];
//    
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    
//    int columns = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 2 : 3;
//    int totalWidth = self.view.width;
//    [self layout:totalWidth conlumns:columns];
//    
//}
//
////layout公共方法
//- (void)layout:(CGFloat)totalWidth conlumns:(int)columns{
//    
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
//    
//    CGFloat lineSpacing = 10;
//    CGFloat interitemSpacing = (totalWidth - columns *layout.itemSize.width) / (columns + 1);
//    
//    NSLog(@"%f,%f,%d,%f",totalWidth,layout.itemSize.width,columns,interitemSpacing);
//    
//    layout.minimumLineSpacing = lineSpacing;//行间距
//    layout.minimumInteritemSpacing = interitemSpacing;//列间距
//    //cell与collectionView边缘的间距
//    layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
//    
//}





//ipad 屏幕旋转监听方法 : 子控制器和根控制器有关联才能知道屏幕旋转了

// 旋转后调用的方法
//
//- (void)setupRatate
//
//{
//    
//    // 返回的是父类 UICollectionViewLayout ，子类是 UICollectionViewFlowLayout ，把返回的父类要强转成我们要用上面的子类
//    
//    // 取出布局
//    
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self .collectionView.collectionViewLayout;
//    
//    
//    
//    // 设置 collectionView 内边距 布局
//    
//    CGFloat paddingY = 20 ;
//    
//    CGFloat paddingX = 40 ;
//    
//    
//    // 判断横竖屏
//    if (UIInterfaceOrientationIsLandscape( self.interfaceOrientation)) // 在旋转后当前横屏
//        
//    {
//        
//        paddingX = (self.view.bounds.size.width - 3 *layout.itemSize.width)/ 4 ;
//       
//        
//    } else {
//        
//        paddingX = ( self.view.bounds.size.height - 2 *layout.itemSize.width)/ 3 ;
//        
//    }
//    
//    //cell与collectionView边缘的间距
//    layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
//    
//  
//    
//    // 添加动画
//    
//    [UIView animateWithDuration: 0.5 animations:^{
//        
//        // 行之间
//        layout.minimumLineSpacing = paddingY;
//        layout.minimumInteritemSpacing = paddingX;
//        
//    }];
//    
//}
//
//// 即将旋转调用的方法   本例没有有使用
//
//- ( void )didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//
//{
//    
//     [self setupRatate];
//    
//}
//
//
//
//// 想一进界面就有这样的效果，就在 -(void)viewDidLoad 或者 - (void)viewDidAppear:(BOOL)animated 调用设置界面布局效果的方法，具体调用哪个视情况而定
//
//
//
//// 如本例适合调用的方法
//
//- ( void )viewDidAppear:( BOOL )animated
//
//{
//    
//    [ super viewDidAppear:animated];
//    
//    // 调用设置界面布局效果的方法
//    
//    [self setupRatate];
//    
//}

@end
