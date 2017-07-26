//
//  OrderStatus244Controller.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/19.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatus244Controller.h"

@interface OrderStatus244Controller ()
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation OrderStatus244Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.completeButton.backgroundColor = MAIN_THEME_COLOR;
    self.completeBtn.backgroundColor = MAIN_THEME_COLOR;
    self.completeBtn.hidden = YES;
    self.tipsLabel.hidden = YES;
}

/**
 调用接口返回处理结果
 
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

//收货完成拍照按钮点击事件（需要上传图片）
- (IBAction)completeButtonAction:(UIButton *)sender {
    
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
    
//    [MyImagePickerManager presentPhotoTakeControllerInTarget:self finishPickingBlock:nil postUrlStr:DELIVERY_COMPLETE_API paraDict:paraDict endBlock:^(id responseObject, NSError *error) {
//        if (!error) {
//            NSString *remarkStr = [NSString stringWithFormat:@"%@", responseObject[@"remark"]];
//            [ProgressHUD bwm_showTitle:remarkStr toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//        } else {
//            self.completeBtn.hidden = NO;
//            self.tipsLabel.hidden = NO;
//            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//        }
//    }];
    
    [self networkWithUrlStr:DELIVERY_COMPLETEBTN_API paraDict:paraDict];
}


//收货完成按钮点击事件（不需要上传图片）
- (IBAction)completeBtnAction:(UIButton *)sender {
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
    
    [self networkWithUrlStr:DELIVERY_COMPLETEBTN_API paraDict:paraDict];
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
