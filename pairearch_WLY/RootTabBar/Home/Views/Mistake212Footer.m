//
//  Mistake212Footer.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "Mistake212Footer.h"

@implementation Mistake212Footer

+(instancetype)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"Mistake212Footer" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
