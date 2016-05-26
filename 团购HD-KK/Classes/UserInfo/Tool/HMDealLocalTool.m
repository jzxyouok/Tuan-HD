//
//  HMDealLocalTool.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealLocalTool.h"


@interface HMDealLocalTool()
@property (nonatomic,strong)NSMutableArray *historyDeals;
@property (nonatomic,strong)NSMutableArray *collectDeals;
@end

@implementation HMDealLocalTool

#pragma mark - 浏览历史
- (NSMutableArray *)historyDeals{
    
    if (_historyDeals == nil) {
        _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMHistoryDealsFilePath];
        if (_historyDeals == nil) {
            _historyDeals = [NSMutableArray array];
        }
    }
    
    return _historyDeals;
}


- (void)saveHistoryDeal:(HMDeal *)deal{
    [self.historyDeals removeObject:deal];
    
    if (self.historyDeals.count > 10) {//保证里面只有11个。、数字可以改
        NSRange range = NSMakeRange(10, self.historyDeals.count - 10);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.historyDeals removeObjectsAtIndexes:indexSet];
    }
    
    deal.editing = NO;
    [self.historyDeals insertObject:deal atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFilePath];
}

#pragma mark - 收藏

- (NSMutableArray *)collectDeals{
    
    if (_collectDeals == nil) {
        _collectDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMCollectDealsFilePath];
        if (_collectDeals == nil) {
            _collectDeals = [NSMutableArray array];
        }
    }
    
    return _collectDeals;
}


- (void)saveCollectDeal:(HMDeal *)deal{
    [self.collectDeals removeObject:deal];
    
//    if (self.collectDeals.count > 10) {//保证里面只有11个。、数字可以改
//        NSRange range = NSMakeRange(10, self.collectDeals.count - 10);
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.collectDeals removeObjectsAtIndexes:indexSet];
//    }
    
     deal.editing = NO;
    
    [self.collectDeals insertObject:deal atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFilePath];
}

- (void)unsaveCollectDeal:(HMDeal *)deal{
    
    [self.collectDeals removeObject:deal];
    
        deal.editing = NO;
   
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFilePath];
}

#pragma mark - 删除方法
- (void)unsaveHistoryDeal:(HMDeal *)deal{
    
    [self.historyDeals removeObject:deal];
    
        deal.editing = NO;
   
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFilePath];
}

- (void)unsaveHistoryDeals:(NSArray *)deals{
    [self.historyDeals removeObjectsInArray:deals];
    for (HMDeal *deal in self.historyDeals) {
        deal.editing = NO;
    }
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFilePath];
}

- (void)unsaveCollectDeals:(NSArray *)deals{
    
    [self.collectDeals removeObjectsInArray:deals];
    for (HMDeal *deal in self.collectDeals) {
        deal.editing = NO;
    }
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFilePath];
}






#pragma mark - 唯一性 --- 单例
static id _instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedDealLocalTool{
    
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

@end
