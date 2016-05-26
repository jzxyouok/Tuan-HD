//
//  HMChangeCitiesViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/14.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMChangeCitiesViewController.h"
#import "HMCitySearchViewController.h"
#import "HMCityGroup.h"

@interface HMChangeCitiesViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)closeChangeCity;
@property (weak, nonatomic) IBOutlet UIButton *coverView;
- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopLc;

/**检索城市*/
@property (nonatomic,strong)NSArray *cityGroups;
/**搜索结果栏*/
@property (nonatomic,weak)HMCitySearchViewController *citySearchVc;

@end

@implementation HMChangeCitiesViewController

#pragma mark - 懒加载

- (NSArray *)cityGroups{
    if (_cityGroups == nil) {
        self.cityGroups = [HMMetaDataTool sharedMetaDataTool].cityGroups;
    }
    return _cityGroups;
}

- (HMCitySearchViewController *)citySearchVc{
    
    if (_citySearchVc == nil) {
        HMCitySearchViewController *citySearchVc = [[HMCitySearchViewController alloc] init];
        [self addChildViewController:citySearchVc];//vc也是父子关系，dismiss一起消失
        self.citySearchVc = citySearchVc;
    }
    return _citySearchVc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)closeChangeCity {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)coverClick {
    
    [self.view endEditing:YES];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    //如果正在dismiss，则不需要执行下面步骤
    if (self.isBeingDismissed) return;
        
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.navBarTopLc.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        
        self.coverView.alpha = 0;
    }];
    
    searchBar.text = nil;
    [self.citySearchVc.view removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    [searchBar setShowsCancelButton:YES animated:YES];
    self.navBarTopLc.constant = -62;
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        
        self.coverView.alpha = 0.6;
    }];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.citySearchVc.view removeFromSuperview];
    if (searchText.length > 0) {
        [self.view addSubview:self.citySearchVc.view];
        [self.citySearchVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchBar];
        [self.citySearchVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        self.citySearchVc.searchText = searchText;
    }
    
    
}


#pragma mark - 让控制器在formSheet情况下也能正常退出键盘
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    return NO;
}




#pragma mark - UITableViewDelegate,UITableViewDataSourse


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.cityGroups.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HMCityGroup *group = self.cityGroups[section];
    return group.cities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.创建cell
    static NSString *ID = @"cities";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    HMCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    HMCityGroup *group = self.cityGroups[section];
    return group.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return [self.cityGroups valueForKeyPath:@"title"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     HMCityGroup *group = self.cityGroups[indexPath.section];
     NSString *cityName = group.cities[indexPath.row];
     HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:cityName];
     [[NSNotificationCenter defaultCenter] postNotificationName:HMCityDidSelectNotification object:nil userInfo:@{HMCitySelected : city}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
