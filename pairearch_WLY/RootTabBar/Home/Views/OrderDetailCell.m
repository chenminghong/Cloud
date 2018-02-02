//
//  OrderDetailCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/5.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailCell.h"

#import "OrderDetailModel.h"

@implementation OrderDetailCell

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    OrderDetailCell *cell = [table dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置阴影
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 5;
}

- (void)setDetailModel:(OrderDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel.productCode) {
        self.commodityCodeLabel.text = detailModel.productCode;
    }
    
    if (detailModel.productCode) {
        self.commodityNameLabel.text = detailModel.productName;
    }
    
    if (detailModel.productCode) {
        self.commodityCountLabel.text = detailModel.planCount;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
