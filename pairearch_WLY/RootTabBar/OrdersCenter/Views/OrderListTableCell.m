//
//  OrderListTableCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/11.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderListTableCell.h"

#import "HomePageModel.h"

@implementation OrderListTableCell

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.startAssortLabel.layer.masksToBounds = YES;
    self.startAssortLabel.layer.cornerRadius = CGRectGetWidth(self.startAssortLabel.bounds)/2.0;
    self.startAssortLabel.layer.borderWidth = 1.0;
    self.startAssortLabel.layer.borderColor = MAIN_THEME_COLOR.CGColor;
    
    self.endAssortLabel.layer.masksToBounds = YES;
    self.endAssortLabel.layer.cornerRadius = CGRectGetWidth(self.endAssortLabel.bounds)/2.0;
    self.endAssortLabel.layer.borderWidth = 1.0;
    self.endAssortLabel.layer.borderColor = MAIN_THEME_COLOR.CGColor;
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 5;
}

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    OrderListTableCell *cell = [table dequeueReusableCellWithIdentifier:@"OrderListTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableCell" owner:self options:nil] firstObject];
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

- (void)setOrderModel:(HomePageModel *)orderModel {
    _orderModel = orderModel;
    self.loadNumberLabel.text = [NSString stringWithFormat:@"单号:%@", orderModel.code];
    self.planLoadTimeLabel.text = orderModel.wareDispatchTime;
    self.startNameLabel.text = orderModel.sourceName;
    self.startAddressLabel.text = orderModel.sourceAddr;
    self.endNameLabel.text = orderModel.dcName;
    self.endAddressLabel.text = orderModel.dcAddress;
    self.statusLabel.text = orderModel.statusName;
    if (orderModel.status.integerValue == ORDER_STATUS_212) {
        self.statusLabel.backgroundColor = [UIColor greenColor];
    } else {
        self.statusLabel.backgroundColor = MAIN_THEME_COLOR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
