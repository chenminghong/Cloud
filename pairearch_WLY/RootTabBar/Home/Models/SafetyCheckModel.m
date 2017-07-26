//
//  SafetyCheckModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SafetyCheckModel.h"

@implementation SafetyCheckModel

+ (NSArray *)getModelWithData:(NSArray *)dataArr {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *modelDict in dataArr) {
        SafetyCheckModel *model = [SafetyCheckModel new];
        model.des_title = modelDict[@"des_title"];
        [models addObject:model];
        model.listArr = [NSMutableArray array];
        NSArray *listArr = [NSArray arrayWithArray:modelDict[@"des_list"]];
        for (NSString *desStr in listArr) {
            SafetyCheckModel *tempModel = [SafetyCheckModel new];
            tempModel.des_title = desStr;
            [model.listArr addObject:tempModel];
        }
    }
    return models;
}


@end
