//
//  HMHistoryViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMHistoryViewController.h"
#import "HMDealLocalTool.h"

@interface HMHistoryViewController ()

@end

@implementation HMHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *hisDealsArray = [HMDealLocalTool sharedDealLocalTool].historyDeals;
//    [self.deals addObjectsFromArray:hisDealsArray];
//    
    
    self.title = @"浏览记录";
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //实时刷新
    [self.deals removeAllObjects];
    NSArray *hisDealsArray = [HMDealLocalTool sharedDealLocalTool].historyDeals;
    [self.deals addObjectsFromArray:hisDealsArray];
    [self.collectionView reloadData];
}



- (NSString *)emptyIcon{
    
    return @"icon_latestBrowse_empty";
}

- (void)deleteItems{
    
    NSMutableArray *checkingDeals = [NSMutableArray array];
    for (HMDeal *deal in self.deals) {
        if (deal.checking) {
#warning mark - 一定要先设置后加入数组，不然存的都是属性为YES
            deal.checking = NO;
            deal.editing = NO;
          [checkingDeals addObject:deal];
        }
        
    }
    [[HMDealLocalTool sharedDealLocalTool] unsaveHistoryDeals:checkingDeals];
//    [self.deals removeObjectsInArray:checkingDeals];
    self.deals = [HMDealLocalTool sharedDealLocalTool].historyDeals;
    [self.collectionView reloadData];
    
    // 父类方法
    [super deleteItems];
}




@end
