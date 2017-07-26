//
//  BidOrderDetailCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BidOrderDetailCell.h"

#import "BiddingDetailModel.h"

@implementation BidOrderDetailCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    BidOrderDetailCell *cell = [table dequeueReusableCellWithIdentifier:@"BidOrderDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BidOrderDetailCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bottomView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setDetailModel:(BiddingDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.nameLabel.text = detailModel.productName;
    self.tonnageLabel.text = [NSString stringWithFormat:@"%@", detailModel.tunnage];
    self.planCountLabel.text = detailModel.planProductNums;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
