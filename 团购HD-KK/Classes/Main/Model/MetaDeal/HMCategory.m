//
//  HMCategory.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/11.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMCategory.h"

@implementation HMCategory

- (NSString *)title{
    
    return self.name;
}

- (NSArray *)subtitles{
    
    return self.subcategories;
}


- (NSString *)image{
    
    return self.small_icon;
    
}


- (NSString *)highlightedImage{
    
    return self.small_highlighted_icon;
}

MJCodingImplementation

@end
