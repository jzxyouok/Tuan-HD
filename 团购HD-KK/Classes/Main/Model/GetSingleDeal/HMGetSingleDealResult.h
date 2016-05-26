//
//  HMGetSingleDealResult.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//  和总共的 HMFindDealsResult 相比之少了totalCount 相当于是其父类

#import <Foundation/Foundation.h>

@interface HMGetSingleDealResult : NSObject

/** 本次API访问所获取的单页团购数量 */
@property (assign, nonatomic) int count;
/** 所有的团购 */
@property (strong, nonatomic) NSArray *deals;
@end
