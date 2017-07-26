//
//  BidDetailCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BiddingDetailModel;

@interface BidDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;          //发货单号
@property (weak, nonatomic) IBOutlet UILabel *reserveShiptimeLabel;     //装运时间
@property (weak, nonatomic) IBOutlet UILabel *startLabel;               //起
@property (weak, nonatomic) IBOutlet UILabel *startNameLabel;         //发货地名称
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;                  //终
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;          //收货地名称
@property (weak, nonatomic) IBOutlet UILabel *tonnageLabel;             //重量
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) BiddingDetailModel *detailModel;   //model数据源


//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
