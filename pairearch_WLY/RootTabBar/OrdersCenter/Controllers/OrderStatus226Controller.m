//
//  OrderStatus226Controller.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatus226Controller.h"

#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>


@interface OrderStatus226Controller ()

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startScanButton;

@end

@implementation OrderStatus226Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.startScanButton.backgroundColor = MAIN_THEME_COLOR;
}

- (void)viewDidLayoutSubviews {
    self.codeLabel.text = [NSString stringWithFormat:@"运单号：%@", self.code];
}



/**
 调用接口返回扫描一维码结果
 
 @param urlStr 接口名称
 @param paraDict 需要传递的参数
 */
- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = responseObject[@"remark"];
        [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    } failure:^(NSError *error) {
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}

- (IBAction)scanButtonAction:(UIButton *)sender {
    //选择图片并且上传
    NSString *userName = [LoginModel shareLoginModel].tel;
    NSString *orderCode = self.code;
    CLLocation *location =  [LocationManager shareManager].location;
    NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationTime = [dateFormatter stringFromDate:location.timestamp];
    NSDictionary *paraDict = @{@"userName":userName,
                               @"orderCode":orderCode,
                               @"lat":lat,
                               @"lng":lng,
                               @"locationTime":locationTime};
    
    [MyImagePickerManager presentPhotoTakeControllerInTarget:self finishPickingBlock:nil postUrlStr:LOAD_START_API paraDict:paraDict endBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"%@", responseObject);
            NSString *remarkStr = [NSString stringWithFormat:@"%@", responseObject[@"remark"]];
            [ProgressHUD bwm_showTitle:remarkStr toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
