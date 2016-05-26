//
//  HMCitySearchViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/14.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMCitySearchViewController.h"

@interface HMCitySearchViewController ()
@property (nonatomic,strong)NSArray *reslutCityies;
@property (nonatomic,strong)NSArray *allCities;
@end

@implementation HMCitySearchViewController

- (NSArray *)allCities{
    
    if (_allCities == nil) {
        self.allCities = [HMMetaDataTool sharedMetaDataTool].cities;
    }
    return _allCities;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void)setSearchText:(NSString *)searchText{
    
    _searchText = searchText;
    
    NSString *lowSearchText = searchText.lowercaseString;
    
    NSPredicate *predcate =[NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",lowSearchText,lowSearchText,lowSearchText] ;
    self.reslutCityies = [self.allCities filteredArrayUsingPredicate:predcate];
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.reslutCityies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.创建cell
    static NSString *ID = @"cityresult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    HMCity *city = self.reslutCityies[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMCity *city = self.reslutCityies[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HMCityDidSelectNotification object:nil userInfo:@{HMCitySelected : city}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
