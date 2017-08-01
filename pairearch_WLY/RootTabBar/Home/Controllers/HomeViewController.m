//
//  HomeViewController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomeViewController.h"

#import "LoginViewController.h"
#import "PaomaLabel.h"
#import "WQLPaoMaView.h"
#import "HomeTableCell.h"
#import "HomePageModel.h"
#import "OrderStatus212Controller.h"
#import "Mistake212Controller.h"
#import "BiddingListController.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView; //顶部banner
@property (weak, nonatomic) IBOutlet UIButton *telButton;  //拨打电话按钮
@property (nonatomic, strong) PaomaLabel *noticeContentL;  //通知公告栏
@property (nonatomic, strong) WQLPaoMaView *paoma;  //公告栏；

@property (nonatomic, strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *assortLabel;

@property (weak, nonatomic) IBOutlet UILabel *assortDesLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (nonatomic, strong) UIButton *stateButton;  //底部接单按钮

@property (nonatomic, strong) HomePageModel *homePageModel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.paoma];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.stateButton];
    self.telButton.hidden = YES;
    [MJRefreshUtil pullDownRefresh:self andScrollView:self.tableView andAction:@selector(getHomePageData)];
    
    self.stateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.topLineView.backgroundColor = MAIN_THEME_COLOR;
    self.bottomLineView.backgroundColor = MAIN_THEME_COLOR;
    self.assortLabel.backgroundColor = MAIN_THEME_COLOR;
    self.assortLabel.layer.masksToBounds = YES;
    self.assortLabel.layer.cornerRadius = CGRectGetWidth(self.assortLabel.bounds) / 2.0;
    
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = (kScreenWidth * 6) / 32 / 2.0;
    
    self.userNameLabel.textColor = UIColorFromRGB(0x666666);
    self.userNumberLabel.textColor = UIColorFromRGB(0x666666);
    
    self.bannerView.backgroundColor = TOP_BOTTOMBAR_COLOR;
    
    //从后台到前台开始动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotificationAction) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController.selectedIndex != 0) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    self.userNameLabel.text = [LoginModel shareLoginModel].name;
    self.userNumberLabel.text = [LoginModel shareLoginModel].tel;

    [self.paoma startAnimation];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //获取首页Data数据
    [MJRefreshUtil begainRefresh:self.tableView];
}

//程序活跃的时候调用
- (void)applicationDidBecomeActiveNotificationAction {
    [self paomaViewStartAnimation];
}

//开始跑马灯
- (void)paomaViewStartAnimation {
    if (self.tabBarController.selectedIndex == 0) {
        [self.paoma startAnimation];
    }
}

#pragma mark -- LazyLoading

- (WQLPaoMaView *)paoma {
    if (!_paoma) {
        self.paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.frame.size.width, 40) withTitle:@"Copyright©2017 云仓配供应链管控平台"];
        [self.view addSubview:self.paoma];
        [self.paoma mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
        self.paoma.backgroundColor = MAIN_THEME_COLOR;
    }
    return _paoma;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.bottomView.mas_top);
            make.right.equalTo(self.view.mas_right);
        }];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UITableView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)stateButton {
    if (!_stateButton) {
        self.stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stateButton.backgroundColor = MAIN_THEME_COLOR;
        [self.stateButton setTitle:@"查看详情" forState:UIControlStateNormal];
        self.stateButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:self.stateButton];
        [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(self.view.mas_width).dividedBy(3.0);
            make.height.mas_equalTo(40);
        }];
        [self.stateButton addTarget:self action:@selector(getLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateButton;
}


#pragma mark -- Get Data

//获取首页Data数据
- (void)getHomePageData {
    [HomePageModel getDataWithUrl:HOME_PAGE_DATA_API parameters:@{@"mobile":[LoginModel shareLoginModel].tel? [LoginModel shareLoginModel].tel:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.homePageModel = model;
            if (self.homePageModel.orderModelList.count > 0) {
                HomePageModel *model = self.homePageModel.orderModelList[0];
                if ([model.status integerValue] > ORDER_STATUS_212) {
                    [LocationManager shareManager].orderCode = model.code;  //开启定位上传
                } else {
                    [LocationManager shareManager].orderCode = nil;   //结束定位上传
                }
            } else {
                [LocationManager shareManager].orderCode = nil;   //结束定位上传
            }
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        self.assortDesLabel.text = [NSString stringWithFormat:@"您有%ld个运单可抢", (long)self.homePageModel.bidcount.integerValue];
        [self.tableView reloadData];
        [MJRefreshUtil endRefresh:self.tableView];
        if ([self.homePageModel.loadResult integerValue] == 0) {
            [self.stateButton setTitle:@"暂无订单" forState:UIControlStateNormal];
        } else {
            [self.stateButton setTitle:@"点击查看详情" forState:UIControlStateNormal];
        }
    }];
}

//设置不同字体颜色
- (void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

#pragma mark -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homePageModel.orderModelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.homePageModel.orderModelList[indexPath.row];
    CGFloat startNameConstant = [BaseModel heightForTextString:model.sourceName width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat startAddConstant = [BaseModel heightForTextString:model.sourceAddr width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat endDcNameConstant = [BaseModel heightForTextString:model.dcName width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat endDcAddConstant = [BaseModel heightForTextString:model.dcAddress width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat height = startNameConstant + startAddConstant + endDcNameConstant + endDcAddConstant + 50.0 + 20;
    return height < 130.0? 130.0:height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableCell *cell = [HomeTableCell getCellWithTable:tableView];
    cell.homeModel = self.homePageModel.orderModelList[indexPath.row];
    return cell;
}

#pragma mark -- ButtonAction


/**
 拨打电话按钮点击事件

 @param sender 拨打电话点击的按钮
 */
- (IBAction)telePhoneAction:(UIButton *)sender {
    NSString *str=[NSString stringWithFormat:@"telprompt://%@", @"021-66188125"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


/**
 查看详情按钮点击事件

 @param sender 点击的按钮
 */
- (IBAction)detailButtonAction:(UIButton *)sender {    
    BiddingListController *biddingListVC = [BiddingListController new];
    [self.navigationController pushViewController:biddingListVC animated:YES];
}


/**
 接收运单按钮点击事件

 @param sender 接收运单按钮
 */
- (void)getLoadAction:(UIButton *)sender {
    if (self.homePageModel.orderModelList.count <= 0) {
        return;
    }
    HomePageModel *homeModel = self.homePageModel.orderModelList[0];
    if ([homeModel.status integerValue] == ORDER_STATUS_212) {
        OrderStatus212Controller *orderVC = [OrderStatus212Controller new];
        orderVC.homePageModel = homeModel;
        [self.navigationController pushViewController:orderVC animated:YES];
    } else {
        Mistake212Controller *mistake = [Mistake212Controller new];
        mistake.homePageModel = homeModel;
        [self.navigationController pushViewController:mistake animated:YES];
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
