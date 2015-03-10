//
//  SuccessRegisterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "SuccessRegisterViewController.h"
#import "RootTabBarController.h"
#import "LoginViewController.h"
@interface SuccessRegisterViewController ()
{
    NSTimer *timer;
    int seconds;
}

@end

@implementation SuccessRegisterViewController

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
    self.title = @"注册成功";
    self.showMoreBtn;
    // Do any additional setup after loading the view from its nib.
    _backToHomeBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _secondLabel.textColor = [UIColor jk_colorWithHexString:@"ff6a63"];
    _secondLabel.text = @"3";
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(toLogin) userInfo:nil repeats:YES];
    [timer fire];
    seconds = 0;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
}

#pragma mark - Method
-(void)toLogin{
    
    seconds++;
    _secondLabel.text = [NSString stringWithFormat:@"%d",4-seconds];
    
    if (seconds == 3) {
        LoginViewController *login = self.navigationController.viewControllers[1];
        
        [self.navigationController popToViewController:login animated:YES];
        [timer invalidate];
        seconds = 0;
    }
}


#pragma mark 返回首页按钮方法
- (IBAction)backToHomeBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
