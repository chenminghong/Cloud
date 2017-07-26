//
//  ListTableCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;

@interface ListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;          //发货单号
@property (weak, nonatomic) IBOutlet UILabel *reserveShiptimeLabel;     //装运时间
@property (weak, nonatomic) IBOutlet UILabel *assortLabel;              //抢
@property (weak, nonatomic) IBOutlet UILabel *startLabel;               //起
@property (weak, nonatomic) IBOutlet UILabel *startNameLabel;         //发货地名称
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;                  //终
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;          //收货地名称
@property (weak, nonatomic) IBOutlet UILabel *loadDemandLabel;             //装运要求
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) NSIndexPath *indexPath;                   //当前的cell位置;

@property (nonatomic, strong) OrderListModel *orderModel;               //数据模型

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
