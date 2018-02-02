//
//  Header212View.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "Header212View.h"

@implementation Header212View

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomLineView.backgroundColor = MAIN_THEME_COLOR;
    self.selectedButton.selected = YES;
    [self.selectedButton setImage:[UIImage imageNamed:@"kongkuang"] forState:UIControlStateNormal];
    [self.selectedButton setImage:[UIImage imageNamed:@"xuanzekuang"] forState:UIControlStateSelected];
}

//获取表头视图
+ (instancetype)getHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"Header212View" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
