//
//  NewsBoxViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "NewsBoxViewController.h"
#import "RootTabBarController.h"
#import "WaitForReciveViewController.h"
#import "DeliveryReleaseViewController.h"
#import "MessagCenterViewController.h"
@interface NewsBoxViewController ()

@end

@implementation NewsBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"消息盒子";
    
    [_websiteBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)]];
    [_logisticsBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logisticsAction:)]];
    [_deliveryBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deliveryAction:)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method
#pragma mark 网站通知跳转方法
-(void)websiteAction:(UITapGestureRecognizer *)gesture{
    MessagCenterViewController *messageCenter = [[MessagCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenter animated:YES];
}

#pragma mark 物流助手跳转方法
-(void)logisticsAction:(UITapGestureRecognizer *)gesture{
    WaitForReciveViewController *waitForReciver = [[WaitForReciveViewController alloc] init];
//    waitForReciver.titleTxt = @"我的物流";
    waitForReciver.title = @"我的物流";
    [self.navigationController pushViewController:waitForReciver animated:YES];
}

#pragma mark 发货通知跳转方法
-(void)deliveryAction:(UITapGestureRecognizer *)gesture{
    DeliveryReleaseViewController *delivery = [[DeliveryReleaseViewController alloc] init];
    [self.navigationController pushViewController:delivery animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
