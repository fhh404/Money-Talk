//
//  ExchangeIntegralViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/23.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ExchangeIntegralViewController.h"
#import "RootTabBarController.h"
@interface ExchangeIntegralViewController ()
{
    int integral;
    int flag;
    UIView *alphaView;
    NSString *accesstoken;
    UIImageView *integrateTipImage;
    UILabel *integrateTipsNum;
    UIImageView *integralProgress;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)fiveyuanBtnAction:(UIButton *)sender;
- (IBAction)tenyuanBtnAction:(UIButton *)sender;
- (IBAction)twentyyuanBtnAction:(UIButton *)sender;
- (IBAction)fiftyyuanBtnAction:(UIButton *)sender;
- (IBAction)exchangeBtnAction:(UIButton *)sender;

@end

@implementation ExchangeIntegralViewController
@synthesize integralNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"积分兑换";
    [self creatProgressUI];
    
    
    _exchangeBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _exchangeBtn.layer.cornerRadius = 5;
    _contentScrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 488);
    _contentScrollow.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    _integralNumberLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    
}

-(void)creatProgressUI{
    integrateTipImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 57, 26, 21)];
    integrateTipImage.image = [UIImage imageNamed:@"integrateNum"];
    [self.view addSubview:integrateTipImage];
    
    integralProgress = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45.5, 0, 9)];
    integralProgress.image = [UIImage imageNamed:@"progress"];
    [self.view addSubview:integralProgress];
    
    integrateTipsNum = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 26, 20)];
    integrateTipsNum.textAlignment = NSTextAlignmentCenter;
    integrateTipsNum.textColor = [UIColor whiteColor];
    integrateTipsNum.text = @"0";
    integrateTipsNum.font = [UIFont fontWithName:@"Arial" size:12];
    [self.view addSubview:integrateTipsNum];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    flag = 0;
    integral = [self.integralNumber intValue];
    _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
    integrateTipsNum.text = self.integralNumber;
    int number = [self.integralNumber intValue];
    integrateTipImage.frame = CGRectMake(8+5*number/100, 57, 26, 21);
    integrateTipsNum.frame = CGRectMake(8+5*number/100, 60, 26, 20);
    integralProgress.frame = CGRectMake(20, 45.5, 5*number/100, 9);
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
}

#pragma mark 兑换5元按钮方法
- (IBAction)fiveyuanBtnAction:(UIButton *)sender {
    if (integral >= 500) {
        _fiveyuanBtn.selected = !_fiveyuanBtn.selected;
        if (_fiveyuanBtn.selected) {
            [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
            [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            flag = 5;
        }else{
            [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        }
        _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
    }else{
        [self tips];
    }
}

#pragma mark 兑换10元按钮方法
- (IBAction)tenyuanBtnAction:(UIButton *)sender {
    if (integral >= 1000) {
        _tenyuanBtn.selected = !_tenyuanBtn.selected;
        if (_tenyuanBtn.selected) {
            [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
            [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            flag = 10;
        }else{
            [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        }
        _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
    }else{
        [self tips];
    }

}

#pragma mark 兑换20元按钮方法
- (IBAction)twentyyuanBtnAction:(UIButton *)sender {
    if (integral >= 2000) {
        _twentyyuanBtn.selected = !_twentyyuanBtn.selected;
        if (_twentyyuanBtn.selected) {
            [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
            [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            flag = 20;
        }else{
            [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        }
        _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
    }else{
        [self tips];
    }

}

#pragma mark 兑换50元按钮方法
- (IBAction)fiftyyuanBtnAction:(UIButton *)sender {
    if (integral >= 5000) {
        _fiftyyuanBtn.selected = !_fiftyyuanBtn.selected;
        if (_fiftyyuanBtn.selected) {
            [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
            [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
            flag = 50;
        }else{
            [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        }
        _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
    }else{
        [self tips];
    }

}

-(void)tips{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"积分不足！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark 兑换按钮方法
- (IBAction)exchangeBtnAction:(UIButton *)sender {
    NSLog(@"flag======%d",flag);
    if (flag != 0) {
        [self requestExchangeData];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择要兑换的积分数！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark 兑换请求
-(void)requestExchangeData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"changeType":[NSString stringWithFormat:@"%d",flag]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/integralExchangeCouponse"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


-(void)creatSuccessExchangeUI{
    alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.75];
    [self.view addSubview:alphaView];
    [alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancle:)]];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 140, 280, 230)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    [alphaView addSubview:whiteView];
    
    UIImageView *iconRight = [[UIImageView alloc] initWithFrame:CGRectMake(120, 20, 40, 40)];
    iconRight.image = [UIImage imageNamed:@"complete"];
    [whiteView addSubview:iconRight];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 120, 20)];
    label1.text = @"恭喜您已成功兑换";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont fontWithName:@"Arial" size:14];
    [whiteView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 80, 30, 20)];
    label2.text = [NSString stringWithFormat:@"%d元",flag];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    label2.font = [UIFont fontWithName:@"Arial" size:14];
    [whiteView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(180, 80,70, 20)];
    label3.text = @"优惠券，";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor darkGrayColor];
    label3.font = [UIFont fontWithName:@"Arial" size:14];
    [whiteView addSubview:label3];

    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, 110,220, 20)];
    label4.text = @"现在可以参加优惠换购啦！";
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = [UIColor darkGrayColor];
    label4.font = [UIFont fontWithName:@"Arial" size:14];
    [whiteView addSubview:label4];
    
    UIButton *toexchangeBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 160, 120, 40)];
    toexchangeBuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    toexchangeBuyBtn.layer.cornerRadius = 5;
    [toexchangeBuyBtn addTarget:self action:@selector(toChangeBuyAction:) forControlEvents:UIControlEventTouchUpInside];
    [toexchangeBuyBtn setTitle:@"去换购" forState:UIControlStateNormal];
    [toexchangeBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView addSubview:toexchangeBuyBtn];
}

-(void)tapCancle:(UITapGestureRecognizer *)gesture{
    flag = 0;
    [alphaView removeFromSuperview];
    [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
}


#pragma mark 去换购按钮方法
-(void)toChangeBuyAction:(UIButton *)btn{
    NSLog(@"点击去换购按钮");
    flag = 0;
    [alphaView removeFromSuperview];
    [_fiveyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_tenyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_twentyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    [_fiftyyuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
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
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                switch (flag) {
                    case 5:
                        integral -= 500;
                        break;
                    case 10:
                        integral -= 1000;
                        break;
                    case 20:
                        integral -= 2000;
                        break;
                    case 50:
                        integral -= 5000;
                        break;
                    default:
                        break;
                }
                [self creatSuccessExchangeUI];
                _integralNumberLabel.text = [NSString stringWithFormat:@"%d",integral];
            
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
