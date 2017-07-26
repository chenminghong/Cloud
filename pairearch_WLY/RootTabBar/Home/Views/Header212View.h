//
//  Header212View.h
//  pairearch_WLY
//
//  Created by Jean on 2017/4/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Header212View : UIView

@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIButton *scanButton;

/**
 获取表头视图

 @return 返回表头视图
 */
+ (instancetype)getHeaderView;

@end
