//
//  GetBiddingDetailController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "GetBiddingDetailController.h"

#import "BiddingDetailModel.h"
#import "BiddingCheckingModel.h"
#import "BidDetailCell.h"
#import "BidOrderDetailController.h"



@interface GetBiddingDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BiddingCheckingModel *biddingModel;  //数据源

@end

@implementation GetBiddingDetailController

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"订单详情";
}

- (void)setBidCode:(NSString *)bidCode {
    _bidCode = bidCode;
    [self getDataFromNet];
}


//请求网络数据
- (void)getDataFromNet {
    [BiddingCheckingModel getDataWithUrl:ALREADY_BIDDING_DETAIL_API parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel, @"bidCode":self.bidCode} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.biddingModel = model;
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
    }];
}


#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.biddingModel.scorderbidArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat weight = 0.0;
    for (BiddingDetailModel *model in self.biddingModel.scorderbidArr) {
        weight += [model.tunnage floatValue];
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 20)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor darkGrayColor];
    label.text = [NSString stringWithFormat:@"总重量：%.1f吨", weight];
    [footerView addSubview:label];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidDetailCell *cell = [BidDetailCell getCellWithTable:tableView];
    cell.detailModel = self.biddingModel.scorderbidArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BidOrderDetailController *bidVC = [BidOrderDetailController new];
    bidVC.dataArr = self.biddingModel.productArr[indexPath.row];
    [self.navigationController pushViewController:bidVC animated:YES];
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
