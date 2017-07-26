//
//  OrderStatus228Controller.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderStatus228Controller : BaseViewController

@property (nonatomic, copy) NSString *code;            //订单编号

@property (nonatomic, assign) NSInteger status;        //订单状态码

@property (nonatomic, copy) NSString *warehouseType;   //内仓还是外仓

@end
