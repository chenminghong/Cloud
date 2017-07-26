//
//  MyImagePickerManager.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/31.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "MyImagePickerManager.h"

#import <Photos/Photos.h>
#import <TZImageManager.h>

@implementation MyImagePickerManager

- (UIImagePickerController *)imagePickerVC {
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVC;
}

/**
 初始化
 
 @return 返回当前定位上传助手对象
 */
+ (instancetype)shareManager {
    static MyImagePickerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [MyImagePickerManager new];
    });
    return sharedManager;
}



#pragma mark -- 图片压缩
/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)zipImageWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = 32*1024;
    CGFloat compression = 0.9f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
    }
    return compressedData;
}

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth {
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - UIImagePickerController

/**
 打开摄像头拍摄照片
 
 @param target 需要打开照相机的控制器
 @param finishPickerBlock 完成拍照之后回传照片信息
 @param urlStr 需要上传的Url地址
 @param paraDict 需要上传的参数
 @param endBlock 上传之后服务器回调
 @return 返回当前助手对象
 */
+ (MyImagePickerManager *)presentPhotoTakeControllerInTarget:(UIViewController *)target finishPickingBlock:(FinishPickerBlock)finishPickerBlock postUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict endBlock:(void (^)(id responseObject, NSError *error))endBlock {
    MyImagePickerManager *manager = [self shareManager];
    manager.target = target;
    manager.imagePickerVC.navigationBar.barTintColor = target.navigationController.navigationBar.barTintColor;
    manager.imagePickerVC.navigationBar.tintColor = target.navigationController.navigationBar.tintColor;
    manager.finishPickerBlock = finishPickerBlock;
    manager.finishPostBlock = endBlock;
    manager.urlStr = urlStr;
    manager.paraDict = paraDict;
    [manager takePhotoWithTarget:target];
    return manager;
}

//跳转拍照界面
- (void)takePhotoWithTarget:(UIViewController *)target {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        // 拍照之前还需要检查相册权限
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:action];
        [target presentViewController:alertController animated:YES completion:nil];
        
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:action];
        [target presentViewController:alertController animated:YES completion:nil];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhotoWithTarget:target];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVC.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [target presentViewController:self.imagePickerVC animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机，请在真机中使用");
        }
    }
}

