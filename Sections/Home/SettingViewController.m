//
//  SettingViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "SettingViewController.h"
#import "RootTabBarController.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "NewsNotifiyViewController.h"
@interface SettingViewController ()
- (IBAction)switchBtnAction:(UIButton *)sender;
- (IBAction)serviceBtnAction:(UIButton *)sender;
- (IBAction)LoginOutBtnAction:(UIButton *)sender;

@end

@implementation SettingViewController

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
    
    self.title = @"设置";
    
    
    _loginOutBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
    
    [_newsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsTap:)]];
    [_aboutUsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutUsTap:)]];
    [_versionUpdateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(versionUpdateTap:)]];
    [_feedBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedBackTap:)]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method

#pragma mark 消息提醒方法
-(void)newsTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击消息提醒");
    NewsNotifiyViewController *newsNotify = [[NewsNotifiyViewController alloc] init];
    [self.navigationController pushViewController:newsNotify animated:YES];
}

#pragma mark 关于我们方法
-(void)aboutUsTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到关于我们页面");
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUs animated:YES];
}

#pragma mark 版本更新方法
-(void)versionUpdateTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"检测版本更新");
}

////测试版本更新
//-(void)onCheckVersion
//{
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    //CFShow((__bridge CFTypeRef)(infoDic));
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    
//    NSString *URL = @"http://itunes.apple.com/lookup?id=622493449";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:URL]];
//    [request setHTTPMethod:@"POST"];
//    NSHTTPURLResponse *urlResponse = nil;
//    NSError *error = nil;
//    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    
//    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [results objectFromJSONString];
//    NSArray *infoArray = [dic objectForKey:@"results"];
//    if ([infoArray count]) {
//        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
//        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
//        
//        if (![lastVersion isEqualToString:currentVersion]) {
//            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//            alert.tag = 10000;
//            [alert show];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alert.tag = 10001;
//            [alert show];
//        }
//    }
//}
//
//
//
//#pragma mark Alert_delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag==10000) {
//        if (buttonIndex==1) {
//            NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id622493449"];//622493449
//            [[UIApplication sharedApplication]openURL:url];
//        }
//    }
//}

#pragma mark 意见反馈方法
-(void)feedBackTap:(UITapGestureRecognizer *)gesture{
    FeedBackViewController *feedBack = [[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBack animated:YES];
}


#pragma mark 高清图复选按钮方法
- (IBAction)switchBtnAction:(UIButton *)sender {
    _highImageSwitchBtn.selected = !_highImageSwitchBtn.selected;
    if (_highImageSwitchBtn.selected == YES) {
        [_highImageSwitchBtn setImage:[UIImage imageNamed:@"switchStart"] forState:UIControlStateNormal];
    }else if (_highImageSwitchBtn.selected == NO){
        [_highImageSwitchBtn setImage:[UIImage imageNamed:@"switchStop"] forState:UIControlStateNormal];
    }
    
}

#pragma mark 客服电话按钮
- (IBAction)serviceBtnAction:(UIButton *)sender {
    UIWebView *callWebview = [[UIWebView alloc] init] ;
    NSString *strPhoneNumber = @"tel:400-6666-800";
    // tel:  或者 tel://
    NSURL *telURL = [NSURL URLWithString:strPhoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark 退出当前账号按钮
- (IBAction)LoginOutBtnAction:(UIButton *)sender {
    [[MyUserDefaults defaults] saveToUserDefaults:@"" withKey:@"accesstoken"];
    [[MyUserDefaults defaults] saveToUserDefaults:@"No" withKey:@"isLogin"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
