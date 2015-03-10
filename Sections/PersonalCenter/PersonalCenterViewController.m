//
//  PersonalCenterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "AllOrderViewController.h"
#import "WaitForEvaluteViewController.h"
#import "RootTabBarController.h"
#import "WaitForReciveViewController.h"
#import "AccountCenterViewController.h"
#import "PostHeadImageViewController.h"
#import "LoginViewController.h"
#import "WaitForPayViewController.h"
#import "MyIntegeralViewController.h"
#import "MyCollectionViewController.h"
#import "MyCouponViewController.h"
#import "MyAddressViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PersonalCenterViewController ()
{
    NSString *accesstoken;
    NSString *isLogin;
    int flag;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)editBtn:(UIButton *)sender;
- (IBAction)detailBtn:(UIButton *)sender;
- (IBAction)allOrderBtn:(UIButton *)sender;
- (IBAction)waitForPayBtn:(UIButton *)sender;
- (IBAction)waitForevaluteBtn:(UIButton *)sender;
- (IBAction)waitForreviceBtn:(UIButton *)sender;
- (IBAction)loginBtnAction:(UIButton *)sender;

@end

@implementation PersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark 头像点击方法
-(void)headTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"头像点击方法");
    PostHeadImageViewController *postHeadImage = [[PostHeadImageViewController alloc] init];
    [self.navigationController pushViewController:postHeadImage animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的健客";
    self.showMoreBtn = NO;
    
    //视图背景颜色和导航栏颜色
    _personInfoView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    _infoView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    
    
    
    //头像、箭头图标
    _detailBtn.backgroundColor = [UIColor clearColor];
    _headPro.userInteractionEnabled = YES;
    [_headPro addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)]];
    
    //我的收藏、我的积分、我的优惠券
    [_collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToCollectionViewController:)]];
    [_integerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToIntegerViewController:)]];
    [_couponView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToCouponViewController:)]];
    
      //具体数值
    _collectionNumber.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    _integrateNumber.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    _couponNumber.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    
    
    //登陆按钮
    _loginBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
    
    flag = 0;
    [self getNativeData];
}

-(void)getNativeData{
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    NSLog(@"accesstoken ====%@",accesstoken);
    if (accesstoken.length > 0) {
        [self requestPersonInfoData];
    }
    
    isLogin = [[MyUserDefaults defaults] readFromUserDefaults:@"isLogin"];
    if ([isLogin isEqualToString:@"Yes"]) {
        _infoView.hidden = NO;
        _loginBtn.hidden = YES;
    }else{
        _infoView.hidden = YES;
        _loginBtn.hidden = NO;
        [_headPro setImage:[UIImage imageNamed:@"headportrait"]];
        _collectionNumber.text = @"0";
        _couponNumber.text = @"0";
        _integrateNumber.text = @"0";
        [[MyUserDefaults defaults] saveToUserDefaults:@"" withKey:@"nickName"];
        [[MyUserDefaults defaults] saveToUserDefaults:@"" withKey:@"phone"];
    }
    
    flag++;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root showTabBar];
    isLogin = [[MyUserDefaults defaults] readFromUserDefaults:@"isLogin"];
    if (flag >= 2) {
        [self getNativeData];
    }else{
        flag++;
    }
    
}

-(void)requestPersonInfoData{
    [[Loading shareLoading] beginLoading];
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getUserInfos"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];

}




#pragma mark 我的收藏跳转方法
-(void)ToCollectionViewController:(UITapGestureRecognizer *)gerture{
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"跳转到我的收藏详细页面");
        MyCollectionViewController *myCollection = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:myCollection animated:YES];
    }
}

#pragma mark 我的积分跳转方法
-(void)ToIntegerViewController:(UITapGestureRecognizer *)gerture{
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"跳转到我的积分详细页面");
        MyIntegeralViewController *myIntegral = [[MyIntegeralViewController alloc] init];
        [self.navigationController pushViewController:myIntegral animated:YES];
    }
}

#pragma mark 我的优惠券跳转方法
-(void)ToCouponViewController:(UITapGestureRecognizer *)gerture{
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"跳转到我的优惠券详细页面");
        MyCouponViewController *myCoupon= [[MyCouponViewController alloc] init];
        [self.navigationController pushViewController:myCoupon animated:YES];
    }
}



#pragma mark 我的收货地址按钮方法
- (IBAction)editBtn:(UIButton *)sender {
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"我的收货地址");
        MyAddressViewController *myAddress = [[MyAddressViewController alloc] init];
        [self.navigationController pushViewController:myAddress animated:YES];
    }
}

#pragma mark 详情箭头按钮方法
- (IBAction)detailBtn:(UIButton *)sender {
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"进入个人信息详情");
        AccountCenterViewController *accountCenter = [[AccountCenterViewController alloc] init];
        [self.navigationController pushViewController:accountCenter animated:YES];
    }
}

#pragma mark 全部订单按钮方法
- (IBAction)allOrderBtn:(UIButton *)sender {
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"进入订单页面");
        AllOrderViewController *allorder = [[AllOrderViewController alloc] init];
        [self.navigationController pushViewController:allorder animated:YES];
    }
}

#pragma mark 待付款按钮方法
- (IBAction)waitForPayBtn:(UIButton *)sender {
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"进入待付款页面");
        WaitForPayViewController *waitForPay = [[WaitForPayViewController alloc] init];
        [self.navigationController pushViewController:waitForPay animated:YES];
    }
}

#pragma mark 待评价按钮方法
- (IBAction)waitForevaluteBtn:(UIButton *)sender{
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"进入待评价页面");
        WaitForEvaluteViewController *evalute = [[WaitForEvaluteViewController alloc] init];
        [self.navigationController pushViewController:evalute animated:YES];
    }
}

#pragma mark 待收货按钮方法
- (IBAction)waitForreviceBtn:(UIButton *)sender {
    if ([isLogin isEqualToString:@"Yes"] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        NSLog(@"进入待收货页面");
        WaitForReciveViewController *waitForRecive = [[WaitForReciveViewController alloc] init];
        waitForRecive.titleTxt = @"待收货订单";
        [self.navigationController pushViewController:waitForRecive animated:YES];
    }
}

#pragma mark 登陆按钮方法
- (IBAction)loginBtnAction:(UIButton *)sender {
    NSLog(@"跳转到登陆页面");
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [_headPro loadImageFromURL:[NSURL URLWithString:object[@"info"][@"headPic"]]];

                _nameLabel.text = object[@"info"][@"nickName"];
                _collectionNumber.text = [NSString stringWithFormat:@"%@",object[@"info"][@"myCollectionNum"]];
                _couponNumber.text = [NSString stringWithFormat:@"%@",object[@"info"][@"myCouponNum"]];
                _integrateNumber.text = [NSString stringWithFormat:@"%@",object[@"info"][@"myIntegralNum"]];
                [[MyUserDefaults defaults] saveToUserDefaults:object[@"info"][@"nickName"] withKey:@"nickName"];
                [[MyUserDefaults defaults] saveToUserDefaults:object[@"info"][@"phone"] withKey:@"phone"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
    
}
@end
