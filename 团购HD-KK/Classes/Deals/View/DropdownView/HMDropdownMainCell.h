//
//  HMDropdownMainCell.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDropdownView.h"

@interface HMDropdownMainCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,strong) id<HMDropdownViewItem> item;

@end
