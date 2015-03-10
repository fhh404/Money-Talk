//
//  ForgetPassWordViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "RootTabBarController.h"
#import "RegexRuleMethod.h"
#import "EmailForgetPasswordViewController.h"
#import "RestPasswordViewController.h"
@interface ForgetPassWordViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)nextBtnAction:(UIButton *)sender;
- (IBAction)postCodeBtn:(UIButton *)sender;

@end

@implementation ForgetPassWordViewController

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
    
//    _backImageView.backgroundColor = [UIColor jk_colorWithHexString:@"#0082f0"];
    _nextBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _postBtnLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    //为客服电话添加下划线
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"客服电话修改：600-6666-800"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _serviceTelephoneLabel.attributedText = content;
    _serviceTelephoneLabel.userInteractionEnabled = YES;
    [_serviceTelephoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callForService:)]];
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    _phoneAndAddressField.inputAccessoryView = topView1;
    _codeField.inputAccessoryView = topView1;
    
    _phoneAndAddressField.delegate = self;

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
}

#pragma mark - Method
#pragma mark 拨打客服电话方法
-(void)callForService:(UITapGestureRecognizer *)gesture{
    NSLog(@"拨打客服电话");
    UIWebView *callWebview = [[UIWebView alloc] init] ;
    NSString *strPhoneNumber = @"tel:400-6666-800";
    // tel:  或者 tel://
    NSURL *telURL = [NSURL URLWithString:strPhoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark 下一步按钮方法
- (IBAction)nextBtnAction:(UIButton *)sender {
    NSLog(@"点击下一步按钮");
    if ([[RegexRuleMethod regexRule] isTelephone:_phoneAndAddressField.text] && _codeField.text.length > 0) {
        //请求方法
        [self requestTelephoneNextData];
    }else if ([[RegexRuleMethod regexRule] isTelephone:_phoneAndAddressField.text] == 0){
        NSLog(@"手机号不存在！");
    }else if (_codeField.text.length == 0){
        NSLog(@"验证码输入不能为空！");
    }
}

-(void)requestTelephoneNextData{
    [[Loading shareLoading] beginLoading];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":_phoneAndAddressField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userFindPassGetVerificationCode"];
    NSLog(@"%@",urlStr);

    
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:101];
}


-(void)dismissKeyBoard{
    if ([[RegexRuleMethod regexRule] isEmail:_phoneAndAddressField.text]) {
        NSLog(@"email is right");
        EmailForgetPasswordViewController *emailForget = [[EmailForgetPasswordViewController alloc] init];
        emailForget.feildTxt = _phoneAndAddressField.text;
        [self.navigationController pushViewController:emailForget animated:YES];
    }
    NSLog(@"resiger");
    [_phoneAndAddressField resignFirstResponder];
    [_codeField resignFirstResponder];
}

#pragma mark 发送验证码按钮方法
- (IBAction)postCodeBtn:(UIButton *)sender {
    NSLog(@"点击发送验证码按钮");
    if ([[RegexRuleMethod regexRule] isTelephone:_phoneAndAddressField.text]) {
        [self requestTelephoneCodeData];
    }else{
        NSLog(@"手机号码不存在！");
    }
}

-(void)requestTelephoneCodeData{
    //传入的参数
    NSDictionary *parameters = @{@"loginName":_phoneAndAddressField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userFindPassGetVerificationCode"];
    NSLog(@"%@",urlStr);
    
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([[RegexRuleMethod regexRule] isEmail:_phoneAndAddressField.text]) {
        EmailForgetPasswordViewController *emailForget = [[EmailForgetPasswordViewController alloc] init];
        emailForget.feildTxt = _phoneAndAddressField.text;
        [self.navigationController pushViewController:emailForget animated:YES];
    }
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
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"验证码已发送！"];
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 101){
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                RestPasswordViewController *restPassword = [[RestPasswordViewController alloc] init];
                restPassword.loginTelephone = _phoneAndAddressField.text;
                [self.navigationController pushViewController:restPassword animated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


@end
