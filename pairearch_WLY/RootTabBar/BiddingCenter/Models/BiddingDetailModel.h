//
//  BidddingDetailModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface BiddingDetailModel : BaseModel


@property (nonatomic, strong) NSMutableArray *scorderbidArr;  //当前页竞价单列表

@property (nonatomic, strong) NSMutableArray *productArr;     //产品详情列表

@property (nonatomic, strong) NSMutableArray *supplieArr;     //承运商列表

@property (nonatomic, strong) NSMutableArray *driverArr;      //车牌号列表


//scorderbid

@property (nonatomic, copy) NSString *bidCode;             //竞价单号

@property (nonatomic, copy) NSString *sourceName;          //发货地名称

@property (nonatomic, copy) NSString *dcName;              //收货地名称

@property (nonatomic, copy) NSString *planDate;            //装运时间

@property (nonatomic, copy) NSString *specialExplain;      //装运要求

@property (nonatomic, copy) NSString *tunnage;             //吨重

@property (nonatomic, copy) NSString *deadlineTime;        //竞价截止时间


//pruduct

@property (nonatomic, copy) NSString *productName;         //产品名称

@property (nonatomic, copy) NSString *planProductNums;     //计划数量


//supplier

@property (nonatomic, copy) NSString *supplierCode;         //承运商编码

@property (nonatomic, copy) NSString *supplierName;         //承运商名称


//driver

@property (nonatomic, copy) NSString *truckNumber;          //车牌号




@end
