//
//  HMDealListViewController.m
//  团购HD-KK
//
//  Created by Kenny.li on 16/4/24.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import "HMDealListViewController.h"
#import "HMDealCell.h"
#import "HMDealDetailViewController.h"
#import "HMEmptyView.h"
@interface HMDealListViewController ()<HMDealCellDelegate>


//用于存放无数据时，显示背景
@property (nonatomic,weak) HMEmptyView *emptyView;

@end

@implementation HMDealListViewController

#pragma mark - 懒加载
- (NSMutableArray *)deals{
    
    if (_deals == nil) {
        self.deals = [NSMutableArray array];
    }
    
    return _deals;
}

- (HMEmptyView *)emptyView{
    
    if (_emptyView == nil) {
        HMEmptyView *emptyView = [HMEmptyView emptyView];
        emptyView.image = [UIImage imageNamed:self.emptyIcon];
        [self.view insertSubview:emptyView aboveSubview:self.collectionView];
        self.emptyView = emptyView;
        
    }
    return _emptyView;
}


#pragma mark - 初始化
static NSString *reuseIdentifier = @"deal1";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
 
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HMGlobelBg;
}


-(instancetype)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    return [super initWithCollectionViewLayout:layout];
}



- (void)layoutSublayersOfLayer:(CALayer *)layer{
    
    [super layoutSublayersOfLayer:layer];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    
    
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    self.emptyView.hidden = (self.deals.count > 0);

    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal1" forIndexPath:indexPath];
    cell.celldelegate = self;
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMDealDetailViewController *dealDetailVc = [[HMDealDetailViewController alloc] init];
    dealDetailVc.deal = self.deals[indexPath.item];
    [self presentViewController:dealDetailVc animated:YES completion:nil];
    
    
}


#pragma mark - 处理屏幕的旋转

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupLayout:self.view.width orientation:self.interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
#warning 这里要注意：由于是即将旋转，最后的宽度就是现在的高度
    // 总宽度
    
    CGFloat  totalWidth = self.view.height;
    [self setupLayout:totalWidth orientation:toInterfaceOrientation];
}

/**
 *  调整布局
 *
 *  @param totalWidth 总宽度
 *  @param orientation 显示的方向
 */
- (void)setupLayout:(CGFloat)totalWidth orientation:(UIInterfaceOrientation)orientation
{
    //    self.collectionViewLayout == self.collectionView.collectionViewLayout;
    // 总列数
    int columns = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    // 每一行的最小间距
    CGFloat lineSpacing = 25;
    // 每一列的最小间距
    CGFloat interitemSpacing = (totalWidth - columns * layout.itemSize.width) / (columns + 1) / 1.1;
    
    layout.minimumInteritemSpacing = interitemSpacing;
    layout.minimumLineSpacing = lineSpacing;
    // 设置cell与CollectionView边缘的间距
    layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
}

- (NSString *)emptyIcon{
    return nil;
}



@end
