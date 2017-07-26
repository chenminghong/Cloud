//
//  OrderStatus212Controller.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatus212Controller.h"

#import "HomePageModel.h"
#import "HomeTableCell.h"
#import "Header212View.h"
#import "FooterSelectView.h"
#import "SafetyControlController.h"
#import "Mistake212Controller.h"
#import "OrderDetailController.h"


#define HEIGHT_FOR_HEADER  50.0
#define HEIGHT_FOR_FOOTER  80.0

@interface OrderStatus212Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Header212View *headerView;

@property (nonatomic, strong) FooterSelectView *footerView;

@end

@implementation OrderStatus212Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运单详情";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    
    [self.view addSubview:self.tableView];
    
    //请求首页数据
//    [self getHomePageData];
    
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
    }
    return _tableView;
}

- (Header212View *)headerView {
    if (!_headerView) {
        self.headerView = [Header212View getHeaderView];
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, HEIGHT_FOR_HEADER);
        [self.headerView.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.scanButton addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (FooterSelectView *)footerView {
    if (!_footerView) {
        self.footerView = [FooterSelectView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, HEIGHT_FOR_FOOTER);
        [self.footerView.selectButton addTarget:self action:@selector(getLoadAAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}


#pragma mark -- Get Data

//获取首页Data数据
- (void)getHomePageData {
    [HomePageModel getDataWithUrl:HOME_PAGE_DATA_API parameters:@{@"mobile":[LoginModel shareLoginModel].tel? [LoginModel shareLoginModel].tel:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.homePageModel = model;
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_FOR_HEADER;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HEIGHT_FOR_FOOTER;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView.planTimeLabel.text = self.homePageModel.planDate;
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.homePageModel;
    CGFloat startNameConstant = [BaseModel heightForTextString:model.sourceName width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat startAddConstant = [BaseModel heightForTextString:model.sourceAddr width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat endDcNameConstant = [BaseModel heightForTextString:model.dcName width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat endDcAddConstant = [BaseModel heightForTextString:model.dcAddress width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat height = startNameConstant + startAddConstant + endDcNameConstant + endDcAddConstant + 50.0 + 20;
    return height < 130.0? 130.0:height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableCell *cell = [HomeTableCell getCellWithTable:tableView];
    cell.homeModel = self.homePageModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailController *orderDetailVC = [OrderDetailController new];
    orderDetailVC.orderCode = self.homePageModel.code;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark -- 按钮点击事件


/**
 选中按钮点击事件

 @param sender 选中按钮
 */
- (void)selectedButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%d", sender.selected);
}

/**
 工厂要求和管理按钮点击事件

 @param sender 预览按钮
 */
- (void)scanButtonAction:(UIButton *)sender {
    SafetyControlController *safetyVC = [SafetyControlController new];
    [self.navigationController pushViewController:safetyVC animated:YES];
}


/**
 返回按钮点击事件

 @param sender 返回按钮
 */
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 接收运单操作

 @param sender 接收运单按钮
 */
- (void)getLoadAAction:(UIButton *)sender {
    if (self.headerView.selectedButton.selected) {
        [NetworkHelper POST:GET_LOAD_API parameters:@{@"userName":[LoginModel shareLoginModel].tel, @"orderCode":self.homePageModel.code} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *result = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([result boolValue]) {
                MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"订单接收成功！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
                [LocationManager shareManager].orderCode = self.homePageModel.code;  //开启定位上传
                [hud setCompletionBlock:^() {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                [MBProgressHUD bwm_showTitle:@"订单接收失败！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }];
    } else {
        [MBProgressHUD bwm_showTitle:@"请阅读工厂相关要求和管理规定！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
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
