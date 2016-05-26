//
//  HMDealsTopMenuView.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/12.
//  Copyright (c) 2016年 KK. All rights reserved.
//  Navigation上面的界面，共三个

#import <UIKit/UIKit.h>

@interface HMDealsTopMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTiltleLabel;

+ (instancetype)menu;

- (void)addTarget:(id)target action:(SEL)action;

@end
