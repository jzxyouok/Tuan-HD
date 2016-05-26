//
//  HMDealListViewController.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDealListViewController : UICollectionViewController
//用于存放团购数据
@property (nonatomic,strong)NSMutableArray *deals;

/**提供界面是空的图片*/
- (NSString *)emptyIcon;
@end
