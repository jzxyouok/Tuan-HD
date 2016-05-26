//
//  HMFindDealsResult.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMFindDealsResult.h"
#import "HMDeal.h"

@implementation HMFindDealsResult

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"deals" : [HMDeal class]};
}


@end
