//
//  HMRegionsViewController.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//  第二个大分类控制器

#import <UIKit/UIKit.h>
@class HMRegion;
@interface HMRegionsViewController : UIViewController
@property (nonatomic,copy) void (^changeCityBlock)();

@property (nonatomic,strong)NSArray *regions;


@property (nonatomic,strong)HMRegion *selectedRegion;
@property (nonatomic,copy) NSString *selectedSubRegion;



@end
