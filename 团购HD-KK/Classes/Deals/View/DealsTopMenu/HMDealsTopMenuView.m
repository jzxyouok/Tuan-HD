//
//  HMDealsTopMenuView.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/12.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealsTopMenuView.h"

@interface HMDealsTopMenuView ()



@end

@implementation HMDealsTopMenuView

+ (instancetype)menu{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HMDealsTopMenuView" owner:nil options:nil] firstObject];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self =[super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return self;
    
}


- (void)addTarget:(id)target action:(SEL)action{
    
    
    [self.imageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}



@end
