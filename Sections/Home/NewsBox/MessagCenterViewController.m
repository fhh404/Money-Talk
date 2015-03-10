//
//  MessagCenterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MessagCenterViewController.h"
#import "RootTabBarController.h"
@interface MessagCenterViewController ()
{
    UIView *grayView;
}

@end

@implementation MessagCenterViewController

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
    self.title = @"消息中心";
    
    [self creatKongUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}


#pragma mark - Method
#pragma mark 无数据时的视图
-(void)creatKongUI{
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120)];
    grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:grayView];
    
    UIImageView *shopIconIamge = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, 90, 50, 50)];
    shopIconIamge.image = [UIImage imageNamed:@"noNews"];
    [grayView addSubview:shopIconIamge];
    
    UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 160, 200, 20)];
    tips1.text = @"暂无消息";
    tips1.textAlignment = NSTextAlignmentCenter;
    tips1.textColor = [UIColor darkGrayColor];
    tips1.font = [UIFont fontWithName:@"Arial" size:16];
    [grayView addSubview:tips1];
    
    
    UIButton *gotoBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 200, 140, 30)];
    [gotoBuyBtn setTitle:@"去首页看看" forState:UIControlStateNormal];
    gotoBuyBtn.layer.cornerRadius = 3;
    [gotoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gotoBuyBtn addTarget:self action:@selector(gotobuy:) forControlEvents:UIControlEventTouchUpInside];
    gotoBuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [grayView addSubview:gotoBuyBtn];
    
}

#pragma mark 去逛逛按钮方法
-(void)gotobuy:(UIButton *)btn{
    NSLog(@"去首页看看");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
