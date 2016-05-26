//
//  HMAPITool.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//  封装一层 SDK 网络请求

#import <Foundation/Foundation.h>

@interface HMAPITool : NSObject

- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


+ (instancetype)sharedAPITool;


@end
