//
//  Mistake212Header.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "Mistake212Header.h"

@implementation Mistake212Header

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomLineView.backgroundColor = MAIN_THEME_COLOR;
}

//获取表头视图
+ (instancetype)getHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"Mistake212Header" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
