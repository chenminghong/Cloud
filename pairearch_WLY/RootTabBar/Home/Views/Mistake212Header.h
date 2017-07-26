//
//  Mistake212Header.h
//  pairearch_WLY
//
//  Created by Jean on 2017/4/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mistake212Header : UIView

@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

/**
 获取表头视图
 
 @return 返回表头视图
 */
+ (instancetype)getHeaderView;

@end
