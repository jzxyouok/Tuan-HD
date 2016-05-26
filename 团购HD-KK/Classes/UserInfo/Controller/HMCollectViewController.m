//
//  HMCollectViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMCollectViewController.h"
#import "HMDealLocalTool.h"

@interface HMCollectViewController ()

@end

@implementation HMCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.title = @"我的收藏";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.deals removeAllObjects];
    NSArray *collectDealsArray = [HMDealLocalTool sharedDealLocalTool].collectDeals;
   
    [self.deals addObjectsFromArray:collectDealsArray];
    [self.collectionView reloadData];
}



- (NSString *)emptyIcon{
    
    return @"icon_collects_empty";
}


- (void)deleteItems{
    
    NSMutableArray *checkingDeals = [NSMutableArray array];
    for (HMDeal *deal in self.deals) {
        if (deal.checking) {
            
            deal.checking = NO;
            deal.editing = NO;
            [checkingDeals addObject:deal];
           

        }
        
    }
    [[HMDealLocalTool sharedDealLocalTool] unsaveCollectDeals:checkingDeals];
   
//    [self.deals removeObjectsInArray:checkingDeals];
    self.deals = [HMDealLocalTool sharedDealLocalTool].collectDeals;
    [self.collectionView reloadData];
    
// 父类方法
    [super deleteItems];
}


@end
