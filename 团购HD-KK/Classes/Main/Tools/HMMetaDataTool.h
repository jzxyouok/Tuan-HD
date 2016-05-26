//
//  HMMetaDataTool.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "HMCity.h"
@class HMRegion,HMSort,HMCategory;

@interface HMMetaDataTool : NSObject

/**
 *  所有的分类
 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序
 */
@property (strong, nonatomic, readonly) NSArray *sorts;

+ (instancetype)sharedMetaDataTool;


/**通过名字返回某一分类,传入的名称可能是分类或者子分类*/
- (HMCategory *)categoryWithName:(NSString *)categoryName;


/**随意搜某一城市*/
- (HMCity *)cityWithName:(NSString *)cityName;

/**存储城市，用来放入最近访问*/
- (void)saveCityWithName:(NSString *)cityName;
/**读取城市*/
- (HMCity *)readSavedCity;

/**存储分类*/
- (void)saveCategory:(HMCategory *)category;
/**存储子分类*/
- (void)saveSubCategoryName:(NSString *)subCategoryName;
/**读取分类*/
- (HMCategory *)readSavedCategory;
/**读取子分类*/
- (NSString *)readSavedsubCategoryName;

/**存储区域*/
- (void)saveRegion:(HMRegion *)region;
/**存储子区域*/
- (void)saveSubRegionName:(NSString *)subRegionName;
/**读取区域*/
- (HMRegion *)readSavedRegion;
/**读取子区域*/
- (NSString *)readSavedSubRegionName;


/**存储排序*/
- (void)saveSort:(HMSort *)sort;
/**读取排序*/
- (HMSort *)readSavedSort;

@end
