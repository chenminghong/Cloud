//
//  OrderListModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListModel : BaseModel

@property (nonatomic, copy) NSString *bidCode;             //竞价单号

@property (nonatomic, copy) NSString *sourceName;          //发货地名称

@property (nonatomic, copy) NSString *dcName;              //收货地名称

@property (nonatomic, copy) NSString *planDate;            //装运时间

@property (nonatomic, copy) NSString *specialExplain;      //装运要求


@end
