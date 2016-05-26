//
//  HMDealLabel.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/18.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealLabel.h"

@implementation HMDealLabel




- (void)drawRect:(CGRect)rect {
 
    [super drawRect:rect];
    
    
    [self.textColor  set];
    
    UIRectFill(CGRectMake(self.width * 0.1, self.height * 0.5, self.width * 0.9, 1));
    
    
}


@end
