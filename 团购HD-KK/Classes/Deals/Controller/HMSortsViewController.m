//
//  HMSortsViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMSortsViewController.h"
#import "HMMetaDataTool.h"
#import "HMSort.h"

#pragma mark - 自定义Button
@interface HMSortButton : UIButton
@property (nonatomic,strong)HMSort *sort;
@end


@implementation HMSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImage = @"btn_filter_normal";
        self.selectedbgImage = @"btn_filter_selected";
        self.titleColor = [UIColor blackColor];
        self.selectedTitleColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted{
    //取消高亮
}

- (void)setSort:(HMSort *)sort{
    
    _sort = sort;
    
    self.title = sort.label;
    
}


@end








@interface HMSortsViewController ()

@property (nonatomic,strong)HMSortButton *selectedBtn;

@end

@implementation HMSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 设置在popover中的尺寸 在这里才有用
    self.preferredContentSize = self.view.size;
    
    // 设置内部排序按钮
    HMMetaDataTool *tool = [HMMetaDataTool sharedMetaDataTool];
    NSInteger count = tool.sorts.count;
    
    CGFloat btnX = 10;
    CGFloat btnW = self.view.width - 2 * btnX;
    CGFloat btnH = 30;
    CGFloat btnP = 10;
    CGFloat contentH = 0;
    for (int i = 0; i < count; i++) {
        
        HMSort *sort = tool.sorts[i];
        HMSortButton *button = [[HMSortButton alloc] init];
        button.sort = sort;
        button.x = btnX;
        button.width = btnW;
        button.height = btnH;
        button.y = btnP + i * (btnH + btnP);
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        contentH = button.MaxY + btnP;
    }
    
    UIScrollView *scv = (UIScrollView *)self.view;
    [scv setContentSize:CGSizeMake(50, 300)];
    scv.scrollEnabled = YES;
    scv.alwaysBounceVertical = YES;
    scv.showsVerticalScrollIndicator = YES;
    scv.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    

}


- (void)buttonClick:(HMSortButton *)button{
    
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    NSLog(@"选中了%@",button.currentTitle);
    

    [[NSNotificationCenter defaultCenter] postNotificationName:HMSortDidSelectNotification object:nil userInfo:@{HMSortSelected : button.sort}];
    
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
  
    
}

- (void)setSelectedSort:(HMSort *)selectedSort{
    _selectedSort = selectedSort;
    
    for (HMSortButton *button in self.view.subviews) {
        
        if ([button isKindOfClass:[HMSortButton class]]&& (button.sort ==selectedSort)) {
            
            self.selectedBtn.selected = NO;
            button.selected = YES;
            self.selectedBtn = button;
            
        }
        
        
    }
   
    
  
    
    
}


@end
