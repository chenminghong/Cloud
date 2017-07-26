//
//  SafetyControlController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/26.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SafetyControlController.h"

#import "SaftyCheckCell.h"
#import "SafetyCheckModel.h"

#define HEIGHT_FOR_HEADER  30.0

@interface SafetyControlController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataModels;

@end

@implementation SafetyControlController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"要求和安全管理";
    
    [self.view addSubview:self.tableView];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SafetyControl" ofType:@"plist"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataModels = [NSMutableArray arrayWithArray:[SafetyCheckModel getModelWithData:dataDict[@"data"]]];
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
    return self.dataModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SafetyCheckModel *model = self.dataModels[section];
    return model.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_FOR_HEADER;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(5, 0, kScreenWidth, 50.0);
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"着装要求";
    SafetyCheckModel *model = self.dataModels[section];
    label.text = model.des_title;
    label.backgroundColor = MAIN_THEME_COLOR;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaftyCheckCell *cell = [SaftyCheckCell getCellWithTable:tableView];
    SafetyCheckModel *model = self.dataModels[indexPath.section];
    cell.model = model.listArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25.0;
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
