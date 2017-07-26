//
//  OutStorage220Controller.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/26.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OutStorage220Controller.h"

#import "Mistake212Header.h"
#import "ButtonFooterView.h"
#import "HomeTableCell.h"
#import "OrderDetailController.h"
#import "TZImageManager.h"


#define HEIGHT_FOR_HEADER  25.0
#define HEIGHT_FOR_FOOTER  60.0

@interface OutStorage220Controller ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Mistake212Header *headerView;

@property (nonatomic, strong) ButtonFooterView *footerView;

@end

@implementation OutStorage220Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (Mistake212Header *)headerView {
    if (!_headerView) {
        self.headerView = [Mistake212Header getHeaderView];
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 20);
    }
    return _headerView;
}

- (ButtonFooterView *)footerView {
    if (!_footerView) {
        self.footerView = [ButtonFooterView getFooterButtonView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 150);
        [self.footerView.footerButton addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.footerView.buttonTitle = @"装货签到";
    }
    return _footerView;
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
    NSString *tempStr = self.homePageModel.planDate;
    if (tempStr.length > 0) {
        self.headerView.planTimeLabel.text = tempStr;
    } else {
        self.headerView.planTimeLabel.text = @"承运商未预约时间";
    }
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.homePageModel;
    CGFloat startNameConstant = [BaseModel heightForTextString:model.sourceName width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat startAddConstant = [BaseModel heightForTextString:model.sourceAddr width:(kScreenWidth - 85.0) fontSize:16.0];
    CGFloat endDcNameConstant = [BaseModel heightForTextString:model.dcName width:(kScreenWidth - 85.0) fontSize:13.0];
    CGFloat endDcAddConstant = [BaseModel heightForTextString:model.dcAddress width:(kScreenWidth - 85.0) fontSize:13.0];
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

- (void)footerButtonAction:(UIButton *)sender {
    //选择图片并且上传
    NSString *userName = [LoginModel shareLoginModel].tel;
    NSString *orderCode = self.homePageModel.code;
    CLLocation *location =  [LocationManager shareManager].location;
    NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationTime = [dateFormatter stringFromDate:location.timestamp];
    NSDictionary *paraDict = @{@"userName":userName,
                               @"orderCode":orderCode,
                               @"lat":lat,
                               @"lng":lng,
                               @"locationTime":locationTime};
    
//    [MyImagePickerManager presentPhotoTakeControllerInTarget:self finishPickingBlock:nil postUrlStr:SIGN_UP_API paraDict:paraDict endBlock:^(id responseObject, NSError *error) {
//        if (!error) {
//            NSString *remark = responseObject[@"remark"];
//            [ProgressHUD bwm_showTitle:remark toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//            NSLog(@"%@", responseObject);
//            
//        } else {
//            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//        }
//    }];
    
    //外仓装货工厂签到
    [NetworkHelper POST:SIGN_UP_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *remark = responseObject[@"remark"];
        [ProgressHUD bwm_showTitle:remark toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        NSLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
    
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
