//
//  HMRegion.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDropdownView.h"

@interface HMRegion : NSObject <HMDropdownViewItem>

/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域 */
@property (strong, nonatomic) NSArray *subregions;

@end
