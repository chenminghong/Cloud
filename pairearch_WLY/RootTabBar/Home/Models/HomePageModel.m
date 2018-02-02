//
//  HomePageModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel

- (NSString *)code {
    return [NSString stringWithFormat:@"%@", _code];
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id model, NSError *error))endBlock {
    return [NetworkHelper GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:NO];
        NSInteger ordersCount = [responseObject[@"loadResult"] integerValue];
        HomePageModel *model = [HomePageModel getModelWithDict:responseObject];
        if (ordersCount > 0) {
            id orders = responseObject[@"orders"];
            if ([[orders class] isSubclassOfClass:[NSDictionary class]]) {
                model.orderModelList = [NSMutableArray array];
                [model.orderModelList addObject:[HomePageModel getModelWithDict:orders]];
            }
            if ([[orders class] isSubclassOfClass:[NSArray class]]) {
                model.orderModelList = [NSMutableArray arrayWithArray:[HomePageModel getModelsWithDicts:orders]];
            }
        }
        endBlock(model, nil);
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}

- (NSString *)wareDispatchTime {
    return _wareDispatchTime.length > 0? [NSString stringWithFormat:@"计划装运日期:%@", [_wareDispatchTime substringToIndex:10]]:@"计划装运日期:";
}


@end
