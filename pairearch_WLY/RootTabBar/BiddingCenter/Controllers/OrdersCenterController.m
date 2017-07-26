//
//  OrdersCenterController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCenterController.h"

#import "OrdersCollectionCell.h"
#import "OrderListModel.h"
#import "BiddingDetailController.h"
#import "BiddingCheckingController.h"
#import "GetBiddingDetailController.h"


@interface OrdersCenterController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic, strong) UIButton *selectedBtn;  //已经选中的Button

@property (nonatomic, strong) UIView *markView; //按钮标记view

//@property (nonatomic, strong) NSMutableArray *reloadFlags;  //table刷新标识
//
//@property (nonatomic, strong) OrdersCollectionCell *currentCell;  //当前显示的cell

@end

@implementation OrdersCenterController

#pragma mark -- LazyLoding

- (UIView *)markView {
    if (!_markView) {
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.selectView.bounds) - 2, kScreenWidth / 4.0, 2)];
        self.markView.backgroundColor = MAIN_THEME_COLOR;
    }
    return _markView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //初始化刷新标识
//    self.reloadFlags = [NSMutableArray arrayWithArray:@[@1, @1, @1, @1]];
    
    self.collectionView.pagingEnabled = YES;
    
    [self.selectView addSubview:self.markView];
        
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + i)];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_THEME_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController.selectedIndex != 2) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //刷新页面
    [self.collectionView reloadData];
}

#pragma mark -- ButtonActions
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 100) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self resetMarkViewPositionWithIndex:sender.tag - 100];
}

#pragma mark -- CommoMethods

- (void)resetMarkViewPositionWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        self.markView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.selectView.bounds) * index / 4.0, 0.0);
    }];
}

//刷新当前的列表
//- (void)reloadListData:(NSNotification *)sender {
//    for (NSInteger i = 0; i < 3; i++) {
//        [self.reloadFlags replaceObjectAtIndex:i withObject:@1];
//    }
//    if (self.currentCell) {
//        [MJRefreshUtil begainRefresh:self.currentCell.listTableView];
//        [self.reloadFlags replaceObjectAtIndex:self.currentCell.indexPath.item withObject:@0];
//    }
//}


#pragma mark -- DelegateMethods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 47);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCollectionCell *cell = [OrdersCollectionCell getCellWithCollectionView:collectionView indexPath:indexPath pushBlock:^(NSArray *selectModelArr, NSIndexPath *indexPath) {
        if (indexPath.item == 0) {
            if (selectModelArr.count > 0) {
                OrderListModel *model = selectModelArr[0];
                BiddingDetailController *bidDetailVC = [BiddingDetailController new];
                bidDetailVC.bidCode = model.bidCode;
                [self.navigationController pushViewController:bidDetailVC animated:YES];
            }
        } else if (indexPath.item == 1) {
            BiddingCheckingController *biddingCheckingVC = [BiddingCheckingController new];
            OrderListModel *model = selectModelArr[0];
            biddingCheckingVC.bidCode = model.bidCode;
            [self.navigationController pushViewController:biddingCheckingVC animated:YES];
        } else {
            GetBiddingDetailController *biddingDetailVC = [GetBiddingDetailController new];
            OrderListModel *model = selectModelArr[0];
            biddingDetailVC.bidCode = model.bidCode;
            [self.navigationController pushViewController:biddingDetailVC animated:YES];
        }
    }];
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
//    NSNumber *flag = self.reloadFlags[indexPath.item];
//    if ([flag boolValue]) {
//        OrdersCollectionCell *tempCell = (OrdersCollectionCell *)cell;
//        [MJRefreshUtil begainRefresh:tempCell.listTableView];
//    }
//    self.currentCell = (OrdersCollectionCell *)cell;
    OrdersCollectionCell *tempCell = (OrdersCollectionCell *)cell;
    [MJRefreshUtil begainRefresh:tempCell.listTableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        [self resetMarkViewPositionWithIndex:index];
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + index)];
        if (index + 100 == btn.tag) {
            [self selectButtonAction:btn];
        }
    }
}


- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
