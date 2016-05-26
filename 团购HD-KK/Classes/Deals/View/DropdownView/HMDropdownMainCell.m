//
//  HMDropdownMainCell.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDropdownMainCell.h"

@interface HMDropdownMainCell()
@property (nonatomic,strong)UIImageView *rightView;
@end

@implementation HMDropdownMainCell

- (UIImageView *)rightView{
    
    if (_rightView == nil) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    }
    return _rightView;
    
}
    

    


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    //1.创建cell
    static NSString *ID = @"drop";
    HMDropdownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[HMDropdownMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *seleBg = [[UIImageView alloc] init];
        seleBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.backgroundView = seleBg;
        
    }
    
    return self;
}

- (void)setItem:(id<HMDropdownViewItem>)item{
    
    _item = item;
    
    self.textLabel.text = [item title];
    
    if ([item respondsToSelector:@selector(image)]) {
        self.imageView.image = [UIImage imageNamed:[item image]];
    }
    
    if ([item respondsToSelector:@selector(highlightedImage)]) {
        self.imageView.highlightedImage = [UIImage imageNamed:[item highlightedImage]];
    }
    
    //处理右边的箭头
    if ([item subtitles].count > 0) {
        self.accessoryView = self.rightView;
    }
    
    
}

@end
