//
//  HMRestriction.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/22.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRestriction : NSObject
/** 是否需要预约，0：不是，1：是 */
@property (assign, nonatomic) BOOL is_reservation_required;

/** 是否支持随时退款，0：不是，1：是 */
@property (assign, nonatomic) BOOL is_refundable;

/** 附加信息(一般为团购信息的特别提示) */
@property (copy, nonatomic) NSString *special_tips;
@end
