//
//  HMDealDetailViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/20.
//  Copyright (c) 2016年 KK. All rights reserved.

//    NSLogg(@"str %@--deal_id %@",str,self.deal.deal_id);
//    str http://lite.m.dianping.com/API4nquzEd--deal_id 4-18306498
//    http://m.dianping.com/tuan/deal/moreinfo/18306498 详情界面，现在可以直接访问


#import "HMDealDetailViewController.h"
#import "HMDeal.h"
#import "HMDealLabel.h"
#import "HMMetaDataTool.h"
#import "HMGetSingleDealParam.h"
#import "HMDealTool.h"
#import "HMRestriction.h"
#import "HMDealLocalTool.h"

//#import "UMSocial.h"
#import "UIImageView+WebCache.h"

@interface HMDealDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,weak) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

//方法
- (IBAction)back;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
// label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;


// 按钮
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpiresButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountButton;


@end

@implementation HMDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMGlobelBg;
    self.webView.backgroundColor = HMGlobelBg;
    
    //1.存储浏览记录
    [[HMDealLocalTool sharedDealLocalTool] saveHistoryDeal:self.deal];
    
    //2.加载右边的内容
    [self setupRightContent];
    
    //3.左边内容
    [self setupLeftContent];
    
    //4.判断是否收藏过
    self.collectBtn.selected = [[HMDealLocalTool sharedDealLocalTool].collectDeals containsObject:self.deal];
    
}

#pragma mark - 设置左边表格数据

- (void)setupRightContent{
    
    NSString *ID = self.deal.deal_id;
    ID = [ID substringFromIndex:[ID rangeOfString:@"-"].location + 1];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
    //    NSLogg(@"%@-------------------------------",urlStr);
    // 显示网页内容
    self.webView.scrollView.hidden = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    //圈圈
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.webView addSubview:loadingView];
    //居中
    [loadingView autoCenterInSuperview];
    self.loadingView = loadingView;
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    NSLogg(@"%@",request.allHTTPHeaderFields);
    return YES;
}


#pragma mark -JS 去广告
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    //JS 去广告
    NSMutableString *js = [NSMutableString string];
    [js appendString:@"var bodyHTML = '';"];
    // 拼接link的内容
    [js appendString:@"var link = document.body.getElementsByTagName('link')[0];"];
    [js appendString:@"bodyHTML += link.outerHTML;"];
    // 拼接多个div的内容
    [js appendString:@"var divs = document.getElementsByClassName('detail-info');"];
    [js appendString:@"for (var i = 0; i<=divs.length; i++) {"];
    [js appendString:@"var div = divs[i];"];
    [js appendString:@"if (div) { bodyHTML += div.outerHTML; }"];
    [js appendString:@"}"];
    // 设置body的内容
    [js appendString:@"document.body.innerHTML = bodyHTML;"];
    
    // 执行JS代码
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    // 显示网页内容
    webView.scrollView.hidden = NO;
  
    
//    // 拼接详情的URL路径
//    NSString *ID = self.deal.deal_id;
//    ID = [ID substringFromIndex:[ID rangeOfString:@"-"].location + 1];
//    NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
//    
//    if ([webView.request.URL.absoluteString isEqualToString:urlStr]) { // 加载详情页面完毕
//        NSMutableString *js = [NSMutableString string];
//        [js appendString:@"var bodyHTML = '';"];
//        // 拼接link的内容
//        [js appendString:@"var link = document.body.getElementsByTagName('link')[0];"];
//        [js appendString:@"bodyHTML += link.outerHTML;"];
//        // 拼接多个div的内容
//        [js appendString:@"var divs = document.getElementsByClassName('detail-info');"];
//        [js appendString:@"for (var i = 0; i<=divs.length; i++) {"];
//        [js appendString:@"var div = divs[i];"];
//        [js appendString:@"if (div) { bodyHTML += div.outerHTML; }"];
//        [js appendString:@"}"];
//        // 设置body的内容
//        [js appendString:@"document.body.innerHTML = bodyHTML;"];
//        
//        // 执行JS代码
//        [webView stringByEvaluatingJavaScriptFromString:js];
//        
//        // 显示网页内容
//        webView.scrollView.hidden = NO;
//        // 移除圈圈
//        [self.loadingView removeFromSuperview];
//    } else { // 加载初始网页完毕
//        NSString *js = [NSString stringWithFormat:@"window.location.href = '%@';", urlStr];
//        [webView stringByEvaluatingJavaScriptFromString:js];
//    }


}


#pragma mark - 设置左边表格数据

- (void)setupLeftContent{
    
    //设置剩余内容
    [self updateLeftContent];//先更新一次，这次的数据是deal传的，不是很详细
    
    HMGetSingleDealParam *param = [[HMGetSingleDealParam alloc] init];
    param.deal_id = self.deal.deal_id;
    
    [HMDealTool getSingleDeal:param succsess:^(HMGetSingleDealResult *result) {
        
        if (result.deals.count) {
            self.deal = [result.deals lastObject];
            [self updateLeftContent];//之前设置了一遍，但是不是最新最详细，没有下面的数据，现在再设置一遍
        }else{
            [MBProgressHUD showError:@"没有找到指定团购数据"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"加载团购数据失败"];
    }];
    
}


- (void)updateLeftContent{
  
    
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    self.currentPriceLabel.text = [self priceStr:self.deal.current_price];
    self.listPriceLabel.text = [self priceStr:self.deal.list_price];
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpiresButton.selected = self.deal.restrictions.is_refundable;
    self.purchaseCountButton.title = [NSString stringWithFormat:@"已售出%d", self.deal.purchase_count];
    
    //设置图片 大图
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    //设置过期时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadTime = [[fmt dateFromString:self.deal.purchase_deadline] dateByAddingTimeInterval:24 * 3600];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cpms = [calendar components:unit fromDate:now toDate:deadTime options:0];
    
    if (cpms.day > 365) {
        self.leftTimeButton.title = @"一年之内不过期";
    }else{
    
    self.leftTimeButton.title = [NSString stringWithFormat:@"%ld天%ld小时%ld分",(long)cpms.day,(long)cpms.hour,(long)cpms.minute];
    }
}



#pragma mark - 点击按钮的方法

- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)buy{
    
}
- (IBAction)collect{
    
    if (self.collectBtn.selected) {//收藏过，现在取消收藏
        self.collectBtn.selected = NO;
        [[HMDealLocalTool sharedDealLocalTool] unsaveCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功！"];
        [MBProgressHUD hideHUD];
    }else{
        self.collectBtn.selected = YES;
        [[HMDealLocalTool sharedDealLocalTool] saveCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功！"];
        [MBProgressHUD hideHUD];

        
    }
    
    
}

- (IBAction)share{
    
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
//    
//    [UMSocialSnsService presentSnsController:self appKey:UMAPPKey shareText:@"1111" shareImage:[UIImage imageNamed:@"ic_deal_new"] shareToSnsNames:@[UMShareToSina,UMShareToWechatSession] delegate:nil];
    
//    NSString *shareText = [NSString stringWithFormat:@"[%@]%@ 详情查看:%@",self.deal.title,self.deal.desc,self.deal.deal_h5_url];
    UIImage *image = nil;
    if (self.bigImageView.image != [UIImage imageNamed:@"placeholder_deal"]) {//不是占位图片
        image = self.bigImageView.image;
    }
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMAPPKey
//                                      shareText:shareText
//                                     shareImage:image
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToTencent,UMShareToSina,UMShareToRenren,nil]
//                                       delegate:nil];

}

- (NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskLandscape;

    
}



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

@end
