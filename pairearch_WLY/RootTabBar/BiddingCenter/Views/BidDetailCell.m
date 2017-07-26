
//
//  BidDetailCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BidDetailCell.h"

#import "BiddingDetailModel.h"

@implementation BidDetailCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    BidDetailCell *cell = [table dequeueReusableCellWithIdentifier:@"BidDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BidDetailCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.startLabel.textColor = MAIN_THEME_COLOR;
    self.startLabel.layer.masksToBounds = YES;
    self.startLabel.layer.cornerRadius = CGRectGetWidth(self.startLabel.bounds) / 2.0;
    self.startLabel.layer.borderColor = MAIN_THEME_COLOR.CGColor;
    self.startLabel.layer.borderWidth = 1.0;
    
    self.stopLabel.textColor = MAIN_THEME_COLOR;
    self.stopLabel.layer.masksToBounds = YES;
    self.stopLabel.layer.cornerRadius = CGRectGetWidth(self.startLabel.bounds) / 2.0;
    self.stopLabel.layer.borderColor = MAIN_THEME_COLOR.CGColor;
    self.stopLabel.layer.borderWidth = 1.0;
        
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setDetailModel:(BiddingDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"单号：%@", detailModel.bidCode];
    self.reserveShiptimeLabel.text = [NSString stringWithFormat:@"计划装运日期：%@", detailModel.planDate];
    self.startNameLabel.text = detailModel.sourceName;
    self.stopNameLabel.text = detailModel.dcName;
    self.tonnageLabel.text = [NSString stringWithFormat:@"%.1f吨", [detailModel.tunnage floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
