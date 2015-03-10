//
//  DeliveryReleaseViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "DeliveryReleaseViewController.h"
#import "RootTabBarController.h"
#import "DeliveryReleaseCell.h"
@interface DeliveryReleaseViewController ()
{
    UITableView *deliveryTable;
    UIView *grayView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation DeliveryReleaseViewController

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
    
    self.title = @"发货通知";
    
    [self creatKongUI];
    
    deliveryTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-80) style:UITableViewStyleGrouped];
    deliveryTable.delegate = self;
    deliveryTable.dataSource = self;
    [self.view addSubview:deliveryTable];
    
    //注册xib
    [deliveryTable registerNib:[UINib nibWithNibName:@"DeliveryReleaseCell" bundle:nil] forCellReuseIdentifier:@"deliveryCell"];
    deliveryTable.hidden = YES;
}

//-(void)requestPersonInfoData{
//    
//    NSDictionary *parameters = nil;
//    //url地址
//    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getHomePageLists"];
//    NSLog(@"urlStr ==inputCode== %@",urlStr);
//    
//    if (self.jsonRequest == nil){
//        self.jsonRequest = [[JsonRequest alloc] init];
//        self.jsonRequest.delegate = self;
//    }
//    
//    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - deliveryTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryReleaseCell *cell = (DeliveryReleaseCell *)[tableView dequeueReusableCellWithIdentifier:@"deliveryCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    cell.tipslabel.text = [NSString stringWithFormat:@"您购买的[%@]已发货。",@"维C银翘片/双黄连"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色

}

#pragma mark - Method
-(void)judgeKongData{

}

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

#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            if ([object[@"result"] isEqualToNumber:@0]) {
                
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
        }
    }
}

@end
