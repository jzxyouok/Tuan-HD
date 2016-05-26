//
//  HMDealTool.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealTool.h"
#import "HMAPITool.h"

@implementation HMDealTool


+ (void)findDeals:(HMFindDealsParam *)params succsess:(void (^)(HMFindDealsResult *))success failure:(void (^)(NSError *))failure{
    
    HMAPITool *apiTool = [HMAPITool sharedAPITool];
    [apiTool request:@"v1/deal/find_deals" params:params.mj_keyValues success:^(id json) {
        
        if (success) {
             HMFindDealsResult *obj = [HMFindDealsResult mj_objectWithKeyValues:json];
            success(obj);
        }
        
    } failure:failure];
    
}

+ (void)getSingleDeal:(HMGetSingleDealParam *)params succsess:(void (^)(HMGetSingleDealResult *))success failure:(void (^)(NSError *))failure{
    
    HMAPITool *apiTool = [HMAPITool sharedAPITool];
    [apiTool request:@"v1/deal/get_single_deal" params:params.mj_keyValues success:^(id json) {
        
        if (success) {
            HMGetSingleDealResult *obj = [HMGetSingleDealResult mj_objectWithKeyValues:json];
            success(obj);
        }
        
    } failure:failure];
    
    
    
}



@end
