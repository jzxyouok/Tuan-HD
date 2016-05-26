//
//  HMLocalBaseViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMLocalBaseViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDeal.h"
#import "HMDealCell.h"
@interface HMLocalBaseViewController ()<HMDealCellDelegate>
@property (nonatomic,strong)UIBarButtonItem *backBtn;
@property (nonatomic,strong)UIBarButtonItem *selectedAllBtn;
@property (nonatomic,strong)UIBarButtonItem *unselectedAllBtn;
//@property (nonatomic,strong)UIBarButtonItem *deleteBtn;
@end

@implementation HMLocalBaseViewController

#pragma mark - UIBarButtonItem--懒加载
- (UIBarButtonItem *)backBtn{
    
    if (_backBtn == nil) {
        self.backBtn = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backBtn;
}
- (UIBarButtonItem *)selectedAllBtn{
    
    if (_selectedAllBtn == nil) {
        self.selectedAllBtn = [[UIBarButtonItem alloc] initWithTitle:@" 全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectedAllItems)];
    }
    return _selectedAllBtn;
}

- (UIBarButtonItem *)unselectedAllBtn{
    
    if (_unselectedAllBtn == nil) {
        self.unselectedAllBtn = [[UIBarButtonItem alloc] initWithTitle:@" 取消" style:UIBarButtonItemStyleDone target:self action:@selector(unselectedAllItems)];
    }
    return _unselectedAllBtn;
}

- (UIBarButtonItem *)deleteBtn{
    
    if (_deleteBtn == nil) {
        self.deleteBtn = [[UIBarButtonItem alloc] initWithTitle:@" 删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteItems)];
        self.deleteBtn.enabled = NO;
    }
    return _deleteBtn;
}


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置左上角返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backBtn];
    //设置右上角编辑文字
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    
}


#pragma mark - UIBarButtonItem--对应方法
- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)selectedAllItems{
    
    for (HMDeal *deal in self.deals) {
        deal.checking = YES;
        
    }
    
    [self.collectionView reloadData];
    [self dealCellDidClickCover:nil];
    
}

- (void)unselectedAllItems{
    
    for (HMDeal *deal in self.deals) {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    [self dealCellDidClickCover:nil];
    
}


#warning 到之类里面判断删除谁
- (void)deleteItems{
    
    self.deleteBtn.title = @" 删除";
    self.deleteBtn.enabled = NO;
 
    
}

- (void)edit{
    
    NSString *titleStr = self.navigationItem.rightBarButtonItem.title;
    if ([titleStr isEqualToString:@"编辑"]) {
         self.navigationItem.rightBarButtonItem.title = @"完成";
        //进入编辑界面
        for (HMDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
        //刷新左上角按钮
        self.navigationItem.leftBarButtonItems = @[self.backBtn,self.selectedAllBtn,self.unselectedAllBtn,self.deleteBtn];
        
        
        
    }else{
        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        //结束编辑界面
        for (HMDeal *deal in self.deals) {
            deal.editing = NO;
            deal.checking= NO;
        }
        [self.collectionView reloadData];
        //刷新左上角按钮
        self.navigationItem.leftBarButtonItems = @[self.backBtn];
        
        [self dealCellDidClickCover:nil];
    }
   
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    for (HMDeal *deal in self.deals) {
        deal.editing = NO;
        deal.checking = NO;
    }
}

#pragma mark - cell代理方法
- (void)dealCellDidClickCover:(HMDealCell *)Cell{
    
    BOOL deleteEnable = NO;
    int checkingCount = 0;
    for (HMDeal *deal in self.deals) {
        if (deal.isChecking) {
            deleteEnable = YES;
            checkingCount++;
        }
    }
    
    //设置删除按钮状态
    self.deleteBtn.enabled = deleteEnable;
    if(checkingCount > 0){
     self.deleteBtn.title = [NSString stringWithFormat:@" 删除(%d)",checkingCount];
    }else{
      self.deleteBtn.title = @" 删除";
    }
    
    
}


@end
