//
//  OrdersViewController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersViewController.h"

#import "OrderListTableCell.h"
#import "HomePageModel.h"

#import "OrderStatus212Controller.h"
#import "Mistake212Controller.h"
#import "NestedSelectStateController.h"

@interface OrdersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HomePageModel *homeModel;

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运单中心";
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MJRefreshUtil begainRefresh:self.tableView];
}

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
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.tableView andAction:@selector(getOrderListData)];
    }
    return _tableView;
}

//获取订单列表Data数据
- (void)getOrderListData {
    __weak typeof(self) weakSelf = self;
    [HomePageModel getDataWithUrl:ORDER_LIST_API parameters:@{@"driverTel":[LoginModel shareLoginModel].tel? [LoginModel shareLoginModel].tel:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            weakSelf.homeModel = model;
            if (weakSelf.homeModel.orderModelList.count <= 0) {
                [LocationManager shareManager].orderCode = nil;  //结束定位上传
                [MBProgressHUD bwm_showTitle:@"暂无订单" toView:weakSelf.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            } else {
                HomePageModel *model = weakSelf.homeModel.orderModelList[0];
                if ([model.status integerValue] > ORDER_STATUS_212) {
                    [LocationManager shareManager].orderCode = model.code;  //开启定位上传
                } else {
                    [LocationManager shareManager].orderCode = nil;  //关闭定位上传
                }
            }
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:weakSelf.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
        [MJRefreshUtil endRefresh:weakSelf.tableView];
    }];
}

#pragma mark -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeModel.orderModelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.homeModel.orderModelList[indexPath.row];
    CGFloat startNameConstant = [BaseModel heightForTextString:model.sourceName width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat startAddConstant = [BaseModel heightForTextString:model.sourceAddr width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat endDcNameConstant = [BaseModel heightForTextString:model.dcName width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat endDcAddConstant = [BaseModel heightForTextString:model.dcAddress width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat height = startNameConstant + startAddConstant + endDcNameConstant + endDcAddConstant + 50.0 + 20 + 30;
    return height < 130.0? 130.0:height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableCell *cell = [OrderListTableCell getCellWithTable:tableView];
    cell.orderModel = self.homeModel.orderModelList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.homeModel.orderModelList[indexPath.row];
    [self jumpToControllerWithParaModel:model];
}

//KA界面跳转逻辑
- (void)jumpToControllerWithParaModel:(HomePageModel *)model {
    NSInteger status = model.status.integerValue;
    NSLog(@"status:%ld", status);
    switch (status) {
        case ORDER_STATUS_212://待接收
        {
            OrderStatus212Controller *orderVC = [OrderStatus212Controller new];
            orderVC.homePageModel = model;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
            
        case ORDER_STATUS_220://已接收待签到
        case ORDER_STATUS_224://已签到待入厂
        case ORDER_STATUS_225:
        case ORDER_STATUS_226://已入厂待装货
        case ORDER_STATUS_227:
        case ORDER_STATUS_228://已装货未装货完成
        case ORDER_STATUS_230://装货完成待出厂
        case ORDER_STATUS_232://装货完成待出厂
        case ORDER_STATUS_244://收货完成
        case ORDER_STATUS_248://运单结束
        {
            NestedSelectStateController *nestVC = [NestedSelectStateController new];
            [self.navigationController pushViewController:nestVC animated:YES];
            nestVC.homePageModel = model;
        }
            break;
            
        default:
            break;
    }
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
