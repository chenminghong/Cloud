//
//  MyImagePickerManager.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/31.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^FinishPickerBlock)(NSDictionary *info);
typedef void(^FinishPostBlock)(id responseObject, NSError *error);

@interface MyImagePickerManager : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@property (nonatomic, strong) UIViewController *target;

@property (nonatomic, copy) FinishPickerBlock finishPickerBlock;    //结束选择图片回调

@property (nonatomic, copy) FinishPostBlock finishPostBlock;        //上传结束回调

@property (nonatomic, strong) NSDictionary *paraDict;               //上传参数

@property (nonatomic, copy) NSString *urlStr;                        //上传的url




/**
 打开摄像头拍摄照片

 @param target 需要打开照相机的控制器
 @param finishPickerBlock 完成拍照之后回传照片信息
 @param urlStr 需要上传的Url地址
 @param paraDict 需要上传的参数
 @param endBlock 上传之后服务器回调
 @return 返回当前助手对象
 */
+ (MyImagePickerManager *)presentPhotoTakeControllerInTarget:(UIViewController *)target finishPickingBlock:(FinishPickerBlock)finishPickerBlock postUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict endBlock:(void (^)(id responseObject, NSError *error))endBlock;


/**
 进入图片选择器并选择照片

 @param target 需要打开照图片选择器
 @param finishPickingBlock 照片选择完成之后回传照片信息
 @param urlStr 需要上传的Url地址
 @param paraDict 需要上传的参数
 @param endBlock 上传之后服务器回调
 */
+ (void)presentImagePickerControllerInTarget:(UIViewController *)target finishPickingBlock:(void(^)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto))finishPickingBlock postUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict endBlock:(void(^)(id responseObject, NSError *error))endBlock;

@end