/**
 拍照结束回调
 
 @param picker imagepickerVC对象
 @param info 拍照获取的资源
 */
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    if (self.finishPickerBlock) {
        self.finishPickerBlock(info);
    }
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        TZImageManager *manager = [TZImageManager manager];
        [manager savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                NSLog(@"图片保存成功");
                //获取保存后的图片并上传
                /*
                 [manager getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                 [manager getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                 TZAssetModel *assetModel = [models firstObject];
                 if (manager.sortAscendingByModificationDate) {
                 assetModel = [models lastObject];
                 }
                 
                 //获取图片时间
                 NSDateFormatter *dateFormatter = [NSDateFormatter new];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 PHAsset *tempAsset = assetModel.asset;
                 NSString *photoTime = [dateFormatter stringFromDate:tempAsset.creationDate];
                 
                 //添加请求参数
                 NSMutableDictionary *tempParaDict = [NSMutableDictionary dictionaryWithDictionary:self.paraDict];
                 [tempParaDict setObject:photoTime.length? photoTime:@"" forKey:@"photoTime"];
                 NSString *addressStr = [NSString stringWithFormat:@"%@", [LocationManager shareManager].addressInfo[@"address"]];
                 [tempParaDict setObject:addressStr forKey:@"address"];
                 
                 NSData *postData = UIImageJPEGRepresentation(image, 0.05);
                 NSLog(@"postDataLength:%lu", postData.length / 1000);
                 [NetworkHelper POST:self.urlStr parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 [formData appendPartWithFileData:postData name:@"photo" fileName:@"abnormal_upload.jpg" mimeType:@"image/jpeg"];
                 } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                 if (self.finishPostBlock) {
                 self.finishPostBlock(responseObject, nil);
                 }
                 } failure:^(NSError *error) {
                 if (self.finishPostBlock) {
                 self.finishPostBlock(nil, error);
                 }
                 }];
                 }];
                 }];
                 
                 */
            }
        }];
        
        __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:self.target.view title:nil animated:YES];
        
        NSDictionary *dataDict = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *infoDict = [dataDict objectForKey:@"{TIFF}"];
        NSString *photoTime = [infoDict objectForKey:@"DateTime"];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:photoTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        photoTime = [dateFormatter stringFromDate:date];
        
        __block NSMutableDictionary *tempParaDict = [NSMutableDictionary dictionaryWithDictionary:self.paraDict];
        [tempParaDict setObject:photoTime forKey:@"photoTime"];
        NSString *addressStr = [NSString stringWithFormat:@"%@", [LocationManager shareManager].addressInfo[@"address"]];
        [tempParaDict setObject:addressStr forKey:@"address"];
        
        
        UIImage *compressImage = [UIImage compressImage:image compressRatio:0.05];
        NSData *imageData = UIImageJPEGRepresentation(compressImage, 0.3);
        NSLog(@"imageDataLength:%lu", imageData.length/1000);
        [[NetworkHelper shareClient] POST:self.urlStr parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"abnormal_upload.jpg" mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hide:NO];
            if (self.finishPostBlock) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                self.finishPostBlock(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hide:NO];
            if (self.finishPostBlock) {
                self.finishPostBlock(nil, error);
            }
        }];
        
        
        /*
        [YQImageCompressTool CompressToDataAtBackgroundWithImage:image ShowSize:CGSizeMake(600, 600*image.size.height/image.size.width) FileSize:100 block:^(NSData *resultData) {
            NSLog(@"resultDataLength:%lu", resultData.length / 1000);
            [[NetworkHelper shareClient] POST:self.urlStr parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:resultData name:@"photo" fileName:@"abnormal_upload.jpg" mimeType:@"image/jpeg"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [hud hide:NO];
                if (self.finishPostBlock) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    self.finishPostBlock(responseObject, nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [hud hide:NO];
                if (self.finishPostBlock) {
                    self.finishPostBlock(nil, error);
                }
            }];
            
//            [NetworkHelper POST:self.urlStr parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                [formData appendPartWithFileData:data name:@"photo" fileName:@"abnormal_upload.jpg" mimeType:@"image/jpeg"];
//            } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//                if (self.finishPostBlock) {
//                    self.finishPostBlock(responseObject, nil);
//                }
//            } failure:^(NSError *error) {
//                if (self.finishPostBlock) {
//                    self.finishPostBlock(nil, error);
//                }
//            }];
        }];
         */
        
        
        
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -- TZImagePickerController


/**
 进入图片选择器并选择照片
 
 @param target 需要打开照图片选择器
 @param finishPickingBlock 照片选择完成之后回传照片信息
 @param urlStr 需要上传的Url地址
 @param paraDict 需要上传的参数
 @param endBlock 上传之后服务器回调
 */
+ (void)presentImagePickerControllerInTarget:(UIViewController *)target finishPickingBlock:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL))finishPickingBlock postUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict endBlock:(void (^)(id responseObject, NSError *error))endBlock {
    //弹出选择相册
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    imagePickerVc.navigationBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    imagePickerVc.navigationBar.tintColor = UIColorFromRGB(0x666666);
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:16.0];
    imagePickerVc.barItemTextColor = UIColorFromRGB(0x666666);
    imagePickerVc.alwaysEnableDoneBtn = NO;
    imagePickerVc.allowPreview = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [target presentViewController:imagePickerVc animated:YES completion:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (finishPickingBlock) {
            finishPickingBlock(photos, assets, isSelectOriginalPhoto);
        }
        
        NSData *data = nil;
        NSString *photoTime = @"";
        if (photos.count > 0) {
            UIImage *image = photos[0];
            data = UIImageJPEGRepresentation(image, 0.4);
            NSLog(@"imageLength:%lu", data.length);
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            PHAsset *tempAsset = assets[0];
            photoTime = [dateFormatter stringFromDate:tempAsset.creationDate];
        }
        NSMutableDictionary *tempParaDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
        [tempParaDict setObject:photoTime forKey:@"photoTime"];
        NSString *addressStr = [NSString stringWithFormat:@"%@", [LocationManager shareManager].addressInfo[@"address"]];
        [tempParaDict setObject:addressStr forKey:@"address"];
        [NetworkHelper POST:urlStr parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"photo" fileName:@"abnormal_upload.jpg" mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (endBlock) {
                endBlock(responseObject, nil);
            }
        } failure:^(NSError *error) {
            if (endBlock) {
                endBlock(nil, error);
            }
        }];
    }];
}


@end
