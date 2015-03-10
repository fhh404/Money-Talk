//
//  EmailSuccessViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "EmailSuccessViewController.h"
#import "LoginViewController.h"
#import "RootTabBarController.h"
@interface EmailSuccessViewController ()
- (IBAction)finishBtnAction:(UIButton *)sender;

@end

@implementation EmailSuccessViewController

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
    
    self.title = @"忘记密码";
    _finishBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
    
    _serviceLabel.userInteractionEnabled = YES;
    [_serviceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTap:)]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method
#pragma mark 拨打客服电话
-(void)serviceTap:(UITapGestureRecognizer *)gesture{
    UIWebView *callWebview = [[UIWebView alloc] init] ;
    NSString *strPhoneNumber = @"tel:400-6666-800";
    // tel:  或者 tel://
    NSURL *telURL = [NSURL URLWithString:strPhoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}


#pragma mark 完成按钮方法
- (IBAction)finishBtnAction:(UIButton *)sender {
    LoginViewController *login = (LoginViewController *)self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:login animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
