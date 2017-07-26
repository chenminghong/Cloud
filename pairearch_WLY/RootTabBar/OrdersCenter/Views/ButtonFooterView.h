//
//  ButtonFooterView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/26.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *footerButton;

@property (nonatomic, copy) NSString *buttonTitle;   //按钮标题


/**
 获取当前的页脚视图

 @return 试图对象
 */
+ (instancetype)getFooterButtonView;

@end
