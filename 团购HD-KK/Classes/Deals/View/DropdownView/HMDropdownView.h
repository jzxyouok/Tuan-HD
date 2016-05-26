//
//  HMDropdownView.h
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//  下拉菜单里面的Vc里的View，其中第一个下拉菜单和第二个下拉菜单共用 监听用户点击,传给各自的Vc

#import <UIKit/UIKit.h>
@class HMDropdownView;
//协议-->遵守协议，传进来的值变成相应的对象显示在View上
@protocol HMDropdownViewItem <NSObject>

@required

- (NSString *)title;
- (NSArray *)subtitles;

@optional

- (NSString *)image;
- (NSString *)highlightedImage;

@end


//代理-->成为代理，通知给你
@protocol HMDropdownViewDelegate <NSObject>

@optional

- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedMain:(NSInteger)mainRow;
- (void)dropMenu:(HMDropdownView *)dropMenu didSelectedSub:(NSInteger)subRow ofMain:(NSInteger)mainRow;

@end

@interface HMDropdownView : UIView

+ (instancetype)menu;

/**显示的数据类型都必须遵守HMDropdownViewItem协议*/
@property (nonatomic,strong)NSArray *items;

//代理
@property (nonatomic,weak) id<HMDropdownViewDelegate> delegate;

//提供给使用者，用来改选择的标签、cell
- (void)selectMain:(NSUInteger)mainRow;
- (void)selectSub:(NSUInteger)subRow;

@end

