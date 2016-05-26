//
//  HMCategoriesViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMCategoriesViewController.h"
#import "HMDropdownView.h"
#import "HMCategory.h"

@interface HMCategoriesViewController ()<HMDropdownViewDelegate>
@property (nonatomic,weak) HMDropdownView *menu;
@end

@implementation HMCategoriesViewController

//让View一开始就显示为dropmenu，在viewdidload方法中是覆盖
- (void)loadView{
    HMDropdownView *menu = [HMDropdownView menu];
    self.menu = menu;
    
    menu.delegate = self;
    menu.items = [HMMetaDataTool sharedMetaDataTool].categories;
    self.view = menu;
    
    self.menu = menu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.preferredContentSize = self.view.size;
}

#pragma mark - HMDropdownViewDelegate --->发出通知

- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedMain:(NSInteger)mainRow{
    HMCategory *cate = dropMenu.items[mainRow];
    NSLog(@"%@",cate.name);
    
    //发出通知
    if (cate.subcategories.count == 0) {//此选中行没有子分类，选中的就是这行
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[HMCategorySelected] = cate;
        userInfo[HMSubCategoryNameSelected] = @"全部";//防止Menu subtitle没有东西空白
        [[NSNotificationCenter defaultCenter] postNotificationName:HMCategoryDidSelectNotification object:nil userInfo:userInfo];
    }else{//子类别里面有东西
        if (self.selectedCategory == cate){//判断选择和点击的一样，再次选中
            
            self.selectedSubCategory = self.selectedSubCategory;
            
        }
        
    }
    
    
}

- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedSub:(NSInteger)subRow ofMain:(NSInteger)mainRow{
    
    HMCategory *cate = dropMenu.items[mainRow];
    NSLog(@"%@",cate.subcategories[subRow]);
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HMCategorySelected] = cate;
    userInfo[HMSubCategoryNameSelected] = cate.subcategories[subRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:HMCategoryDidSelectNotification object:nil userInfo:userInfo];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 公共方法
- (void)setSelectedCategory:(HMCategory *)selectedCategory{
    _selectedCategory = selectedCategory;
    
//    [self.menu.items indexOfObject:selectedCategory];
    NSInteger mainRow = [[HMMetaDataTool sharedMetaDataTool].categories indexOfObject:selectedCategory];
    [self.menu selectMain:mainRow];
    
}

- (void)setSelectedSubCategory:(NSString *)selectedSubCategory{
    _selectedSubCategory = selectedSubCategory;
    
    NSInteger subRow = [self.selectedCategory.subcategories indexOfObject:selectedSubCategory];
    [self.menu selectSub:subRow];
    
}


@end
