//
//  EmailForgetPasswordViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "EmailForgetPasswordViewController.h"
#import "RootTabBarController.h"
#import "EmailSuccessViewController.h"
#import "RegexRuleMethod.h"
@interface EmailForgetPasswordViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)foundBackAction:(UIButton *)sender;
@end

@implementation EmailForgetPasswordViewController
@synthesize feildTxt;
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
    
    _foundBackBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
    _fieldBackView.layer.borderWidth = 0.2;
    _fieldBackView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
    
    _serviceLabel.userInteractionEnabled = YES;
    [_serviceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTap:)]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    _emailField.text = self.feildTxt;
}

#pragma mark - Method
#pragma mark 拨打客服电话
-(void)serviceTap:(UITapGestureRecognizer *)gesture{
    UIWebView *callWebview = [[UIWebView alloc] init] ;
    NSString *strPhoneNumber = @"tel:400-6666-800";
    // tel:  或者 tel://
    NSURL *telURL = [NSURL URLWithString:strPhoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark 找回密码按钮方法
- (IBAction)foundBackAction:(UIButton *)sender {
    NSLog(@"点击找回密码按钮");
    if ([[RegexRuleMethod regexRule] isEmail:_emailField.text]) {
        [self requestEmailNewPasswordData];
    }else{
        NSLog(@"邮箱输入有误！");
    }
}

-(void)requestEmailNewPasswordData{
    [[Loading shareLoading] beginLoading];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":_emailField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userFindPassByEmail"];
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
                EmailSuccessViewController *emailSuccess = [[EmailSuccessViewController alloc] init];
                [self.navigationController pushViewController:emailSuccess animated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

@end
