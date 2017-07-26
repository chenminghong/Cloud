//
//  BiddingCheckingModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BiddingCheckingModel.h"

#import "BiddingDetailModel.h"

@implementation BiddingCheckingModel

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClientBidd] GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BiddingCheckingModel *model = [BiddingCheckingModel new];
        model.amount = responseObject[@"amount"];
        model.biddingDetailModel = [BiddingDetailModel getModelWithDict:responseObject[@"driver"]];
        model.productArr = [NSMutableArray array];
        for (NSArray *array in responseObject[@"product"]) {
            NSArray *productArr = [BiddingDetailModel getModelsWithDicts:array];
            [model.productArr addObject:productArr];
        }
        model.scorderbidArr = [NSMutableArray arrayWithArray:[BiddingDetailModel getModelsWithDicts:responseObject[@"scorderbid"]]];
        if (endBlock) {
            endBlock(model, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

@end
