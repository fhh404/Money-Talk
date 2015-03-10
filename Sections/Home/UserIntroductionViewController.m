//
//  UserIntroductionViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "UserIntroductionViewController.h"
#import "RootTabBarController.h"

@implementation UserIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"产品说明";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    
    [_contentWebView loadHTMLString:self.htmlString baseURL:nil];
}


@end
