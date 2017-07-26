//
//  WaitListController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/26.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "WaitListController.h"

@interface WaitListController ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsTitleLabel;

@end

@implementation WaitListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tipsLabel.text = self.tipsStr;
}

- (void)setTipsTitleStr:(NSString *)tipsTitleStr {
    _tipsTitleStr = tipsTitleStr;
    self.tipsTitleLabel.text = tipsTitleStr;
}

- (void)setTipsStr:(NSString *)tipsStr {
    _tipsStr = tipsStr;
    self.tipsLabel.text = tipsStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
