//
//  HMDealCell.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/16.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealCell.h"
#import "UIImageView+WebCache.h"
#import "HMDeal.h"
@interface HMDealCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPriceWidth;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listPriceWidth;

@property (weak, nonatomic) IBOutlet UIImageView *dealNewIcon;

- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

@end


@implementation HMDealCell


#pragma mark - 计算价格 有小数保留小数
- (NSString *)priceStr:(CGFloat)price{
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%0.2f",price];
    if ([priceStr hasSuffix:@"0"]) {
        priceStr = [priceStr substringToIndex:priceStr.length - 1];
        if ([priceStr hasSuffix:@"0"]) {
            priceStr = [priceStr substringToIndex:priceStr.length - 2];
        }
    }
    return priceStr;
}




- (void)setDeal:(HMDeal *)deal{
    
    _deal = deal;
   //1.设置xib上显示
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.titleLabel.text = deal.title;
    self.descLabel.text = deal.desc;
    self.currentPriceLabel.text = [self priceStr:deal.current_price];
    self.listPriceLabel.text = [self priceStr:deal.list_price];
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售出%d", deal.purchase_count];
    
    
    //2.设置新上架
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    NSString *today = [fmt stringFromDate:[NSDate date]];
    if ([today compare:deal.publish_date] == NSOrderedDescending) {//旧的
        self.dealNewIcon.hidden = YES;
    }else{
        self.dealNewIcon.hidden = NO;
    }
    
    //3.设置编辑状态
    if (deal.isEditing) {
        self.coverBtn.hidden = NO;
        
    }else{
        
        self.coverBtn.hidden = YES;
    }
    //4.设置勾选状态
    
    self.checkImage.hidden = !self.deal.isChecking;
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

- (IBAction)coverClick {
    
    //设置状态-通过模型deal联系来确定cell勾选状态，避免循环引用
    self.deal.checking = !self.deal.isChecking;
    
    self.checkImage.hidden = !self.deal.isChecking;
    
    //通知代理
    
    if ([self.celldelegate respondsToSelector:@selector(dealCellDidClickCover:)])
    {
        [self.celldelegate dealCellDidClickCover:self];
    }
    
}
@end
