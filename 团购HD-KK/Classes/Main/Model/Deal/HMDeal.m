//
//  HMDeal.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDeal.h"
#import "HMBusiness.h"

@implementation HMDeal

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"businesses" : [HMBusiness class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    
    return @{@"desc" : @"description"};
    
    
}

- (BOOL)isEqual:(HMDeal *)other{//重写Equal方法--用于判断
    
    return [self.deal_id isEqualToString:other.deal_id];
    
}


MJCodingImplementation
@end
