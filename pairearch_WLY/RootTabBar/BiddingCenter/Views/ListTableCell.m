//
//  ListTableCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ListTableCell.h"

#import "OrderListModel.h"

@implementation ListTableCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table{
    ListTableCell *cell = [table dequeueReusableCellWithIdentifier:@"ListTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableCell" owner:self options:nil] firstObject];
    }
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
    
    self.assortLabel.textColor = [UIColor whiteColor];
    self.assortLabel.backgroundColor = MAIN_THEME_COLOR;
    self.assortLabel.layer.masksToBounds = YES;
    self.assortLabel.layer.cornerRadius = 25.0;
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"单号：%@", orderModel.bidCode];
    self.reserveShiptimeLabel.text = [NSString stringWithFormat:@"装运日期：%@", orderModel.planDate];
    self.startNameLabel.text = orderModel.sourceName;
    self.stopNameLabel.text = orderModel.dcName;
    self.loadDemandLabel.text = orderModel.specialExplain;
}


//计算文字宽度
- (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
