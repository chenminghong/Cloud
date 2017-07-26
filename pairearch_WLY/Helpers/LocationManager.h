//
//  LocationManager.h
//  pairearch_WLY
//
//  Created by Jean on 2017/4/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;  //地理位置编码
    CLLocation *_location;  //存储地理位置
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) NSDictionary *addressInfo; //位置信息参数

@property (nonatomic, strong) NSTimer *timer;  //定时器

@property (nonatomic, copy) NSString *orderCode;  //当前正在走流程的订单号（为空的时候停止上传地理位置信息）


//初始化
+ (instancetype)shareManager;

//开始定位
- (void)startUploadLocation;

//结束定位
- (void)stopUploadLocation;

@end
