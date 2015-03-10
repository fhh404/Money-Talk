//
//  EmailRegisterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "RootTabBarController.h"
#import "SuccessRegisterViewController.h"
#import "UserProtoclViewController.h"
@interface EmailRegisterViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)registerBtnAction:(UIButton *)sender;
- (IBAction)checkBtnAction:(UIButton *)sender;


@end

@implementation EmailRegisterViewController

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
    self.title = @"注册";
    // Do any additional setup after loading the view from its nib.

    _registerBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    
    
    _protocolLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _protocolLabel.userInteractionEnabled = YES;
    [_protocolLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toProtocol:)]];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];    
}

#pragma mark - Method

#pragma mark 健客网用户协议
-(void)toProtocol:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到健客网用户协议页面");
    UserProtoclViewController *userprotocl = [[UserProtoclViewController alloc] init];
    [self.navigationController pushViewController:userprotocl animated:YES];
}

#pragma mark 注册按钮方法
- (IBAction)registerBtnAction:(UIButton *)sender {
    NSLog(@"邮箱注册");
    BOOL isemailRegisterRight = YES;
    if (isemailRegisterRight == YES) {
        [self requestEmailRegisterData];
    }
}

-(void)requestEmailRegisterData{
    [[Loading shareLoading] beginLoading];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":_emailFiled.text,@"newPass":_passwordField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userRegisterByEmail"];
    NSLog(@"%@",urlStr);
    
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}


#pragma mark 复选框按钮方法
- (IBAction)checkBtnAction:(UIButton *)sender {
    NSLog(@"复选框按钮");
    _checkBoxBtn.selected = !_checkBoxBtn.selected;
    if (_checkBoxBtn.selected == YES) {
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else if (_checkBoxBtn.selected == NO){
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
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
                [self showToast:@"邮箱注册成功！"];
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
