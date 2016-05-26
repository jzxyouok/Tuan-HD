//
//  HMDealCell.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/16.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDeal,HMDealCell;

@protocol HMDealCellDelegate <NSObject>

@optional
- (void)dealCellDidClickCover:(HMDealCell *)Cell;
@end




@interface HMDealCell : UICollectionViewCell
@property (nonatomic,strong)HMDeal *deal;
@property (nonatomic,weak) id<HMDealCellDelegate> celldelegate;//避免和系统重复
@end
