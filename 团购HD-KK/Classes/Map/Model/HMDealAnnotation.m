//
//  HMDealAnnotation.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/30.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealAnnotation.h"

@implementation HMDealAnnotation

- (BOOL)isEqual:(HMDealAnnotation *)other{
    
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
    
}

@end
