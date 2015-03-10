//
//  LoginViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "LoginViewController.h"
#import "RootTabBarController.h"
#import "RegisterViewController.h"
#import "ForgetPassWordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
@interface LoginViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)loginBtnAction:(UIButton *)sender;

- (IBAction)authorLoginBtn:(UIButton *)sender;
- (IBAction)aliheBtn:(UIButton *)sender;


@end

@implementation LoginViewController

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
    
    self.title = @"会员登录";
    
    _loginBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
      
    
    //合作网站登陆
//    _wangyiImageView.userInteractionEnabled = YES;
//    _QQImageView.userInteractionEnabled = YES;
//    _AlipayImageView.userInteractionEnabled = YES;
//    _sinaImageView.userInteractionEnabled = YES;
//    [_wangyiImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wangyiLogin:)]];
//    [_QQImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authoLogin:)]];
//    [_AlipayImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AlipayLogin:)]];
//    [_sinaImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authoLogin:)]];
    
    //注册和忘记密码
    _zhuceLabel.userInteractionEnabled = YES;
    _forgetPasswordLabel.userInteractionEnabled = YES;
    [_zhuceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerAction:)]];
    [_forgetPasswordLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetAction:)]];
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    _accountField.inputAccessoryView = topView1;
    _passwordField.inputAccessoryView = topView1;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method
#pragma mark 注册
-(void)registerAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"注册");
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

#pragma mark 忘记密码
-(void)forgetAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"忘记密码");
    ForgetPassWordViewController *forgetPassword = [[ForgetPassWordViewController alloc] init];
    [self.navigationController pushViewController:forgetPassword animated:YES];
}

#pragma mark 网易登陆
-(void)wangyiLogin:(UITapGestureRecognizer *)gesture{
    NSLog(@"网易登录");
}

//#pragma mark
//-(void)QQLogin:(UITapGestureRecognizer *)gesture{
//    NSLog(@"QQ登录");
//}

#pragma mark 支付宝登陆
-(void)AlipayLogin:(UITapGestureRecognizer *)gesture{
    NSLog(@"支付宝登录");
}

#pragma mark 新浪登陆\QQ登陆
-(void)authoLogin:(UITapGestureRecognizer *)gesture{
    NSLog(@"授权登录");
    
    
}


#pragma mark 立即登录按钮方法
- (IBAction)loginBtnAction:(UIButton *)sender {
    NSLog(@"点击立即登录按钮");
    if (_accountField.text.length > 0 && _passwordField.text.length >= 6) {
        [self requestLoginData];
    }else if (_accountField.text.length == 0){
        NSLog(@"用户名不能为空！");
    }else if (_passwordField.text.length < 6){
        NSLog(@"密码不能低于6位数！");
    }
}


-(void)requestLoginData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userLogin"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"loginName":_accountField.text,@"passWord":_passwordField.text};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}


#pragma mark 新浪微博/qq授权登陆
- (IBAction)authorLoginBtn:(UIButton *)sender {
    ShareType type = 0;
    switch (sender.tag) {
        case 1:
            type = ShareTypeQQSpace;
            break;
        case 2:
            type = ShareTypeSinaWeibo;
            break;
        default:
            break;
    }
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权登陆成功，已获取用户信息");
            NSString *uid = [userInfo uid];
            NSString *nickname = [userInfo nickname];
            NSString *profileImage = [userInfo profileImage];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code4App" message:[NSString stringWithFormat:@"授权登陆成功,用户ID:%@,昵称:%@,头像:%@",uid,nickname,profileImage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }else{
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code4App" message:@"授权失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];

}

#pragma mark 支付宝授权登陆
- (IBAction)aliheBtn:(UIButton *)sender {
    
}



#pragma mark 键盘收回
-(void)dismissKeyBoard{
    
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
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
            NSLog(@"%@", object);
            if ([object[@"info"][@"accesstoken"] length] > 0) {
                [[MyUserDefaults defaults] saveToUserDefaults:object[@"info"][@"accesstoken"] withKey:@"accesstoken"];
                [[MyUserDefaults defaults] saveToUserDefaults:@"Yes" withKey:@"isLogin"];
            }
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"登录成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if(object[@"msg"]){
                    [self showToast: object[@"msg"]];
                }else{
                    [self showToast: @"帐号或密码错误!"];
                }
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

@end
