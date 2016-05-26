//
//  HMDropdownView.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/13.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDropdownView.h"
#import "HMDropdownMainCell.h"
#import "HMDropdownSubCell.h"

@interface HMDropdownView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@end

@implementation HMDropdownView

+ (instancetype)menu{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HMDropdownView" owner:nil options:nil] firstObject];
    
}



#pragma mark - 公共方法
- (void)setItems:(NSArray *)items{

    _items = items;
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}


- (void)selectMain:(NSUInteger)mainRow{
    
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.subTableView reloadData];
}

- (void)selectSub:(NSUInteger)subRow{
    
     [self.subTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:subRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}




#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView == self.mainTableView) {
        return self.items.count;
    }else{
        
        NSInteger mainRow = [self.mainTableView indexPathForSelectedRow].row;
        id<HMDropdownViewItem> item = self.items[mainRow];
        return [item subtitles].count;
    }
    
    
}

//在这个方法中发通知，不能确定发出的Items是哪个数据。应该通过代理传给Vc，让Vc来通知
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mainTableView) { //选中左边---主表
        //刷新右边subTable
        [self.subTableView reloadData];
        
        //通知代理
        if([self.delegate respondsToSelector:@selector(dropMenu:didSelectedMain:)]){
            
            [self.delegate dropMenu:self didSelectedMain:indexPath.row];
        }
        
    }else{//选中右边---从表 --->选中之后通过代理传给Vc
        
         //通知代理
        if([self.delegate respondsToSelector:@selector(dropMenu:didSelectedSub:ofMain:)]){
            NSIndexPath *mainIndexPath = [self.mainTableView indexPathForSelectedRow];
            [self.delegate dropMenu:self didSelectedSub:indexPath.row ofMain:mainIndexPath.row];
        }
    }
    
}



#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.mainTableView) {
        HMDropdownMainCell *mainCell = [HMDropdownMainCell cellWithTableView:tableView];
        mainCell.item = self.items[indexPath.row];
        return mainCell;
    }else{
        
        NSInteger mainRow = [self.mainTableView indexPathForSelectedRow].row;
        id<HMDropdownViewItem> item = self.items[mainRow];
        
        HMDropdownSubCell *subCell = [HMDropdownSubCell cellWithTableView:tableView];
        subCell.textLabel.text = [item subtitles][indexPath.row];
        return subCell;
        
    }
}





@end
