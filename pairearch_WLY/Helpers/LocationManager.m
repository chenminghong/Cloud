//
//  LocationManager.m
//  pairearch_WLY
//
//  Created by Jean on 2017/4/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LocationManager.h"

#define UPLOAD_TIMEINTERVAL   300

@implementation LocationManager
/**
 初始化

 @return 返回当前定位上传助手对象
 */
+ (instancetype)shareManager {
    static LocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [LocationManager new];
        [sharedManager initLocationManager];
    });
    return sharedManager;
}


/**
 初始化定位助手对象
 */
- (void)initLocationManager {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        /** 后台定位 */
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        /** iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。 */
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    geocoder = [CLGeocoder new];
}


//初始化定时器
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:UPLOAD_TIMEINTERVAL target:self selector:@selector(uploadLocationToServer) userInfo:nil repeats:YES];
    }
    return _timer;
}


//获取位置信息
- (void)setLocation:(CLLocation *)location {
    _location = location;
    [self getAddressInfoByLocation:self.location];
}

- (void)setOrderCode:(NSString *)orderCode {
    _orderCode = orderCode;
    if (orderCode.length > 0) {
        [self startUploadLocation];
    } else {
        [self stopUploadLocation];
    }
}


/**
 上传位置信息到后台
 */
- (void)uploadLocationToServer {
    if (self.orderCode.length <= 0) {
        return;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:self.addressInfo];
    [paraDict setObject:self.orderCode forKey:@"orderCode"];
    [paraDict setObject:[LoginModel shareLoginModel].tel.length>0? [LoginModel shareLoginModel].tel:@"" forKey:@"driverTel"];
    [[NetworkHelper shareClient] POST:UPLOAD_LOCATION_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *responseStr = [NSString stringWithFormat:@"%@", [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]];
//        NSLog(@"成功：%@", responseStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.userInfo[ERROR_MSG]);
    }];
}


/**
 重启定时器
 */
- (void)startTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}


/**
 暂停定时器
 */
- (void)stopTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}


/**
 开始定位上传
 */
- (void)startUploadLocation {
    [self startTimer];
    [self.locationManager startUpdatingLocation];
}


/**
 结束定位上传
 */
- (void)stopUploadLocation {
    [self stopTimer];
    [self.locationManager stopUpdatingLocation];
}


/**
 反地理编码

 @param location 地理位置对象
 */
-(void)getAddressInfoByLocation:(CLLocation *)location {
    __weak typeof(self) weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark=[placemarks firstObject];
            NSDictionary *locationDict = placemark.addressDictionary;
    
            NSString *speed = [NSString stringWithFormat:@"%f", location.speed];
            NSString *direction = [NSString stringWithFormat:@"%f", location.course];
            NSArray *addressArr = [NSArray arrayWithArray:locationDict[@"FormattedAddressLines"]];
            NSString *address = addressArr.count? addressArr[0]:@"";
            NSString *province = locationDict[@"State"];
            NSString *city = locationDict[@"City"];
            NSString *area = locationDict[@"SubLocality"];
            NSString *remark = @"iOS";
            NSString *active = @"Y";
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *locationTime = [dateFormatter stringFromDate:location.timestamp];
            weakSelf.addressInfo = @{@"orderCode":@"",
                                 @"driverTel":@"",
                                 @"longitude":[NSString stringWithFormat:@"%f", location.coordinate.longitude],
                                 @"latiude":[NSString stringWithFormat:@"%f", location.coordinate.latitude],
                                 @"speed":speed,
                                 @"direction":direction,
                                 @"address":address,
                                 @"province":province,
                                 @"city":city,
                                 @"area":area,
                                 @"remark":remark,
                                 @"active":active,
                                 @"locationTime":locationTime};
//            NSLog(@"详细信息:%@", self.addressInfo);
        }
    }];
}

- (CLLocation *)location {
    CLLocationCoordinate2D coordinate = [DYLocationConverter bd09FromWgs84:_location.coordinate];
    return [[CLLocation alloc] initWithCoordinate:coordinate altitude:_location.altitude horizontalAccuracy:_location.horizontalAccuracy verticalAccuracy:_location.verticalAccuracy course:_location.course speed:_location.speed timestamp:_location.timestamp];
}


#pragma mark -- CLLocationManagerDelegate

/**
 位置更新提示

 @param manager 定位助手类
 @param locations 存储定位的位置信息
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    self.location = newLocation;
}


/**
 定位错误回调

 @param manager 定位助手
 @param error 错误信息
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

//将UTC/GTM时间转换为当前系统标准时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}



@end
