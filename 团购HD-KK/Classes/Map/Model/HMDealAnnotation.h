//
//  HMDealAnnotation.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/30.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class HMDeal;
@interface HMDealAnnotation : NSObject <MKAnnotation>


@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property (nonatomic,strong)HMDeal *deal;

@end
