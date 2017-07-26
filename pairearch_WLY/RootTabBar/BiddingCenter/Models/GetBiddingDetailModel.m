//
//  GetBiddingDetailModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "GetBiddingDetailModel.h"

@implementation GetBiddingDetailModel

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClientBidd] GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

@end
