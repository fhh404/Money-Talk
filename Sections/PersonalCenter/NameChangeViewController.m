//
//  NameChangeViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "NameChangeViewController.h"
#import "RootTabBarController.h"
@interface NameChangeViewController ()

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)submitBtnAction:(UIButton *)sender;

@end

@implementation NameChangeViewController

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
    
    self.title = @"修改昵称";
    
    _submitBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#0082f0"];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}


#pragma mark - action methods


#pragma mark 提交按钮方法
- (IBAction)submitBtnAction:(UIButton *)sender {
    NSLog(@"提交修改后的昵称");
    if (_inputField.text.length > 0) {
        [self requestChangeNickNameData];
    }else{
        NSLog(@"昵称不能为空！");
    }
}

-(void)requestChangeNickNameData{
    NSString *accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    //传入的参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"newNickName":_inputField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/changeNickName"];
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
            NSLog(@"%@，self.class===%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"昵称修改成功！"];
                [[MyUserDefaults defaults] saveToUserDefaults:_inputField.text withKey:@"nickName"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
