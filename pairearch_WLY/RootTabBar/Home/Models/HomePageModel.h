//
//  HomePageModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

/*
 {
 actNodeId = 0;
 billDate = "2016-12-19 00:00:00";
 capacityAppLyDate = 0;
 code = 1234002;
 corpCode = 000101;
 createDate = "2017-04-06 17:08:27";
 createUser = 000000;
 customerContact = "\U4f55\U5e73/\U4faf\U4f1f\U4f1f0551-3818747/\U5415\U6052\U79cb/\U5510\U9759/\U55bb\U73ca0571-85273366/\U80e1\U5efa\U53820551-3815035/\U9a6c\U5609\U4f1f0551-63818747";
 dcAddress = "\U65b0\U4e61\U5e02107\U56fd\U9053\U4e0e\U5317\U73af\U8def\U4ea4\U53c9\U53e3\U5411\U5317200\U7c73\U8def\U4e1c\Uff08\U8d27\U8fd0\U4e1c\U7ad9\U9662\U5185\Uff09";
 dcCode = 0020020401;
 dcName = "\U90d1\U5dde\U592a\U53e4\U53ef\U53e3\U53ef\U4e50\U996e\U6599\U6709\U9650\U516c\U53f8\U65b0\U4e61\U5206\U516c\U53f8";
 dealCode = 17042110524830044429;
 deliveryCode = 000101;
 deliveryName = SCMC;
 deliveryTel = "0769-22401678";
 deploymentId = 1420001;
 driverIdcard = 11111111111111111111;
 driverName = "\U53a6\U95e81";
 driverTel = 18100000001;
 fristInComingAppLyDate = 0;
 id = 17940;
 importFile = auto;
 imptType = "\U65b0\U5efa";
 isApply = 0;
 isPosition = 1;
 lineCode = CN7829;
 lineDist = 0;
 lineName = "\U4f5b\U5c71\U516c\U53f8\U5230\U90d1\U5dde(\U65b0\U4e61\U8425\U4e1a\U6240)";
 logicState = 1;
 maxDistance = 1858;
 mergeCodes = 1234003;
 modifyDate = "2017-04-21 10:53:33";
 modifyUser = 000000;
 optType = 20;
 orderAppointFlag = 0;
 orderSource = 2;
 passagewayCode = 61;
 passagewayNameCode = "\U4fa7\U5e18";
 planDate = "2017-04-21  11:00--12:00";
 planDeliverEndTime = "12:00";
 planDeliverStartTime = "11:00";
 planDeliverTime = "2016-12-19 00:00:00";
 procInstId = 3397609;
 receiveSort = 0;
 rev = 24;
 sourceAddr = "\U4e1c\U839e\U5e02\U5357\U57ce\U77f3\U9f13\U5de5\U4e1a\U533a";
 sourceCode = 00200103;
 sourceName = "ME-DG\U4e1c\U839e\U5382";
 standyQueueApprovalLyDate = 0;
 status = 212;
 statusName = "\U53f8\U673a\U672a\U63a5\U6536";
 supplierCode = 00200301;
 supplierName = "\U53a6\U95e8\U5b8f\U8c61\U7269\U6d41\U79d1\U6280\U6709\U9650\U516c\U53f8";
 supplierReceiveTime = "2017-04-21 10:53:33";
 totalWeight = 29205;
 transportCode = S8;
 transportName = "\U4fa7\U5e18\U8f66\U8fd0\U8f93";
 truckNumber = "\U9ed1B00000";
 truckTypeCode = 13116;
 truckTypeName = "17.5\U4fa7\U5e18\U8f66";
 updatePlanCount = 0;
 wareDispatchTime = "2017-04-21 00:00:00";
 warehouseType = 10;
 }
 */

@interface HomePageModel : BaseModel

@property (nonatomic, strong) NSMutableArray *orderModelList;   //可接收订单

@property (nonatomic, copy) NSString *bidcount;                 //可抢订单数量

@property (nonatomic, copy) NSString *loadResult;               //请求结果是否有订单

@property (nonatomic, copy) NSString *status;                   //订单状态码

@property (nonatomic, copy) NSString *statusName;               //订单状态

@property (nonatomic, copy) NSString *code;                     //单号

@property (nonatomic, copy) NSString *wareDispatchTime;         //计划装运日期

@property (nonatomic, copy) NSString *sourceName;               //起始地名称

@property (nonatomic, copy) NSString *sourceAddr;               //起始地址

@property (nonatomic, copy) NSString *dcName;                   //收货地名称

@property (nonatomic, copy) NSString *dcAddress;                //收货地地址

@property (nonatomic, copy) NSString *planDate;                 //预约时间

@property (nonatomic, copy) NSString *planAchieveTime;          //预计到达收货工厂时间

@property (nonatomic, copy) NSString *warehouseType;            //仓库类型（10:内仓；11：外仓）

@property (nonatomic, copy) NSString *isRoadSea;                //运输方式是否是海运或者铁运

@property (nonatomic, copy) NSString *transportName;            //运输方式


@end
