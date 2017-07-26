//
//  OrdersModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/11.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersModel.h"

@implementation OrdersModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modelsList = [NSMutableArray array];
    }
    return self;
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:ORDER_LIST_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:NO];
        NSInteger loadResult = [responseObject[@"loadResult"] integerValue];
        OrdersModel *model = [OrdersModel new];
        if (loadResult) {
            NSArray *orders = responseObject[@"orders"];
            model.modelsList = [NSMutableArray arrayWithArray:[OrdersModel getModelsWithDicts:orders]];
        }
        endBlock(model, nil);
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}

@end
