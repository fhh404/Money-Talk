//
//  OrderFinishedViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/19.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "OrderFinishedViewController.h"
#import "RootTabBarController.h"
@interface OrderFinishedViewController ()
- (IBAction)backToHomeBtnAction:(UIButton *)sender;
@end

@implementation OrderFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提交完成";
    self.showMoreBtn = NO;
    _backToHomeBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method
#pragma mark 返回首页按钮方法
- (IBAction)backToHomeBtnAction:(UIButton *)sender {
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root selectAtIndex:12];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
