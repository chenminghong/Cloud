//
//  OrderStatus.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/3.
//  Copyright © 2017年 Leo. All rights reserved.
//

#ifndef OrderStatus_h
#define OrderStatus_h

#define ORDER_STATUS_200    200    //仓库未调度,派单导入后状态、竞价成功后导入状态
#define ORDER_STATUS_201    201    //装瓶厂未处理
#define ORDER_STATUS_202    202    //装瓶厂未调度装瓶厂自提 仓库调度后的运单状态
#define ORDER_STATUS_204    204    //承运商未接收, 派单调度后状态（有预约流程）
#define ORDER_STATUS_205    205    //承运商未预约,派单调度后状态（无预约流程）
#define ORDER_STATUS_208    208    //司机未预约,竞价调度后状态
#define ORDER_STATUS_212    212    //司机未接收
#define ORDER_STATUS_216    216    //司机已拒绝
#define ORDER_STATUS_220    220    //装货在途
#define ORDER_STATUS_224    224    //装货厂外排队
#define ORDER_STATUS_225    225    //装货候补排队
#define ORDER_STATUS_226    226    //准备装货
#define ORDER_STATUS_227    227    //货候补排队

#define ORDER_STATUS_228    228    //装货中
#define ORDER_STATUS_230    230    //离厂(装)中
#define ORDER_STATUS_232    232    //送货在途
#define ORDER_STATUS_236    236    //收货厂外排队

#define ORDER_STATUS_238    238    //准备收货
#define ORDER_STATUS_240    240    //收货中
#define ORDER_STATUS_242    242    //离厂(收)中
#define ORDER_STATUS_244    244    //收货中
#define ORDER_STATUS_246    246    //直发卸货中
#define ORDER_STATUS_247    247    //直发收货完成
#define ORDER_STATUS_248    248    //已签收

#define STORAGE_TYPE_INSIDE     10   //内仓
#define STORAGE_TYPE_OUTSIDE    11   //外仓



#endif /* OrderStatus_h */
