//
//  BidCheckingFooterView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/25.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidCheckingFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tonnageLabel;            //货物吨重
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;          //承运商
@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;       //车牌号
@property (weak, nonatomic) IBOutlet UILabel *remainderTimeLabel;      //剩余时间标签

@property (weak, nonatomic) IBOutlet UIButton *changeBidButton;               //修改报价按钮

@property (weak, nonatomic) IBOutlet UIButton *cancelBidButton;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;    //报价的价格标签

@property (nonatomic, copy) NSString *deadLineTime;                     //到报价截止时间剩余时长

@property (nonatomic, assign) NSTimeInterval interval;                  //竞价截止时间戳

@property (nonatomic, strong) NSTimer *timer;                           //定时器



/**
 获取页脚视图

 @return 返回创建的对象
 */
+ (instancetype)getFooterView;

@end
