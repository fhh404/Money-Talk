//
//  RestPasswordViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "RestPasswordViewController.h"
#import "RootTabBarController.h"
#import "LoginViewController.h"
@interface RestPasswordViewController ()
{
    NSTimer *timer;
    int flag;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)submitBtn:(UIButton *)sender;

@end

@implementation RestPasswordViewController
@synthesize loginTelephone;
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
    
    self.title = @"重置密码";
    _submitBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _tipsView.hidden = YES;
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    _firstPasswordField.inputAccessoryView = topView1;
    _confirmPasswordField.inputAccessoryView = topView1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
}

#pragma mark - Method

#pragma mark 提交按钮方法
- (IBAction)submitBtn:(UIButton *)sender {

    if (_firstPasswordField.text.length >=6 && [_firstPasswordField.text isEqualToString:_confirmPasswordField.text]) {
        [self requestNewPasswordData];
    }else if (_firstPasswordField.text.length < 6 || _confirmPasswordField.text.length < 6){
        _tipsView.hidden = NO;
        _tipsLabel.text = @"你输入的密码过于简单！";
        flag = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tipsAction) userInfo:nil repeats:YES];
        [timer fire];
    }else if ([_firstPasswordField.text isEqualToString:_confirmPasswordField.text] == NO){
        _tipsView.hidden = NO;
        
        _tipsLabel.text = @"两次密码输入不一致！";
        flag = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tipsAction) userInfo:nil repeats:YES];
        [timer fire];
    }
}

-(void)requestNewPasswordData{
    [[Loading shareLoading] beginLoading];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":self.loginTelephone,@"newPass ":_confirmPasswordField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userResetPass"];
    NSLog(@"%@",urlStr);
    
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}


-(void)tipsAction{
    if (flag == 1) {
        _tipsView.hidden = YES;
        [timer invalidate];
    }
    flag++;
}

-(void)dismissKeyBoard{
    [_firstPasswordField resignFirstResponder];
    [_confirmPasswordField resignFirstResponder];
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
            NSLog(@"%@,msg=%@", object,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"密码重置成功,请重新登录！"];
                LoginViewController *login = (LoginViewController *)self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:login animated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

@end
