//
//  HMEmptyView.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/19.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMEmptyView.h"

@implementation HMEmptyView


+ (instancetype)emptyView{
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        self.contentMode = UIViewContentModeCenter;
        
    }
    return self;
}


- (void)didMoveToSuperview{
    
    if (self.superview) {
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    }
    
}

@end
