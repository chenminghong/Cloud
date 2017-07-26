//
//  TimePickerView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "TimePickerView.h"

@implementation TimePickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLabel.backgroundColor = MAIN_THEME_COLOR;
    [self.cancelButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    [self.sureButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
}

+ (instancetype)getTimePickerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil] firstObject];
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self.timePickerView reloadAllComponents];
    self.selectedTimeArr = self.dataArr[0];
}

- (void)layoutSubviews {
    ((UIView *)[self.timePickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor lightGrayColor];
    ((UIView *)[self.timePickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor lightGrayColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *countArr = self.dataArr[row];
    NSString *title = [NSString stringWithFormat:@"%@:00-%@:00", countArr[0], countArr[1]];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedTimeArr = self.dataArr[row];
}

- (void)hide {
    CGRect frame = self.frame;
    [UIView animateWithDuration:self.animationTimeInterval animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.0, frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
