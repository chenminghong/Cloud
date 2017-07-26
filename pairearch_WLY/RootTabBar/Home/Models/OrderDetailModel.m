//
//  Mistake212Model.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/4.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:LOAD_DETAIL_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:NO];
        NSInteger loadResult = [responseObject[@"loadResult"] integerValue];
        if (loadResult > 0) {
            NSArray *orderArr = responseObject[@"orders"];
            OrderDetailModel *model = [OrderDetailModel new];
            model.orders = [NSMutableArray array];
            for (NSDictionary *orderDict in orderArr) {
                OrderDetailModel *orderModel = [OrderDetailModel getModelWithDict:orderDict];
                [model.orders addObject:orderModel];
            }
            endBlock(model, nil);
        } else {
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:loadResult userInfo:@{ERROR_MSG:@"暂无数据"}];
            endBlock(nil, error);
        }
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}

@end
