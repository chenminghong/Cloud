//
//  DatePickerView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *selectTImeBtn;
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;  //动画持续时间间隔


/**
 初始化视图
 */
+ (instancetype)getDatepickerView;

/**
 显示时间选择器视图。
 */
+ (DatePickerView *)showInView:(UIView *)view frame:(CGRect)frame animationDuraton:(NSTimeInterval)duration;


/**
 隐藏日期选择器视图
 */
- (void)hide;

@end
