//
//  HMCategoriesViewController.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMCategory;
@interface HMCategoriesViewController : UIViewController

@property (nonatomic,strong)HMCategory *selectedCategory;
@property (nonatomic,copy) NSString *selectedSubCategory;

@end
