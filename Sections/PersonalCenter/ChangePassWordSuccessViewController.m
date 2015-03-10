//
//  ChangePassWordSuccessViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ChangePassWordSuccessViewController.h"
#import "RootTabBarController.h"
#import "LoginViewController.h"
@interface ChangePassWordSuccessViewController ()
{
    NSTimer *timer;
    int seconds;
}

@end

@implementation ChangePassWordSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showMoreBtn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"密码修改";
    _finishedBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _secondLabel.textColor = [UIColor jk_colorWithHexString:@"#db4f48"];
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
#pragma mark 跳转登录
-(void)toLogin{
    
    seconds++;
    _secondLabel.text = [NSString stringWithFormat:@"%d",4-seconds];
    
    
    if (seconds == 3) {
        LoginViewController *login = [[LoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
        [timer invalidate];
        seconds = 0;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
