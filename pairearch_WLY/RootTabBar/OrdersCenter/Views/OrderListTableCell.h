//
//  OrderListTableCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/11.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageModel;

@interface OrderListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *planLoadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAssortLabel;
@property (weak, nonatomic) IBOutlet UILabel *startNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAssortLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) HomePageModel *orderModel;  //主页数据

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
