//
//  PlanTimePickerView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TimePickerView.h"
#import "DatePickerView.h"

typedef void(^SelectBlock)(NSDictionary *selectParaDict);

@interface PlanTimePickerView : UIView
{
    NSArray *dataArr;
}

@property (nonatomic, strong) UIView *shadowView;  //背景遮盖

@property (nonatomic, strong) DatePickerView *datePicker;  //时间选择器

@property (nonatomic, strong) TimePickerView *timePickerView; //时间段选择

@property (nonatomic, assign) BOOL tapHide;   //单击隐藏

@property (nonatomic, strong) NSDate *selectDate;  //选择的日期

@property (nonatomic, copy) SelectBlock selectBlock;  //确定按钮点击回调



/**
 显示时间选择器

 @return 显示的时间选择器对象
 */
+ (PlanTimePickerView *)showTimeSelectViewInView:(UIView *)view withSelectBlock:(SelectBlock)selectBlock;

@end
