//
//  HMRegionsViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMRegionsViewController.h"
#import "HMDropdownView.h"
#import "HMCity.h"
#import "HMChangeCitiesViewController.h"
#import "HMRegion.h"
#import "HMCity.h"

@interface HMRegionsViewController ()<HMDropdownViewDelegate>
- (IBAction)changeCity;
@property (nonatomic,strong) HMDropdownView *dropMenu;
@end

@implementation HMRegionsViewController


- (HMDropdownView *)dropMenu{
    
    if (_dropMenu == nil) {
        
        UIView *topView = [self.view.subviews firstObject];
        
        HMDropdownView *dropMenu =[HMDropdownView menu];
//        HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:@"北京"];
//        dropMenu.items = city.regions;
        dropMenu.delegate = self;
        [self.view addSubview:dropMenu];
        
        [dropMenu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topView];
        [dropMenu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        self.dropMenu = dropMenu;
    }
    return _dropMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


- (IBAction)changeCity {
    
    
//
//    UIPopoverController *popVc = [self valueForKeyPath:@"popoverController"];
//    [popVc dismissPopoverAnimated:YES];
    
//    HMChangeCitiesViewController *cityVc = [[HMChangeCitiesViewController alloc] init];
//    cityVc.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:cityVc animated:YES completion:nil];
    
    if (self.changeCityBlock) {
        self.changeCityBlock();
    }
    
   
   

}

#pragma mark - 公共方法

- (void)setRegions:(NSArray *)regions{
    
    _regions = regions;
    
    self.dropMenu.items = regions;
}


#pragma mark - HMDropdownViewDelegate --->发出通知

- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedMain:(NSInteger)mainRow{
    HMRegion *sr = dropMenu.items[mainRow];
    NSLog(@"%@",sr.name);
    
    //发出通知
    if (sr.subregions.count == 0) {//此选中行没有子分类，选中的就是这行
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[HMRegionSelected] = sr;
//        userInfo[HMSubRegionNameSelected] = @"全部";//防止Menu subtitle没有东西空白
        [[NSNotificationCenter defaultCenter] postNotificationName:HMRegionDidSelectNotification object:nil userInfo:userInfo];
    }else{
        
        if (self.selectedRegion == sr) {
            self.selectedSubRegion = self.selectedSubRegion;
        }
        
    }
}

- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedSub:(NSInteger)subRow ofMain:(NSInteger)mainRow{
    
    HMRegion *srr = dropMenu.items[mainRow];
    NSLog(@"%@",srr.subregions[subRow]);
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HMRegionSelected] = srr;
    userInfo[HMSubRegionNameSelected] = srr.subregions[subRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:HMRegionDidSelectNotification object:nil userInfo:userInfo];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark - 公共方法
- (void)setSelectedRegion:(HMRegion *)selectedRegion{
    _selectedRegion = selectedRegion;
    
    
    NSInteger mainRow = [self.dropMenu.items indexOfObject:selectedRegion];
    [self.dropMenu selectMain:mainRow];
    
}

- (void)setSelectedSubRegion:(NSString *)selectedSubRegion{
    _selectedSubRegion = [selectedSubRegion copy];
    
    NSInteger subRow = [self.selectedRegion.subregions indexOfObject:selectedSubRegion];
    [self.dropMenu selectSub:subRow];
    
}



@end
