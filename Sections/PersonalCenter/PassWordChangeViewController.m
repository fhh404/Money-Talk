//
//  PassWordChangeViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "PassWordChangeViewController.h"
#import "RootTabBarController.h"
#import "ChangePassWordSuccessViewController.h"
#import "LoginViewController.h"
@interface PassWordChangeViewController ()


@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)submitBtnAction:(UIButton *)sender;

@end

@implementation PassWordChangeViewController

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
    
    self.title = @"修改密码";
    _submitBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#0082f0"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}



#pragma mark 提交按钮方法
- (IBAction)submitBtnAction:(UIButton *)sender {
    NSLog(@"提交新密码");
    if (_currentField.text.length >= 6 && _newpasswordfield.text.length >= 6 && _repeatNewPasswordField.text.length >= 6 && [_newpasswordfield.text isEqualToString:_repeatNewPasswordField.text])
    {
        [self requestChangePasswordData];
    }else if (_currentField.text.length < 6){
        NSLog(@"旧密码输入有误！");
    }else if (_newpasswordfield.text.length < 6){
        NSLog(@"新密码过于简单！");
    }else if ([_repeatNewPasswordField.text isEqualToString:_newpasswordfield.text] == 0){
        NSLog(@"两次新密码输入不一致！");
    }
}

-(void)requestChangePasswordData{
    NSString *accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    //传入的参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"oldPass":_currentField.text,@"newPass":_newpasswordfield.text,@"twicePass":_repeatNewPasswordField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/changePass"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);

    
    
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

#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@", object);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"密码修改成功！"];
                [[MyUserDefaults defaults] saveToUserDefaults:@"No" withKey:@"isLogin"];
                ChangePassWordSuccessViewController *changePasswordSuccess = [[ChangePassWordSuccessViewController alloc] init];
                [self.navigationController pushViewController:changePasswordSuccess animated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}


@end
