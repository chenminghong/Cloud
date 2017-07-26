//
//  FooterSelectView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/4/25.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterSelectView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectButton;


/**
 页脚视图

 @return 获取页脚视图
 */
+ (instancetype)getFooterView;

@end
