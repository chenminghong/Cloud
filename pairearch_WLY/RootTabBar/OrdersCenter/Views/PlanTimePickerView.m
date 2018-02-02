//
//  PlanTimePickerView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "PlanTimePickerView.h"

#define K_ANIMATION_TIMEINTERVAL 0.2
#define K_TIME_PICKERVIEW_HEIGHT  300.0

@implementation PlanTimePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = @[@[@"00", @"02"],
                    @[@"02", @"04"],
                    @[@"04", @"06"],
                    @[@"06", @"08"],
                    @[@"08", @"10"],
                    @[@"10", @"12"],
                    @[@"12", @"14"],
                    @[@"14", @"16"],
                    @[@"16", @"18"],
                    @[@"18", @"20"],
                    @[@"20", @"22"],
                    @[@"22", @"24"]];
        
        self.backgroundColor = [UIColor clearColor];
        self.tapHide = YES;
        [UIView animateWithDuration:K_ANIMATION_TIMEINTERVAL animations:^{
            self.shadowView.alpha = 0.5;
        }];
        
        self.datePicker = [DatePickerView showInView:self frame:CGRectMake(0, CGRectGetHeight(frame) - K_TIME_PICKERVIEW_HEIGHT, kScreenWidth, K_TIME_PICKERVIEW_HEIGHT) animationDuraton:K_ANIMATION_TIMEINTERVAL];
        [self.datePicker.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.datePicker.selectTImeBtn addTarget:self action:@selector(selectTimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.selectDate = self.datePicker.datePicker.date;
    }
    return self;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        self.shadowView = [UIView new];
        [self addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (TimePickerView *)timePickerView {
    if (!_timePickerView) {
        self.timePickerView = [TimePickerView getTimePickerView];
        self.timePickerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - K_TIME_PICKERVIEW_HEIGHT, kScreenWidth, K_TIME_PICKERVIEW_HEIGHT);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.layer.bounds;
        maskLayer.path = maskPath.CGPath;
        self.timePickerView.layer.mask = maskLayer;
        
        [self.timePickerView.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.timePickerView.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timePickerView;
}


/**
 显示视图
 */
+ (PlanTimePickerView *)showTimeSelectViewInView:(UIView *)view withSelectBlock:(SelectBlock)selectBlock {
//    CGRect frame = [UIScreen mainScreen].bounds;
//    PlanTimePickerView *pickerView = [[PlanTimePickerView alloc] initWithFrame:CGRectMake(0, 64.0, frame.size.width, frame.size.height - 64)];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:pickerView];
    
    CGRect frame = view.bounds;
    PlanTimePickerView *pickerView = [[PlanTimePickerView alloc] initWithFrame:frame];
    [view addSubview:pickerView];
    
    pickerView.selectBlock = selectBlock;
    return pickerView;
}


/**
 隐藏视图
 */
- (void)hideWithCompletionBlock:(void(^)(void))completionBlock {
    [self.datePicker hide];
    [self.timePickerView hide];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:K_ANIMATION_TIMEINTERVAL animations:^{
        weakSelf.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
        [weakSelf removeFromSuperview];
    }];
}

//设置是否单击隐藏时间选择器
- (void)setTapHide:(BOOL)tapHide {
    _tapHide = tapHide;
    if (tapHide) {
        self.shadowView.userInteractionEnabled = YES;
    } else {
        self.shadowView.userInteractionEnabled = NO;
    }
}


/**
 判断两个日期是不是同一天

 @param date1 日期1
 @param date2 日期2
 @return 判断结果
 */
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

#pragma mark -- 按钮点击事件

/**
 选择时间按钮点击事件
 */
- (void)selectTimeButtonAction:(UIButton *)sender {
    if ([[self class] isSameDay:[NSDate date]  date2:self.selectDate]) {
        NSMutableArray *dataListArr = [NSMutableArray array];
        NSDate *date = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
        NSInteger currentHour = [components hour];
        for (NSArray *array in dataArr) {
            NSInteger max = [array[1] integerValue];
            if (max > currentHour) {
                [dataListArr addObject:array];
            }
        }
        self.timePickerView.dataArr = dataListArr;
    } else {
        self.timePickerView.dataArr = [NSMutableArray arrayWithArray:dataArr];
    }
    
    [UIView transitionFromView:self.datePicker toView:self.timePickerView duration:K_ANIMATION_TIMEINTERVAL options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        self.timePickerView.animationTimeInterval = K_ANIMATION_TIMEINTERVAL;
    }];
}


/**
 取消按钮点击事件
 */
- (void)cancelButtonAction:(UIButton *)sender {
    [UIView transitionFromView:self.timePickerView toView:self.datePicker duration:K_ANIMATION_TIMEINTERVAL options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        if (finished) {
            self.timePickerView.animationTimeInterval = K_ANIMATION_TIMEINTERVAL;
        }
    }];
}


/**
 确定按钮点击事件
 */
- (void)sureButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self hideWithCompletionBlock:^{
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *planAchieveTime = [dateFormatter stringFromDate:weakSelf.datePicker.datePicker.date];
        NSLog(@"%@",planAchieveTime);
        NSString *planAchieveStartTime = @"";
        NSString *planAchieveEndTime = @"";
        if (weakSelf.timePickerView.selectedTimeArr.count >= 2) {
            planAchieveStartTime = [NSString stringWithFormat:@"%@:00", weakSelf.timePickerView.selectedTimeArr[0]];
            planAchieveEndTime = [NSString stringWithFormat:@"%@:00", weakSelf.timePickerView.selectedTimeArr[1]];
        }
        NSDictionary *paraDict = @{@"planAchieveTime":planAchieveTime.length>0? planAchieveTime:@"", @"planAchieveStartTime":planAchieveStartTime, @"planAchieveEndTime":planAchieveEndTime};
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(paraDict);
        }
    }];
    
}


/**
 背景遮罩手势
 */
- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self hideWithCompletionBlock:nil];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    self.selectDate = sender.date;
    NSLog(@"%@", sender.date);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
