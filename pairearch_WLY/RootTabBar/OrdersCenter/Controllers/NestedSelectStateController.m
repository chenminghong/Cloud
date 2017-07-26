//
//  NestedSelectStateController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NestedSelectStateController.h"

#import "HomePageModel.h"
#import "Mistake212Controller.h"
#import "WaitTimeoutController.h"
#import "WaitListController.h"
#import "OutStorage220Controller.h"
#import "OrderStatus224Controller.h"
#import "OrderStatus226Controller.h"
#import "OrderStatus228Controller.h"
#import "OrderStatus230Controller.h"
#import "OrderStatus232Controller.h"
#import "OrderStatus244Controller.h"
#import "OrderStatus248Controller.h"


@interface NestedSelectStateController ()

@property (nonatomic, copy) NSString *code;            //订单编号

@property (nonatomic, assign) NSInteger status;        //订单状态码

@property (nonatomic, copy) NSString *warehouseType;            //仓库类型（10:内仓；11：外仓）

@end

@implementation NestedSelectStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomMessageAction:) name:GET_CUSTOM_MESSAGE_NAME object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeJumpToDetailController) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)getCustomMessageAction:(NSNotification *)sender {
    NSDictionary *userInfo = [sender userInfo];
    NSInteger flag = [userInfo[@"flag"] integerValue];
    if (flag == 0) {
        self.homePageModel.code = userInfo[@"orderCode"];
        self.homePageModel.status = userInfo[@"status"];
        self.code = self.homePageModel.code;
        self.status = self.homePageModel.status.integerValue;;
    }
    
}

- (void)setHomePageModel:(HomePageModel *)homePageModel {
    _homePageModel = homePageModel;
    self.code = homePageModel.code;
    self.status = homePageModel.status.integerValue;
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    [self judgeJumpToDetailController];
}

- (void)judgeJumpToDetailController {
    [self judgeJumpToDetailControllerWithStatus:self.status code:self.code];
}


//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailControllerWithStatus:(NSInteger)status code:(NSString *)code {
    NSLog(@"status:%ld", status);
    switch (status) {
        case ORDER_STATUS_220://已接收待签到
        {
            self.title = @"装货工厂签到";
            if (self.homePageModel.warehouseType.integerValue == WarehouseTypeInside) {
                Mistake212Controller *childVC = [Mistake212Controller new];
                [self addChildController:childVC];
                childVC.homePageModel = self.homePageModel;
            } else {
                OutStorage220Controller *childVC = [OutStorage220Controller new];
                [self addChildController:childVC];
                childVC.homePageModel = self.homePageModel;
            }
        }
            break;
            
        case ORDER_STATUS_224:
        case ORDER_STATUS_225:
        case ORDER_STATUS_227:
        {
            [self getIsEnterFactory];
        }
            break;
            
        case ORDER_STATUS_226:
        {
            self.title = @"开始装货";
            OrderStatus226Controller *childVC = [OrderStatus226Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
        }
            break;
            
        case ORDER_STATUS_228:
        {
            self.title = @"装货中";
            OrderStatus228Controller *childVC = [OrderStatus228Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
            childVC.warehouseType = self.homePageModel.warehouseType;
        }
            break;
            
        case ORDER_STATUS_230:
        {
            self.title = @"装货完成";
            OrderStatus230Controller *childVC = [OrderStatus230Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
        }
            break;
            
        case ORDER_STATUS_232:
        {
            if ([self.homePageModel.isRoadSea containsString:@"海铁"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            self.title = @"收货签到";
            OrderStatus232Controller *childVC = [OrderStatus232Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
            childVC.planAchieveTime = self.homePageModel.planAchieveTime;
        }
            break;
            
        case ORDER_STATUS_244:
        {
            self.title = @"卸货完成";
            OrderStatus244Controller *childVC = [OrderStatus244Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
        }
            break;
            
        case ORDER_STATUS_248:
        {
            self.title = @"收货完成";
            OrderStatus248Controller *childVC = [OrderStatus248Controller new];
            [self addChildController:childVC];
            childVC.code = code;
            childVC.status = status;
        }
            break;
            
        default:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}

//判断是否能进入装货工厂
- (void)getIsEnterFactory {
    [[NetworkHelper shareClient] GET:CAN_ENTERFAC_API parameters:@{@"userName":[LoginModel shareLoginModel].tel, @"orderCode":self.code} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self isEnterFactoryWithStatus:str.integerValue];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//根据224状态判断跳转那个界面
- (void)isEnterFactoryWithStatus:(NSInteger)status {
    if (status == 0) {//候补排队
        WaitListController *childVC = [WaitListController new];
        [self addChildController:childVC];
        if (self.status == ORDER_STATUS_224) {
            self.title = @"装货厂外排队";
            childVC.tipsStr = @"您已签到成功，请在厂外等候入厂通知！";
        } else {
            self.title = @"装货候补排队";
            childVC.tipsStr = @"您已签到成功，并进入候补排队队列，请联系承运商申请装货入厂排队！";
        }
        childVC.tipsTitleStr = self.title;
    } else if (status == 1) {
        //调用当前运能情况接口（返回0或者1）
        self.title = @"入厂提示";
        OrderStatus224Controller *childVC = [OrderStatus224Controller new];
        [self addChildController:childVC];
        childVC.status = self.status;
        childVC.code = self.code;
    } else if (status == 2) {//车辆超时
        self.title = @"预约超时";
        WaitTimeoutController *childVC = [WaitTimeoutController new];
        [self addChildController:childVC];
    }
}

//添加子视图控制器
- (void)addChildController:(UIViewController *)viewController {
    if (self.childViewControllers.count > 0) {
        if ([[self.childViewControllers[0] class] isSubclassOfClass:[viewController class]]) {
            return;
        }
        [self.childViewControllers[0] removeFromParentViewController];
        [self.view.subviews[0] removeFromSuperview];
        
        [self addChildViewController:viewController];
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            viewController.view.frame = self.view.bounds;
            [self.view insertSubview:viewController.view atIndex:0];
        } completion:nil];
        
    } else {
        [self addChildViewController:viewController];
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            viewController.view.frame = self.view.bounds;
            [self.view insertSubview:viewController.view atIndex:0];
        } completion:nil];
    }
}

#pragma mark -- ButtonAction

//返回按钮
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
