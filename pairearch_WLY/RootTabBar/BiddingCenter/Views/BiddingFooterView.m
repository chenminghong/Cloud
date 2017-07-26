//
//  BiddingFooterView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BiddingFooterView.h"

@implementation BiddingFooterView



+ (instancetype)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BiddingFooterView" owner:self options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.biddingTf.keyboardType = UIKeyboardTypeDecimalPad;
    self.supplierButton.backgroundColor = MAIN_THEME_COLOR;
    self.plateNumberBotton.backgroundColor = MAIN_THEME_COLOR;
}

//初始化定时器
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction:) userInfo:nil repeats:YES];
    }
    return _timer;
}

//设置截止时间
- (void)setDeadLineTime:(NSString *)deadLineTime {
    _deadLineTime = deadLineTime;
    NSDate *deadDate = [self stringToDate:deadLineTime withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.interval = deadDate.timeIntervalSinceNow - 2 * 60 * 60;
    NSDateComponents *cmps = [self getTimeintervalWithTimeinterval:self.interval];
    NSString *hour = cmps.hour<10? [NSString stringWithFormat:@"0%ld", (long)cmps.hour]:[NSString stringWithFormat:@"%ld", (long)cmps.hour];
    NSString *minute = cmps.minute<10? [NSString stringWithFormat:@"0%ld", (long)cmps.minute]:[NSString stringWithFormat:@"%ld", (long)cmps.minute];
    NSString *second = cmps.second<10? [NSString stringWithFormat:@"0%ld", (long)cmps.second]:[NSString stringWithFormat:@"%ld", (long)cmps.second];
    self.remainderTimeLabel.text = [NSString stringWithFormat:@"%ld天  %@小时 %@分 %@秒", (long)cmps.day, hour, minute, second];
    //开启定时器
    [self startTimer];
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    if (interval <= 0) {
        [self stopTimer];
        self.rapButton.userInteractionEnabled = NO;
        self.rapButton.backgroundColor = [UIColor darkGrayColor];
    } else {
        [self startTimer];
        self.rapButton.userInteractionEnabled = YES;
        self.rapButton.backgroundColor = MAIN_THEME_COLOR;
    }
}

/**
 重启定时器
 */
- (void)startTimer {
    if (!self.timer.isValid) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}


/**
 暂停定时器
 */
- (void)stopTimer {
    if (self.timer.isValid) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}


- (void)timeChangeAction:(NSTimer *)sender {
    self.interval -= 1;
    NSDateComponents *cmps = [self getTimeintervalWithTimeinterval:self.interval];

    NSString *hour = cmps.hour<10? [NSString stringWithFormat:@"0%ld", (long)cmps.hour]:[NSString stringWithFormat:@"%ld", (long)cmps.hour];
    NSString *minute = cmps.minute<10? [NSString stringWithFormat:@"0%ld", (long)cmps.minute]:[NSString stringWithFormat:@"%ld", (long)cmps.minute];
    NSString *second = cmps.second<10? [NSString stringWithFormat:@"0%ld", (long)cmps.second]:[NSString stringWithFormat:@"%ld", (long)cmps.second];
    self.remainderTimeLabel.text = [NSString stringWithFormat:@"%ld天  %@小时 %@分 %@秒", (long)cmps.day, hour, minute, second];
}


//根据时间间隔获取当前时间差
- (NSDateComponents *)getTimeintervalWithTimeinterval:(NSTimeInterval)timeinterval {
    NSDate *deadDate = [NSDate dateWithTimeIntervalSinceNow:timeinterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDate *currentDate = [self worldTimeToChinaTime:[NSDate date]];
    return [calendar components:unit fromDate:currentDate toDate:deadDate options:0];
}

//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [self worldTimeToChinaTime:date];
}

//将世界时间转化为中国区时间
- (NSDate *)worldTimeToChinaTime:(NSDate *)date{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
