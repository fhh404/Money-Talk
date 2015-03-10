//
//  WaitForEvaluteViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-17.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "WaitForEvaluteViewController.h"
#import "RootTabBarController.h"
#import "FinishedOrderCell.h"
#import "EvaluteViewController.h"
#import "OrderDetailViewController.h"
@interface WaitForEvaluteViewController ()
{
    UITableView *waitForEvaluteTable;
    int currentpage;
    int pageRows;
    NSString *accesstoken;
    NSMutableArray *orderListArr;
    UIView *grayView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation WaitForEvaluteViewController

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
    
    self.title = @"待评价";
    
    [self creatKongUI];
    
    waitForEvaluteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    waitForEvaluteTable.delegate = self;
    waitForEvaluteTable.dataSource = self;
    [self.view addSubview:waitForEvaluteTable];
    
    //注册xib
    [waitForEvaluteTable registerNib:[UINib nibWithNibName:@"FinishedOrderCell" bundle:nil] forCellReuseIdentifier:@"finishedOrder"];
    [self judge];
}

#pragma mark 待评价订单请求
-(void)requestWaitForEvaluteOrder{
    
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllOrderWaitForEvaluate"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"orderType":@"3"};
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
    
    currentpage = 1;
    pageRows = 10;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestWaitForEvaluteOrder];
    }
}


#pragma mark 无数据时的视图
-(void)creatKongUI{
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120)];
    grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:grayView];
    
    UIImageView *shopIconIamge = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, 90, 50, 50)];
    shopIconIamge.image = [UIImage imageNamed:@"noOrderImage"];
    [grayView addSubview:shopIconIamge];
    
    UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 170, 200, 20)];
    tips1.text = @"暂时还没有相关订单";
    tips1.textAlignment = NSTextAlignmentCenter;
    tips1.textColor = [UIColor darkGrayColor];
    tips1.font = [UIFont fontWithName:@"Arial" size:16];
    [grayView addSubview:tips1];
    
    UILabel *tips2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 190, 200, 20)];
    tips2.text = @"选几件必备的东西吧！";
    tips2.textAlignment = NSTextAlignmentCenter;
    tips2.textColor = [UIColor lightGrayColor];
    tips2.font = [UIFont fontWithName:@"Arial" size:12];
    [grayView addSubview:tips2];
    
    UIButton *gotoBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 230, 140, 30)];
    [gotoBuyBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    gotoBuyBtn.layer.cornerRadius = 3;
    [gotoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gotoBuyBtn addTarget:self action:@selector(gotobuy:) forControlEvents:UIControlEventTouchUpInside];
    gotoBuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [grayView addSubview:gotoBuyBtn];
    
}

#pragma mark 去逛逛按钮方法
-(void)gotobuy:(UIButton *)btn{
    NSLog(@"去逛逛");
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root selectAtIndex:10];
}



#pragma mark - evaluteTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orderListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinishedOrderCell *cell = (FinishedOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"finishedOrder"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    cell.orderAmount.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.orderPrice.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.flagLabel.hidden = YES;
    [cell.whiteBtn addTarget:self action:@selector(gotoEvalute:) forControlEvents:UIControlEventTouchUpInside];
    cell.whiteBtn.tag = indexPath.section + 100;
    
    [cell.blueBtn addTarget:self action:@selector(buyMore:) forControlEvents:UIControlEventTouchUpInside];
    cell.blueBtn.tag = indexPath.section + 200;
    
    //赋值
    if (orderListArr.count > 0) {
        cell.orderNumber.text = orderListArr[indexPath.section][@"orderId"];
        cell.orderPrice.text = [NSString stringWithFormat:@"￥%@",orderListArr[indexPath.section][@"orderPrice"]];
        cell.orderTime.text = orderListArr[indexPath.section][@"orderTime"];
        cell.orderAmount.text = orderListArr[indexPath.section][@"totalNumber"];
        cell.orderState.text = orderListArr[indexPath.section][@"orderState"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = orderListArr[indexPath.section][@"orderId"];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark - Method
#pragma mark 跳转到评价页面
-(void)gotoEvalute:(UIButton *)btn{
    // btn.tag -100;
    EvaluteViewController *evaluteDetail = [[EvaluteViewController alloc] init];
    evaluteDetail.productID = orderListArr[btn.tag-100][@"orderId"];
    [self.navigationController pushViewController:evaluteDetail animated:YES];
}

#pragma mark 再次购买按钮方法
-(void)buyMore:(UIButton *)btn{
    NSLog(@"点击再次购买");
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
            NSLog(@"%@,msg==finished=%@", object,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                currentpage++;
                orderListArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                [self judge];
                [waitForEvaluteTable reloadData];
                [[Loading shareLoading] endLoading];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

-(void)judge{
    if (orderListArr.count == 0) {
        grayView.hidden = NO;
        waitForEvaluteTable.hidden = YES;
    }else{
        grayView.hidden = YES;
        waitForEvaluteTable.hidden = NO;
    }
}

@end
