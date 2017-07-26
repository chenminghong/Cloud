//
//  OrderDetailCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/5.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;

@interface OrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commodityCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commodityCountLabel;

@property (nonatomic, strong) OrderDetailModel *detailModel;


/**
 加载cell

 @param table 显示的table
 @return 当前行的cell
 */
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
