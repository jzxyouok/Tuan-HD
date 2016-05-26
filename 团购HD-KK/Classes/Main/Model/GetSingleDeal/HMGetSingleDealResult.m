//
//  HMGetSingleDealResult.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMGetSingleDealResult.h"
#import "HMDeal.h"

@implementation HMGetSingleDealResult
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"deals" : [HMDeal class]};
}
@end
