//
//  OrdersModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/11.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface OrdersModel : BaseModel

@property (nonatomic, strong) NSMutableArray *modelsList;    //订单列表

@property (nonatomic, copy) NSString *sourceName;               //起始地名称

@property (nonatomic, copy) NSString *sourceAddr;               //起始地址

@property (nonatomic, copy) NSString *dcName;                   //收货地名称

@property (nonatomic, copy) NSString *dcAddress;                //收货地地址

@property (nonatomic, copy) NSString *status;                   //订单状态码

@property (nonatomic, copy) NSString *statusName;               //订单状态

@property (nonatomic, copy) NSString *code;                     //单号

@property (nonatomic, copy) NSString *wareDispatchTime;         //计划装运日期

@property (nonatomic, copy) NSString *planDate;                 //预约时间

@end
