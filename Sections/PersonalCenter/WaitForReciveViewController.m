//
//  WaitForReciveViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "WaitForReciveViewController.h"
#import "UnFinishedOrderCell.h"
#import "RootTabBarController.h"
#import "OrderDetailViewController.h"
#import "CheckLogisticsViewController.h"
#import "WaitForEvaluteViewController.h"
@interface WaitForReciveViewController ()
{
    UITableView *waitForReciveTable;
    UIView *grayBackView;
    NSString *accesstoken;
    int currentpage;
    int pageRows;
    NSMutableArray *reciverInfoArr;
    UIView *grayView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation WaitForReciveViewController
@synthesize titleTxt;
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
    self.title = @"待收货订单";
    [self creatKongUI];
    
    //评价table
    waitForReciveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    waitForReciveTable.delegate = self;
    waitForReciveTable.dataSource = self;
    waitForReciveTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:waitForReciveTable];
    
    //注册XIB
    [waitForReciveTable registerNib:[UINib nibWithNibName:@"UnFinishedOrderCell" bundle:nil] forCellReuseIdentifier:@"unfinishedorder"];
    [self judgekongData];
}

#pragma mark 已完成订单请求
-(void)requestWaitForReciveOrder{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllOrderWaitForReceiver"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"orderType":@"2"};
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    self.title = self.titleTxt;
    
    currentpage = 1;
    pageRows = 10;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestWaitForReciveOrder];
    }
}



#pragma mark - waitForReciveTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return reciverInfoArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnFinishedOrderCell *cell = (UnFinishedOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"unfinishedorder"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    
    cell.orderPrice.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    cell.orderAmount.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    cell.orderState.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
    //查看物流按钮
    [cell.orderLeftBtn setImage:[UIImage imageNamed:@"blueBtn_short"] forState:UIControlStateNormal];
    cell.leftLabel.text = @"查看物流";
    cell.leftLabel.textColor = [UIColor whiteColor];
    cell.leftLabel.textAlignment = NSTextAlignmentCenter;
    cell.leftLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [cell.orderLeftBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderRightBtn.tag = 300+indexPath.section;
    //确认收货按钮
    [cell.orderRightBtn setImage:[UIImage imageNamed:@"blueBtn_short"] forState:UIControlStateNormal];
    cell.rightLabel.text = @"确认收货";
    cell.rightLabel.textColor = [UIColor whiteColor];
    cell.rightLabel.textAlignment = NSTextAlignmentCenter;
    cell.rightLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [cell.orderRightBtn addTarget:self action:@selector(sureReciveOrder:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderRightBtn.tag = 200+indexPath.section;
    
    //赋值
    if (reciverInfoArr.count > 0) {
        cell.orderAmount.text = reciverInfoArr[indexPath.section][@"totalNumber"];
        cell.orderPrice.text = reciverInfoArr[indexPath.section][@"orderPrice"];
        cell.orderState.text = reciverInfoArr[indexPath.section][@"orderState"];
        cell.orderTime.text = reciverInfoArr[indexPath.section][@"orderTime"];
        cell.orderNumber.text = reciverInfoArr[indexPath.section][@"orderId"];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *kongview = [[UIView alloc] init];
    kongview.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    return kongview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = @"31201311111405371";
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark - Method
-(void)judgekongData{
    if (reciverInfoArr.count == 0) {
        grayView.hidden = NO;
        waitForReciveTable.hidden = YES;
    }else{
        grayView.hidden = YES;
        waitForReciveTable.hidden = NO;
    }
}

#pragma mark 无数据时的视图
-(void)creatKongUI{
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120)];
    grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:grayView];
    
    UIImageView *shopIconIamge = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, 90, 50, 50)];
    shopIconIamge.image = [UIImage imageNamed:@"logistic"];
    [grayView addSubview:shopIconIamge];
    
    UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 160, 200, 20)];
    tips1.text = @"您暂时没有物流消息";
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
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root selectAtIndex:10];
}

#pragma mark 查看物流按钮方法
-(void)checkOrder:(UIButton *)btn{
    NSLog(@"查看物流");
    CheckLogisticsViewController *checkLogistic = [[CheckLogisticsViewController alloc] init];
    checkLogistic.trackingNum = reciverInfoArr[btn.tag-300][@"trackingNum"];
    [self.navigationController pushViewController:checkLogistic animated:YES];
}

#pragma mark 确认收货按钮方法
-(void)sureReciveOrder:(UIButton *)btn{
    NSLog(@"确认收货");
    [self requestSureRecive:(int)btn.tag-200];
}

#pragma mark 已完成订单请求
-(void)requestSureRecive:(int)tagFlag{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/orderReceiver"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderId":reciverInfoArr[tagFlag][@"orderId"]};
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
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
                currentpage++;
                reciverInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                [waitForReciveTable reloadData];
                [self judgekongData];
            }else{
                [self showToast:object[@"msg"]];
                [self judgekongData];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                WaitForEvaluteViewController *waitForEvalute = [[WaitForEvaluteViewController alloc] init];
                [self.navigationController pushViewController:waitForEvalute animated:YES];
            }else{
                [self showToast:object[@"msg"]];
                [self judgekongData];
            }
        }
    }
}

@end
