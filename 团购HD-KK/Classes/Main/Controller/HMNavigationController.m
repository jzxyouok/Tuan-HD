//
//  HMNavigationController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMNavigationController.h"

@interface HMNavigationController ()

@end

@implementation HMNavigationController


+ (void)initialize{
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    //搜索框 取消 正常文字颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //设置常文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = HMColor(29, 177, 157, 1);
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    //设置disable文字颜色
    NSMutableDictionary *attrs2 = [NSMutableDictionary dictionary];
    attrs2[NSForegroundColorAttributeName] = HMColor(210, 210, 210, 1);
    [item setTitleTextAttributes:attrs2 forState:UIControlStateDisabled];
   
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}



@end
