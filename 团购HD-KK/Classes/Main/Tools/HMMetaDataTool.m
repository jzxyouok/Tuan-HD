//
//  HMMetaDataTool.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//


#import "HMMetaDataTool.h"
#import "HMCategory.h"
#import "HMCity.h"
#import "HMCityGroup.h"
#import "HMSort.h"

@interface HMMetaDataTool()
{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
    /** 所有的排序 */
    NSArray *_sorts;
}

@property (nonatomic,strong)NSMutableArray *selectedCityNames;

@end



@implementation HMMetaDataTool

- (NSMutableArray *)selectedCityNames{
    if (_selectedCityNames == nil) {
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:HMSelectedCityNameFilePath];
        if (_selectedCityNames == nil) {
            _selectedCityNames = [NSMutableArray array];
        }        
    }
    return _selectedCityNames;
}


#pragma mark - 分类get方法

- (NSArray *)categories{
    if (_categories == nil) {
        _categories = [HMCategory mj_objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cities{
    if (_cities == nil) {
        _cities = [HMCity mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)cityGroups{
//    if (_cityGroups == nil) {
    
        NSMutableArray *cityGroups = [NSMutableArray array];
         if (self.selectedCityNames.count) {
        //添加最近组
        HMCityGroup *recentCityGroup = [[HMCityGroup alloc] init];
        recentCityGroup.title = @"最近";
        recentCityGroup.cities = self.selectedCityNames;
        [cityGroups addObject:recentCityGroup];
             
       }
        
        //添加plist固定的城市组
        NSArray *plistCityGroup = [HMCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
        [cityGroups addObjectsFromArray:plistCityGroup];
        _cityGroups = cityGroups;
//    }
    return _cityGroups;
}

- (NSArray *)sorts{
    if (_sorts == nil) {
        _sorts = [HMSort mj_objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


#pragma mark - 返回城市方法

- (HMCity *)cityWithName:(NSString *)cityName{
    
    if (cityName.length == 0) return nil;
    
    for (HMCity *city in self.cities) {
        if ([city.name isEqualToString:cityName]) return city;
    }
    return nil;
}

#pragma mark - 所有存储方法
- (void)saveCityWithName:(NSString *)cityName{
    
    if (cityName.length == 0) return;
    
    [self.selectedCityNames removeObject:cityName];
    [self.selectedCityNames insertObject:cityName atIndex:0];
    //写入plist
    [self.selectedCityNames writeToFile:HMSelectedCityNameFilePath atomically:YES];
}

- (void)saveSort:(HMSort *)sort{
    
    if (sort == nil) return;
    [NSKeyedArchiver archiveRootObject:sort toFile:HMSelectedSortFilePath];
    
}

- (void)saveRegion:(HMRegion *)region{
    if (region == nil) return;
    [NSKeyedArchiver archiveRootObject:region toFile:HMSelectedRegionFilePath];
}

-(void)saveSubRegionName:(NSString *)subRegionName{
    if (subRegionName == nil) return;
    [NSKeyedArchiver archiveRootObject:subRegionName toFile:HMSelectedSubRegionFilePath];
}

-(void)saveCategory:(HMCategory *)category{
    if (category == nil) return;
    [NSKeyedArchiver archiveRootObject:category toFile:HMSelectedCategoryFilePath];
    
}

-(void)saveSubCategoryName:(NSString *)subCategoryName{
    if (subCategoryName == nil) return;
    [NSKeyedArchiver archiveRootObject:subCategoryName toFile:HMSelectedSubCategoryFilePath];
    
    
}
#pragma mark - 所有读取方法

- (HMCity *)readSavedCity{
    NSString *cityName = [self.selectedCityNames firstObject];
    HMCity *city = [self cityWithName:cityName];
    if (city == nil) {
        city = [self cityWithName:@"北京"];
    }
    return city;
}

-(HMSort *)readSavedSort{
    
    HMSort *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedSortFilePath];
    if (sort == nil) {
        return [self.sorts firstObject];
    }
    return sort;
}

-(HMRegion *)readSavedRegion{
    HMRegion *region = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedRegionFilePath];
    return region;
}

-(NSString *)readSavedSubRegionName{
    NSString *SubRegionName = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedSubRegionFilePath];
    return SubRegionName;
    
}

-(HMCategory *)readSavedCategory{
    
    HMCategory *category = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedCategoryFilePath];
    if (category == nil) {
        return [self.categories firstObject];
    }
    return category;
}

-(NSString *)readSavedsubCategoryName{
    NSString *subCategoryName = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedSubCategoryFilePath];
    return subCategoryName;
    
}

#pragma mark - 唯一性
static id _instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedMetaDataTool{
    
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


#pragma mark - 返回某一分类（传入的可能是子分类）

- (HMCategory *)categoryWithName:(NSString *)categoryName{
    
    for (HMCategory *category in self.categories) {
        if ([category.name isEqualToString:categoryName]) return category;
            
        for (NSString *subCategory in category.subcategories) {
            if ([subCategory isEqualToString:categoryName]) return category;
        }
        
    }
    
    return nil;
}


@end
