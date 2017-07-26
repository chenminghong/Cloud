//
//  BiddingCheckingModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/24.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@class BiddingDetailModel;

@interface BiddingCheckingModel : BaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, strong) NSMutableArray *scorderbidArr;  //当前页竞价单列表

@property (nonatomic, strong) NSMutableArray *productArr;     //产品详情列表

@property (nonatomic, strong) BiddingDetailModel *biddingDetailModel;   //存储已经竞价承运商和车牌号信息

@end
