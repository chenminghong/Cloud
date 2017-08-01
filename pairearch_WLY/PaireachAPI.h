//
//  PaireachAPI.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#ifndef PaireachAPI_h
#define PaireachAPI_h

#pragma markk -- APP接口定义

/*============================BaseUrl相关=============================*/
//API前缀定义
//#define PAIREACH_BIDDING_URL             @"http://106.14.39.65:8385/itip/clientBid/"  //竞价中心
#define PAIREACH_BIDDING_URL             @"http://192.168.0.188:8085/itip/clientBid/"  //竞价中心Ada本地


//#define PAIREACH_BASE_URL                @"http://106.14.39.65:8385/itip/client/"       //测试线上
#define PAIREACH_BASE_URL                @"http://192.168.0.188:8085/itip/client/"      //Ada本地IP
//#define PAIREACH_BASE_URL                @"http://192.168.1.14:8086/itip/client/"     //备用
//#define PAIREACH_BASE_URL                @"http://itiptest.paireach.com/client/"       //双至域名


/*============================首页相关=============================*/

//首页数据
#define HOME_PAGE_DATA_API                @"loadFirstUnCheckOrder.a"            //get

//首页订单详情数据
#define LOAD_DETAIL_API                   @"loadOrderDetailById.a"              //get

//接收运单
#define GET_LOAD_API                      @"driverAcceptOrder.a"                //post

//安全选项检查
#define SAFETY_CONFIRMATION_API           @"safeVeriSave.a"                     //post

//地理位置上传
#define UPLOAD_LOCATION_API               @"saveTrackList.a"                //post



/*============================运单中心用户相关=============================*/

//订单中心
#define ORDER_LIST_API                    @"loadAllOrder.a"                 //get

//装货入厂签到
#define SIGN_UP_API                       @"orderHandling.a"                //post

//是否可以进入装货工厂
#define CAN_ENTERFAC_API                  @"canEnterFactory.a"              //post

//装货开始拍照
#define LOAD_START_API                    @"uploadBeforeLoadStart.a"        //post

//装货结束扫码(外仓)
#define OUT_LOAD_END_API                  @"outLoadEndUpload.a"             //post

//装货结束拍照(内仓)
#define IN_LOAD_END_API                   @"uploadAfterLoadEnd.a"           //post

//装货完成
//#define LOAD_END_API                      @"loadEndOrder.a"                 //post

//修改预计到货时间
#define CHANGE_PLAN_ARRIVETIME_API        @"savePlanAchieveTime.a"          //post

//收货签到
#define DELIVERY_SIGN_UP_API              @"uploadBeforeTakeGoods.a"        //post

//收货完成
#define  DELIVERY_COMPLETE_API            @"uploadTakeGoods.a"              //post

//收货完成（不需要上传图片）
//#define DELIVERY_COMPLETEBTN_API          @"unloadEndBeforeUrl.a"                //post
#define DELIVERY_COMPLETEBTN_API          @"orderHandling.a"                //post



/*============================竞价中心相关=============================*/

//竞价中
#define IN_BIDDING_API                    @"queryByScOrderBidForaudit.a"    //get

//竞价中详情
#define BIDDING_DETAIL_API                @"loadByScOrderBidDetails.a"      //get

//当前承运商下的司机车牌号
#define GET_DRIVER_API                    @"loadByScOrderBidDetails.a"      //get

//抢单操作
#define SCRATCH_ORDER_API                 @"saveScBidInfo.a"                //get

//审核中
#define IN_CHECK_API                      @"queryAllScOrderBidForaudit.a"   //get

//审核中运单详情
#define BIDDINF_CHECKING_API              @"loadByScOrderBidDetailsforSh.a" //get

//修改竞价
#define CHANGE_BIDDING_API                @"updateByScBidInfo.a"            //get

//取消竞价
#define CANCEL_BIDDING_API                @"deleteByScBidInfo.a"            //get


//已中标
#define ALREADY_BIDDING_API               @"queryByScOrderBidForZb.a"       //get

//已中标运单详情
#define ALREADY_BIDDING_DETAIL_API        @"loadScorderbidforZb.a"          //get

//历史竞价
#define HISTORY_BIDDING_API               @"queryByScOrderBidHostory.a"     //get



/*============================个人中心用户相关=============================*/

//用户登录
#define USER_LOGIN_API                    @"loginForDriver.a"                   //post

//修改密码
#define CHANGE_PASSWORD_API               @"changeDriverPwd.a"                  //post

//异常反馈
#define ABNORMAL_UPLOAD_API               @"uploadAbnormalPresentationInfo.a"   //post






/*============================通知中心相关=============================*/

#pragma mark -- 通知中心

//接收到JPush自定义消息通知
#define GET_CUSTOM_MESSAGE_NAME           @"get_custom_message_name"           //get







#endif /* PaireachAPI_h */
