//
//  OrderDetailController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/5.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailController.h"

#import "OrderDetailCell.h"
#import "OrderDetailModel.h"

@interface OrderDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonnull, strong) OrderDetailModel *detailModel;

@end

@implementation OrderDetailController

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
        self.tableView.tableFooterView = [UITableView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运单货物详情";
    
    [self.view addSubview:self.tableView];
}

- (void)setOrderCode:(NSString *)orderCode {
    _orderCode = orderCode;
    if (orderCode.length > 0) {
        [self getDataFromNet];
    }
}

#pragma mark -- Network

- (void)getDataFromNet {
    [OrderDetailModel getDataWithParameters:@{@"userName":[LoginModel shareLoginModel].tel.length > 0? [LoginModel shareLoginModel].tel:@"", @"orderCode":self.orderCode} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.detailModel = model;
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel *model = self.detailModel.orders[indexPath.row];
    CGFloat productCodeConstant = [BaseModel heightForTextString:model.productCode width:(kScreenWidth - 95.0)  fontSize:14.0];
    CGFloat productNameConstant = [BaseModel heightForTextString:model.productName width:(kScreenWidth - 95.0)  fontSize:14.0];
    CGFloat planCountConstant = [BaseModel heightForTextString:model.planCount width:(kScreenWidth - 95.0)  fontSize:14.0];
    return 40.0 + productCodeConstant + productNameConstant + planCountConstant;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailCell *cell = [OrderDetailCell getCellWithTable:tableView];
    cell.detailModel = self.detailModel.orders[indexPath.row];
    return cell;
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
