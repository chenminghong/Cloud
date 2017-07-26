//
//  BiddingListController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/7.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BiddingListController.h"

#import "OrderListModel.h"
#import "ListTableCell.h"
#import "BiddingDetailController.h"

@interface BiddingListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listModelArr; //数据源

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BiddingListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //请求数据
    [self loadDataFromNet];
    
    self.title = @"竞价中";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- LazyLoding

- (UITableView *)listTableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.mas_equalTo(self.view);
        }];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.tableFooterView = [UIView new];
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.listTableView andAction:@selector(loadDataFromNet)];
    }
    return _tableView;
}


//  请求网络数据
- (void)loadDataFromNet {
    [self.listModelArr removeAllObjects];
    
    [OrderListModel getDataWithUrl:IN_BIDDING_API parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel.length>0? [LoginModel shareLoginModel].tel:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.listModelArr = [NSMutableArray arrayWithArray:model];
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.listTableView.superview hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        
        [self.listTableView reloadData];
        [MJRefreshUtil endRefresh:self.listTableView];
    }];
}

#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *orderModel = self.listModelArr[indexPath.row];
    CGFloat specialExplainConstant = [BaseModel heightForTextString:orderModel.specialExplain width:(kScreenWidth - 100.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 140 + specialExplainConstant;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableCell *cell = [ListTableCell getCellWithTable:tableView];
    cell.indexPath = indexPath;
    cell.orderModel = self.listModelArr[indexPath.row];
    cell.assortLabel.hidden = NO;
    cell.assortLabel.text = @"抢";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *model = self.listModelArr[indexPath.row];
    BiddingDetailController *bidDetailVC = [BiddingDetailController new];
    bidDetailVC.bidCode = model.bidCode;
    [self.navigationController pushViewController:bidDetailVC animated:YES];
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
