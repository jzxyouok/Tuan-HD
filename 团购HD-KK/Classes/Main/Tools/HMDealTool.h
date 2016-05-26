//
//  HMDealTool.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//  业务类---负责团购的所有业务

#import <Foundation/Foundation.h>
#import "HMFindDealsParam.h"
#import "HMFindDealsResult.h"

#import "HMGetSingleDealParam.h"
#import "HMGetSingleDealResult.h"

@interface HMDealTool : NSObject

/**搜索所有团购**/
+ (void)findDeals:(HMFindDealsParam *)params succsess:(void (^)(HMFindDealsResult *result))success failure:(void (^)(NSError *error))failure;

/**搜索指定团购(单个详细的)**/
+ (void)getSingleDeal:(HMGetSingleDealParam *)params succsess:(void (^)(HMGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure;


@end
