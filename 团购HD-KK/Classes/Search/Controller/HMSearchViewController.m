//
//  HMSearchViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/29.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDealTool.h"
#import "HMCity.h"
#import "MJRefresh.h"
@interface HMSearchViewController ()<UISearchBarDelegate>
@property (nonatomic,strong)HMFindDealsParam *lastParam;
@property (nonatomic,weak) UISearchBar *searchBar;
@end

@implementation HMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.搜索
    UIView *titleView = [[UIView alloc] init];
    titleView.height = 35;
    titleView.width = 400;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [titleView addSubview:searchBar];
    [searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    //2.左上返回按钮
    UIBarButtonItem *backBtn = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //3.集成下拉刷新
    [self setRefresh];
    
}

- (void)setRefresh{
    
    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
//    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
    
}

- (void)loadMoreData{
    
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    param.page = @(self.lastParam.page.integerValue + 1);
    
    NSString *keyWord = self.searchBar.text;
    param.keyword = keyWord;
    param.city = self.selectedCity.name;
    
    [HMDealTool findDeals:param succsess:^(HMFindDealsResult *result) {
        if (param != self.lastParam) return;//请求过期~~~~
        
        //最新数据加到旧的数据后面
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        //不符合就返回，防止多次请求,请求过期情况
        if (param != self.lastParam) return;
        [self.collectionView.mj_footer endRefreshing];
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试~"];
        //刷新失败页码要返回之前的~
        param.page = @(param.page.integerValue - 1);
    }];
    
    //3.设置请求参数
    self.lastParam = param;
}







- (NSString *)emptyIcon{
    
    return @"icon_deals_empty";
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController.view endEditing:YES];//键盘不属于控制器的view
    [MBProgressHUD showMessage:@"正在搜索团购" toView:self.navigationController.view];
    
    NSString *keyWord = searchBar.text;
    
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    param.keyword = keyWord;
    param.city = self.selectedCity.name;
    param.page = @1;
    [HMDealTool findDeals:param succsess:^(HMFindDealsResult *result) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MBProgressHUD showError:@"加载团购失败，请稍后再试" toView:self.navigationController.view];
    }];
    
    self.lastParam = param;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    
    
}





@end
