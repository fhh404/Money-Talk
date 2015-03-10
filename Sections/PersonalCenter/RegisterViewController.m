//
//  RegisterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "RegisterViewController.h"
#import "RootTabBarController.h"
#import "InputCodeViewController.h"
#import "EmailRegisterViewController.h"
#import "RegexRuleMethod.h"
@interface RegisterViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)getCodeAction:(UIButton *)sender;

@end

@implementation RegisterViewController

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
    self.showMoreBtn = NO;

    _getCodeBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    
    //邮箱注册
    _emailRegisterLabel.textColor = [UIColor jk_colorWithHexString:@"#0082f0"];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"邮箱注册"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _emailRegisterLabel.attributedText = content;
    _emailRegisterLabel.userInteractionEnabled = YES;
    [_emailRegisterLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toEmailRegister:)]];
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    _telephoneField.inputAccessoryView = topView1;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - Method
#pragma mark 邮箱注册方法
-(void)toEmailRegister:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到邮箱注册页面");
    EmailRegisterViewController *emailRegister = [[EmailRegisterViewController alloc] init];
    [self.navigationController pushViewController:emailRegister animated:YES];
}



#pragma mark 获取验证码按钮方法
- (IBAction)getCodeAction:(UIButton *)sender {
    NSLog(@"获取验证码");
    if ([[RegexRuleMethod regexRule] isTelephone:_telephoneField.text]) {
        [self requestResigerData];
    }else if (_telephoneField.text.length == 0){
        [self showToast: @"输入的手机号不能为空！"];
    }else if ([[RegexRuleMethod regexRule] isTelephone:_telephoneField.text] == 0){
        [self showToast: @"手机号码不存在！"];
    }
}

-(void)requestResigerData{
    
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userRegisterGetVerificationCode"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"loginName":_telephoneField.text};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];

}

-(void)dismissKeyBoard{
    [_telephoneField resignFirstResponder];
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
            NSLog(@"%@，self.class====%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                InputCodeViewController *inputCode = [[InputCodeViewController alloc] init];
                inputCode.telephoneNumber = _telephoneField.text;
                [self.navigationController pushViewController:inputCode animated:YES];
            }else{
                if (object[@"msg"]){
                    [self showToast:object[@"msg"]];
                }else{
                    [self showToast: @"获取验证码失败，请稍后再试"];
                }
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


@end
