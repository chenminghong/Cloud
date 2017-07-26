//
//  ButtonFooterView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/26.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ButtonFooterView.h"

@implementation ButtonFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.footerButton.backgroundColor = MAIN_THEME_COLOR;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self.footerButton setTitle:buttonTitle forState:UIControlStateNormal];
}

/**
 获取当前的页脚视图
 
 @return 试图对象
 */
+ (instancetype)getFooterButtonView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ButtonFooterView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
