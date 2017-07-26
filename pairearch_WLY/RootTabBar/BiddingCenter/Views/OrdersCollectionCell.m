//
//  OrdersCollectionCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCollectionCell.h"

#import "ListTableCell.h"
#import "OrderListModel.h"

@implementation OrdersCollectionCell

//加载cell
+ (instancetype)getCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath pushBlock:(PushActionBlock)pushBlock {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    [collectionView registerClass:[OrdersCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    OrdersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.pushBlock = pushBlock;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.listTableView];
}

#pragma mark -- LazyLoding

- (UITableView *)listTableView {
    if (!_listTableView) {
        self.listTableView = [UITableView new];
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.listTableView];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.mas_equalTo(self);
        }];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.tableFooterView = [UIView new];
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.listTableView andAction:@selector(loadDataFromNet)];
    }
    return _listTableView;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    switch (indexPath.item) {
        case 0:
        {
            self.url = IN_BIDDING_API;//竞价中
        }
            break;
            
        case 1:
        {
            self.url = IN_CHECK_API; //审核中
        }
            break;
            
        case 2:
        {
            self.url = ALREADY_BIDDING_API;  //已中标
        }
            break;
            
        case 3:
        {
            self.url = HISTORY_BIDDING_API; //历史竞价
        }
            break;
            
        default:
        {
            self.url = IN_BIDDING_API; //竞价中
        }
            break;
    }
}

- (void)setListModelArr:(NSMutableArray *)listModelArr {
    _listModelArr = listModelArr;
}

//  请求网络数据
- (void)loadDataFromNet {
    [self.listModelArr removeAllObjects];
    
    [OrderListModel getDataWithUrl:self.url.length>0? self.url:@"" parameters:@{@"phoneNumber":[LoginModel shareLoginModel].tel.length>0? [LoginModel shareLoginModel].tel:@"", @"item":@(self.indexPath.item)} endBlock:^(id model, NSError *error) {
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
    if (self.indexPath.item == 0) {
        cell.assortLabel.text = @"抢";
    } else if (self.indexPath.item == 1) {
        cell.assortLabel.text = @"正在\n审核";
    } else if (self.indexPath.item == 2) {
        cell.assortLabel.text = @"中标";
    } else {
        cell.assortLabel.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushBlock) {
        OrderListModel *model = self.listModelArr[indexPath.row];
        NSMutableArray *modelArr = [NSMutableArray arrayWithObject:model];
        self.pushBlock(modelArr, self.indexPath);
    }
}

@end
