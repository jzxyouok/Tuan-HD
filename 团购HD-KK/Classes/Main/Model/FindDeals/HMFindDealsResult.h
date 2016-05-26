//
//  HMFindDealsResult.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMFindDealsResult : NSObject
/** 所有页面团购总数 */
@property (assign, nonatomic) int total_count;


/** 本次API访问所获取的单页团购数量 */
@property (assign, nonatomic) int count;
/** 所有的团购 */
@property (strong, nonatomic) NSArray *deals;


@end
