//
//  FooterSelectView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/25.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "FooterSelectView.h"

@implementation FooterSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectButton.backgroundColor = MAIN_THEME_COLOR;
    
}


/**
 获取页脚视图

 @return 页脚视图
 */
+ (instancetype)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"FooterSelectView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
