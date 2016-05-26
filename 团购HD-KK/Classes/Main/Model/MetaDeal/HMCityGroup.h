//
//  HMCityGroup.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCityGroup : NSObject

/** 组标题 */
@property (copy, nonatomic) NSString *title;
/** 这组显示的城市 */
@property (strong, nonatomic) NSArray *cities;

@end
