//
//  HMDropdownSubCell.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDropdownSubCell.h"

@implementation HMDropdownSubCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    //1.创建cell
    static NSString *ID = @"drop";
    HMDropdownSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[HMDropdownSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        self.backgroundView = bg;
        
        UIImageView *seleBg = [[UIImageView alloc] init];
        seleBg.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        self.backgroundView = seleBg;
    }
    
    return self;
}

@end
