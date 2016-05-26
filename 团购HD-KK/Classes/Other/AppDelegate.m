//
//  AppDelegate.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/9.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "AppDelegate.h"
#import "HMNavigationController.h"
#import "HMDealsViewController.h"
//#import "UMSocial.h"
//#import "UMSocialSinaSSOHandler.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HMDealsViewController *deVc = [[HMDealsViewController alloc] init];
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:deVc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
//    [UMSocialData setAppKey:UMAPPKey];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
//                                              secret:SinaAppSecret
//                                         RedirectURL:nil];
    
    return YES;
}

//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}




@end
