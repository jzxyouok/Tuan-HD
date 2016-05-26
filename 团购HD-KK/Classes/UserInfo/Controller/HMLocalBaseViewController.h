//
//  HMLocalBaseViewController.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealListViewController.h"

@interface HMLocalBaseViewController : HMDealListViewController
@property (nonatomic,strong)UIBarButtonItem *deleteBtn;
- (void)deleteItems;
@end
