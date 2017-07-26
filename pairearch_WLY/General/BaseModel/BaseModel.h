//
//  BaseModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WarehouseType) {
    WarehouseTypeInside = 10,
    WarehouseTypeOutside,
};

@interface BaseModel : NSObject

//初始化Model
- (instancetype)initWithDict:(NSDictionary *)dict;

//初始化Model
+ (instancetype)getModelWithDict:(NSDictionary *)dict;

//初始化Model
+ (NSArray *)getModelsWithDicts:(NSArray *)dicts;

//请求
+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id model, NSError *error))endBlock;

//请求
+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id model, NSError *error))endBlock;

//网络接口请求添加签名参数sign  ?不起作用啊
+ (NSDictionary *)signReqParams:(NSDictionary *)paramDict;

//获取MAC地址
+ (NSString *)getMacAddress;

//密码MD5加密
+ (NSString *)md5HexDigest:(NSString*)password;

//获取设备型号
+ (NSString *)iphoneType;

//计算文字的高度(定宽)
+ (CGFloat)heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize;

//计算文字的宽度(定高)
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;

/**
 获取网络运营商的IMSI
 
 @return IMSI
 */
+ (NSString *)getIMSI;

/**
 获取SIM卡国家编码
 
 @return MCC
 */
+ (NSString *)getMobileCountryCode;

/**
 获取SIM卡信息运营商编码
 
 @return MNC
 */
+ (NSString *)getMobileNetworkCode;

/**
 获取CarrierName
 
 @return name
 */
+ (NSString *)getCarrierName;

@end
