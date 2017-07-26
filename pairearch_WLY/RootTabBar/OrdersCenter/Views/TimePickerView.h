//
//  TimePickerView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, assign) NSTimeInterval animationTimeInterval;  //动画持续时间间隔

@property (nonatomic, strong) NSMutableArray *dataArr;  //数据源

@property (nonatomic, strong) NSArray *selectedTimeArr;  //选中的时间


/**
 初始化视图
 */
+ (instancetype)getTimePickerView;

/**
 隐藏时间选择器视图
 */
- (void)hide;

@end
