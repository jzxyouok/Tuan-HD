//
//  HMAPITool.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/10.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMAPITool.h"
#import "DPAPI.h"

@interface HMAPITool()<DPRequestDelegate>
@property (nonatomic,strong) DPAPI *api;


@end

@implementation HMAPITool

static id _instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedAPITool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
    
}

//拷贝默认只返回一个。Zone是内存空间
- (id)copyWithZone:(NSZone *)zone{
    
    return _instance;//instance之前肯定创建好的，有对象才能拷贝，所以返回单例。要准守NSCopying
}


- (DPAPI *)api{
    if (_api == nil) {
        self.api = [[DPAPI alloc] init];
    }
    return _api;
}




- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
        DPRequest *request =[self.api requestWithURL:url params:[NSMutableDictionary dictionaryWithDictionary:params] delegate:self];
    
    request.success = success;
    request.failure = failure;
}


#pragma mark - 代理方法 DPRequestDelegate

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    if (request.success) {
        request.success(result);
    }
    
    NSLog(@"----success----");
    
}


- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    if (request.failure) {
        request.failure(error);
    }
    
    NSLog(@"----fail----");
    
}

@end
