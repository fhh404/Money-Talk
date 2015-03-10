//
//  ShakeViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/22.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ShakeViewController.h"
#import "RootTabBarController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "ExchangeIntegralViewController.h"
@interface ShakeViewController ()
{
    int flag;
    UIView *alphaView1;
    UIView *alphaView;
    BOOL canShake;
    SystemSoundID soundID;
    NSString *accesstoken;
    NSString *integral;
    
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"摇呀摇";
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    _summaryBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#FF8C00"];
    _summaryBtn.layer.cornerRadius = 12;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimations) name:@"shake" object:nil];
}

-(void)requestLastTimeData{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/shakeTheIntegralGetLeftTimes"];
    NSLog(@"urlStr ===== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    NSLog(@"parameters===%@",parameters);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestLastTimeData];
    }

}

#pragma mark - Method
#pragma mark 强制竖屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark 摇一摇动画效果
- (void)addAnimations
{
    
    AudioServicesPlaySystemSound (soundID);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.repeatCount = 3;//重复一次
    anim.values = @[@-80, @80, @-80];//晃动幅度
    [_iconImage.layer addAnimation:anim forKey:nil];//添加晃动视图
}





#pragma mark 摇一摇的判断方法
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    //检测到摇动
    NSLog(@"检测到摇动");
    [self addAnimations];

}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
    NSLog(@"摇动取消");
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动结束
    NSLog(@"摇动结束");
    
    if (event.subtype == UIEventSubtypeMotionShake) {
        if (accesstoken.length > 0) {
            [self requestScoreData];
        }

        //something happens
        if (canShake) {
//            if (flag < 3) {
//                if (flag%2 == 0) {
//                    NSLog(@"成功！");
//                    [self creatSuccessUI];
//                }else if (flag%2 == 1){
//                    NSLog(@"失败！");
//                    [self creatFailedUI];
//                }
//                flag++;
//                canShake = NO;
//                [_summaryBtn setTitle:[NSString stringWithFormat:@"今天还能摇%d次",3-flag] forState:UIControlStateNormal];
//                if (flag == 3) {
                    _tipsLabel.text = @"亲，今天的机会已用完，明天再来吧~";
                    _tipsLabel.numberOfLines = 2;
//                }
//            }else{
//                _tipsLabel.text = @"亲，今天的机会已用完，明天再来吧~";
//                _tipsLabel.numberOfLines = 2;
//                
//            }
            
            
            
        }
    }
}


-(void)requestScoreData{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/shakeTheIntegralResult"];
    NSLog(@"urlStr ===== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    NSLog(@"parameters===%@",parameters);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
    
}



#pragma mark 弹出视图
-(void)creatSuccessUI{
    alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.75];
    [self.view addSubview:alphaView];
    
    UIImageView *winingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, [UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.width-100)];
    winingImageView.image = [UIImage imageNamed:@"wining"];
    [alphaView addSubview:winingImageView];
    
    UIImageView *pointsCouponImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-90, [UIScreen mainScreen].bounds.size.width/2-75, 100, 50)];
    pointsCouponImage.image = [UIImage imageNamed:@"pointsCoupon"];
    [winingImageView addSubview:pointsCouponImage];
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 20)];
    pointsLabel.text = [NSString stringWithFormat:@"%@点",integral];
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    pointsLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFF00"];
    pointsLabel.font = [UIFont fontWithName:@"Couier-Bold" size:16];
    [pointsCouponImage addSubview:pointsLabel];
    
    
    UIButton *exchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.width+40, 100, 40)];
    exchangeBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    [exchangeBtn setTitle:@"兑换积分" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeBtn.layer.cornerRadius = 2;
    [exchangeBtn addTarget:self action:@selector(exchangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaView addSubview:exchangeBtn];
}

-(void)creatFailedUI{
    alphaView1 = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView1.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.75];
    [self.view addSubview:alphaView1];
    
    UIImageView *winingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, [UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.width-100)];
    winingImageView.image = [UIImage imageNamed:@"unwining"];
    [alphaView1 addSubview:winingImageView];
    
    
    UIButton *tryAgainBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.width+40, 100, 40)];
    tryAgainBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [tryAgainBtn setTitle:@"再试一次" forState:UIControlStateNormal];
    tryAgainBtn.layer.cornerRadius = 2;
    [tryAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tryAgainBtn addTarget:self action:@selector(tryAgainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaView1 addSubview:tryAgainBtn];
}

#pragma mark 兑换积分按钮方法
-(void)exchangeBtnAction:(UIButton *)btn{

    [alphaView removeFromSuperview];
    
    ExchangeIntegralViewController *exchange = [[ExchangeIntegralViewController alloc] init];
    [self.navigationController pushViewController:exchange animated:YES];
}

-(void)tryAgainBtnAction:(UIButton *)btn{
    [alphaView1 removeFromSuperview];
}



#pragma mark 更多按钮方法
- (IBAction)moreBtn:(UIButton *)sender {
    NSLog(@"点击更多按钮");
    CGPoint point = CGPointMake(275, 64);
    NSArray *titles = @[@"首页", @"用药提醒", @"个人中心",@"购物车"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        RootTabBarController *root = (RootTabBarController *)self.tabBarController;
        if (index == 0) {
            NSLog(@"首页");
            [root selectAtIndex:10];
        }else if (index == 1){
            NSLog(@"用药提醒");
            [root selectAtIndex:11];
        }else if (index == 2){
            NSLog(@"个人中心");
            [root selectAtIndex:12];
        }else if (index == 3){
            NSLog(@"购物车");
            [root selectAtIndex:13];
        }
    };
    [pop show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"object===100===%@,self.class====%@,msg===%@",object,self.class,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [_summaryBtn setTitle:[NSString stringWithFormat:@"今天还能摇%@次",object[@"info"][@"leftTimes"]] forState:UIControlStateNormal];
            
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:[NSString stringWithFormat:@"%@",error]];
        } else {
            NSLog(@"object===200===%@,self.class====%@,msg====%@",object,self.class,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [_summaryBtn setTitle:[NSString stringWithFormat:@"今天还能摇%@次",object[@"info"][@"leftTimes"]] forState:UIControlStateNormal];
                if ([object[@"info"][@"integral"]intValue] > 0) {
                    integral = object[@"info"][@"integral"];
                    [self creatSuccessUI];
                }else{
                    [self creatFailedUI];
                }
                if ([object[@"info"][@"leftTimes"]intValue] == 0) {
                    _tipsLabel.text = @"亲，今天的机会已用完，明天再来吧~";
                    _tipsLabel.numberOfLines = 2;
                }

            }else{
                [self showToast:object[@"msg"]];
                if ([object[@"info"][@"leftTimes"]intValue] == 0) {
                    _tipsLabel.text = @"亲，今天的机会已用完，明天再来吧~";
                    _tipsLabel.numberOfLines = 2;
                }
            }
        }
    }
}

@end
