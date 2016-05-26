//
//  HMCity.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMCity.h"
#import "HMRegion.h"

@implementation HMCity

+ (NSDictionary *)mj_objectClassInArray{
    
    
    return  @{@"regions" : [HMRegion class]};
    
}


//
//- (NSString *)title{
//    
//    return self.name;
//}
//
//- (NSArray *)subtitles{
//    
//    return self.regions;
//}






@end
