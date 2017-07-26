//
//  Mistake212Model.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/4.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface OrderDetailModel : BaseModel

@property (nonatomic, copy) NSString *productCode;              //商品编码

@property (nonatomic, copy) NSString *productName;              //商品名称

@property (nonatomic, copy) NSString *deliverCount;             //交付数量

@property (nonatomic, copy) NSString *planCount;                //商品数量

@property (nonatomic, copy) NSString *orderCode;                //单号

@property (nonatomic, strong) NSMutableArray *orders;           //可接收订单数组

@end
