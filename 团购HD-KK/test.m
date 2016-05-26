//
//  ViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/9.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "test.h"
#import "HMDealTool.h"
#import "HMFindDealsParam.h"
#import "HMFindDealsResult.h"
#import "HMGetSingleDealParam.h"
#import "HMGetSingleDealResult.h"

@interface ViewController ()
//@property (nonatomic,strong) HMAPITool *apiTool;
@end

@implementation ViewController

//- (HMAPITool *)apiTool{
//    
//    if (_apiTool == nil) {
//        self.apiTool = [[HMAPITool alloc] init];
//    }
//    return _apiTool;
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"city"] = @"北京";
//    
//    HMAPITool *apiTool = [HMAPITool sharedAPITool];
//    [apiTool request:@"v1/deal/find_deals" params:params success:^(id json) {
//        NSLog(@"---HMAPITool--Success");
//    } failure:^(NSError *error) {
//        NSLog(@"---HMAPITool--error");
//    }];
//
//    HMFindDealsParam *param1 = [[HMFindDealsParam alloc] init];
//    param1.city = @"北京";
//    
//    [HMDealTool findDeals:param1 succsess:^(HMFindDealsResult *result) {
//        NSLog(@"---HMDealTool--Success--%@",result.deals);
//    } failure:^(NSError *error) {
//        NSLog(@"---HMDealTool--error");
//    }];
    
    HMGetSingleDealParam *param = [[HMGetSingleDealParam alloc] init];
    param.deal_id = @"2-18390735";
    [HMDealTool getSingleDeal:param succsess:^(HMGetSingleDealResult *result) {
        if (result.deals.count == 0) {
            NSLog(@"---团购数为0---");
        }
        NSLog(@"---HMDealTool--Success--%d",result.count);
    } failure:^(NSError *error) {
        NSLog(@"---HMDealTool--error");
    }];
    
}




@end
