//
//  SafetyCheckModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafetyCheckModel : BaseModel

@property (nonatomic, strong) NSString *des_title;

@property (nonatomic, copy) NSString *des_list;

@property (nonatomic, strong) NSMutableArray *listArr;  //存储模型数组


/**
 获取数据模型数组

 @param dataArr 数据源
 @return 模型数据
 */
+ (NSArray *)getModelWithData:(NSArray *)dataArr;

@end
