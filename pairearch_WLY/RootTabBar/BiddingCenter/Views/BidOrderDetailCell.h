//
//  BidOrderDetailCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BiddingDetailModel;

@interface BidOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tonnageLabel;
@property (weak, nonatomic) IBOutlet UILabel *planCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) BiddingDetailModel *detailModel;    //数据模型

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
