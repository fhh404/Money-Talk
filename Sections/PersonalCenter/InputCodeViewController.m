//
//  InputCodeViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "InputCodeViewController.h"
#import "RootTabBarController.h"
#import "SuccessRegisterViewController.h"
#import "UserProtoclViewController.h"
//动画时间
#define kAnimationDuration 0.2
@interface InputCodeViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;


- (IBAction)rePostCodeBtnAction:(UIButton *)sender;
- (IBAction)checkBoxBtnAction:(UIButton *)sender;
- (IBAction)registerBtnAction:(UIButton *)sender;

@end

@implementation InputCodeViewController
@synthesize telephoneNumber;
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
    
    self.title = @"会员注册";
    
    _rePostBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _resigerBtn.backgroundColor = [UIColor jk_colorWithHexString:@"569b24"];
    _contentSrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,488);
    
    //健客网用户协议
    _protoclLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _protoclLabel.userInteractionEnabled = YES;
    [_protoclLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protoclAction:)]];
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    _messageInputField.inputAccessoryView = topView1;
    _passwordField.inputAccessoryView = topView1;
    _affiarPasswordField.inputAccessoryView = topView1;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - Method
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有输入框的view的位置
    if ([_passwordField isFirstResponder]||[_affiarPasswordField isFirstResponder]) {
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
        [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+150)];//keyboardRect.size.height-kViewHeight
        [UIView commitAnimations];
    }
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80)];
    [UIView commitAnimations];
}


#pragma mark 健客网用户协议
-(void)protoclAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到用户协议页面");
    UserProtoclViewController *userprotocl = [[UserProtoclViewController alloc] init];
    [self.navigationController pushViewController:userprotocl animated:YES];
}


#pragma mark 个人信息按钮方法
- (IBAction)personInfoBtn:(UIButton *)sender {
    NSLog(@"个人信息");
}

#pragma mark 重新发送按钮方法
- (IBAction)rePostCodeBtnAction:(UIButton *)sender {
     NSLog(@"重新发送验证码");
}

#pragma mark 复选框按钮方法
- (IBAction)checkBoxBtnAction:(UIButton *)sender {
     NSLog(@"点击复选框");
    _checkBoxBtn.selected = !_checkBoxBtn.selected;
    if (_checkBoxBtn.selected == YES) {
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else if (_checkBoxBtn.selected == NO){
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
}

#pragma mark 注册按钮方法
- (IBAction)registerBtnAction:(UIButton *)sender {
     NSLog(@"注册");
    if (_messageInputField.text.length > 0 && _passwordField.text.length >= 6 && [_passwordField.text isEqualToString:_affiarPasswordField.text] && _checkBoxBtn.selected == YES) {
        [self requestCodeData];
    }else if (_messageInputField.text.length == 0){
        NSLog(@"验证码不能为空！");
    }else if (_passwordField.text.length < 6){
        NSLog(@"密码不能低于6位数！");
    }else if ([_passwordField.text isEqualToString:_affiarPasswordField.text] == 0){
        NSLog(@"两次密码输入不一致！");
    }else if (_checkBoxBtn.selected == NO){
        NSLog(@"请阅读健客网用户协议！");
    }
}

-(void)requestCodeData{
    [[Loading shareLoading] beginLoading];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":self.telephoneNumber,@"verificationCode":_messageInputField.text,@"newPass":_affiarPasswordField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userRegister"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);

    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


-(void)dismissKeyBoard{
    [_messageInputField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_affiarPasswordField resignFirstResponder];
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
            NSLog(@"%@,self.class===%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"手机号注册成功，请立即登录！"];
                SuccessRegisterViewController *successRegister = [[SuccessRegisterViewController alloc] init];
                [self.navigationController pushViewController:successRegister animated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

@end
