//
//  BiddingCheckingController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BiddingCheckingController.h"

#import "BiddingCheckingModel.h"
#import "BiddingDetailModel.h"
#import "BidDetailCell.h"
#import "BidOrderDetailController.h"
#import "BidCheckingFooterView.h"


@interface BiddingCheckingController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *changeBiddingBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBiddingBtn;
@property (nonatomic, strong) BiddingCheckingModel *biddingModel;  //数据源

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BidCheckingFooterView *footerView;   //页脚

@property (nonatomic, strong) UITextField *changeBiddingTf;        //修改竞价输入框

@end

@implementation BiddingCheckingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.changeBiddingBtn.backgroundColor = MAIN_THEME_COLOR;
    self.cancelBiddingBtn.backgroundColor = MAIN_THEME_COLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"审核中";
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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (BidCheckingFooterView *)footerView {
    if (!_footerView) {
        self.footerView = [BidCheckingFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 175.0);
    }
    return _footerView;
}

- (void)setBidCode:(NSString *)bidCode {
    _bidCode = bidCode;
    if (bidCode.length > 0) {
        [self loadDataFromNet];
    }
}

//  请求网络数据
- (void)loadDataFromNet{
    [BiddingCheckingModel getDataWithUrl:BIDDINF_CHECKING_API parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel, @"bidCode":self.bidCode} endBlock:^(id model, NSError *error) {
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
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat weight = 0.0;
    for (BiddingDetailModel *model in self.biddingModel.scorderbidArr) {
        weight += [model.tunnage floatValue];
    }
    self.footerView.tonnageLabel.text = [NSString stringWithFormat:@"总重量：%.1f吨", weight];
    
    BiddingDetailModel *model = self.biddingModel.biddingDetailModel;
    self.footerView.supplierLabel.text = [NSString stringWithFormat:@"承运商：%@", model.supplierName];
    
    model = self.biddingModel.biddingDetailModel;
    self.footerView.plateNumberLabel.text = [NSString stringWithFormat:@"车牌号：%@", model.truckNumber];
    
    model = self.biddingModel.scorderbidArr.count>0? self.biddingModel.scorderbidArr[0]:nil;
    self.footerView.deadLineTime = model.deadlineTime;
    
    self.footerView.priceLabel.text = [NSString stringWithFormat:@"%.2f元/车(含税)", [self.biddingModel.amount floatValue]];
    
    [self.footerView.changeBidButton addTarget:self action:@selector(changeBiddingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView.cancelBidButton addTarget:self action:@selector(cancelBiddingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return self.footerView;
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

#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 当前输入的字符是'.'
    if ([string isEqualToString:@"."]) {
        // 已输入的字符串中已经包含了'.'或者""
        if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
            return NO;
        } else {
            return YES;
        }
    } else {// 当前输入的不是'.'
        // 第一个字符是0时, 第二个不能再输入0
        if (textField.text.length == 1) {
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {
                return NO;
            }
            if (str != '0' && str != '1') {// 1xx或0xx
                return YES;
            } else {
                if (str == '1') {
                    return YES;
                } else {
                    if ([string isEqualToString:@""]) {
                        return YES;
                    } else {
                        return NO;
                    }
                }
            }
        }
        // 已输入的字符串中包含'.'
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
            [str insertString:string atIndex:range.location];
            if (str.length > [str rangeOfString:@"."].location + 4) {
                return NO;
            }
            NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
        }
        //        else {
        //            if (textField.text.length > 5) {
        //                return range.location < 6;
        //            }
        //        }
    }
    return YES;
}

#pragma mark -- 按钮点击事件



/**
 修改竞价

 @param sender 修改竞价按钮
 */
- (void)changeBiddingAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入价格" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.delegate = weakSelf;
        weakSelf.changeBiddingTf = textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf changeBiddingPost];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 取消竞价按钮事件
 
 @param sender 取消竞价按钮
 */
- (void)cancelBiddingAction:(UIButton *)sender {
    [self cancelBiddingPost];
}



/**
 修改竞价请求
 */
- (void)changeBiddingPost {
    if (!self.changeBiddingTf) {
        return;
    }
    if ([self.changeBiddingTf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        [MBProgressHUD bwm_showTitle:@"输入的价格有误！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    __weak MBProgressHUD *hud1 = [MBProgressHUD bwm_showHUDAddedTo:self.view title:kBWMMBProgressHUDMsgLoading animated:YES];
    [[NetworkHelper shareClientBidd] POST:CHANGE_BIDDING_API parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel, @"bidCode":self.bidCode, @"price":self.changeBiddingTf.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud1 hide:NO];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.biddingModel.amount = responseObject[@"amount"];
        if ([responseObject[@"amount"] length] > 0 && [self.biddingModel.amount floatValue] > 0.0) {
            self.footerView.priceLabel.text = [NSString stringWithFormat:@"%.2f元/车(含税)", [self.biddingModel.amount floatValue]];
        }
        [ProgressHUD bwm_showTitle:responseObject[@"updateResult"] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud1 hide:NO];
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}



/**
 取消竞价请求
 */
- (void)cancelBiddingPost {
    __weak MBProgressHUD *hud1 = [MBProgressHUD bwm_showHUDAddedTo:self.view title:kBWMMBProgressHUDMsgLoading animated:YES];
    [[NetworkHelper shareClientBidd] POST:CANCEL_BIDDING_API parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel, @"bidCode":self.bidCode} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [hud1 hide:NO];
        MBProgressHUD *hud2 = [ProgressHUD bwm_showTitle:responseObject[@"deleteResult"] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        [hud2 setCompletionBlock:^(){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud1 hide:NO];
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
