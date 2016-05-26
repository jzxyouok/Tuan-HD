//
//  HMDealLocalTool.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDeal.h"
@interface HMDealLocalTool : NSObject

//浏览历史
@property (nonatomic,strong,readonly)NSMutableArray *historyDeals;
- (void)saveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeals:(NSArray *)deals;

//收藏
@property (nonatomic,strong,readonly)NSMutableArray *collectDeals;
- (void)saveCollectDeal:(HMDeal *)deal;
- (void)unsaveCollectDeal:(HMDeal *)deal;
- (void)unsaveCollectDeals:(NSArray *)deals;

//删除方法
//- (void)deleteDeal:(HMDeal *)deal;
//- (void)deleteDeals:(NSArray *)deals;

+ (instancetype)sharedDealLocalTool;
@end
