//
//  OrderListModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClientBidd] GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!endBlock) {
            return;
        }
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *scorderbidArr = responseObject[@"scorderbid"];
        //如果resultFlag是NO，说明用户名和密码不正确，直接return
        if (scorderbidArr.count == 0) {
            [hud hide:NO];
            NSString *msg = @"暂无数据";
            endBlock(nil, [NSError errorWithDomain:PAIREACH_BASE_URL code:0 userInfo:@{ERROR_MSG:msg}]);
        } else {
            [hud hide:YES];
            //将登录成功返回的数据存到model中
            NSArray *models = [OrderListModel getModelsWithDicts:scorderbidArr];
            endBlock(models, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}


@end
