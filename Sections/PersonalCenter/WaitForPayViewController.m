//
//  WaitForPayViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "WaitForPayViewController.h"
#import "RootTabBarController.h"
#import "WaitForPayCell.h"
#import "OrderDetailViewController.h"
#import "MakeSureViewController.h"
#import "MJRefresh.h"
@interface WaitForPayViewController ()
{
    UITableView *waitForPayTable;
    NSMutableArray *payInfoArr;
    NSString *accesstoken;
    int currentpage;
    int pageRows;
    NSDictionary *tempDic;
    NSMutableArray *orderIds;
    int flag;
    UIView *grayView;
    NSIndexPath *deleteIndexpath;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)allCheckBoxBtnAction:(UIButton *)sender;
- (IBAction)accountBtnAction:(UIButton *)sender;

@end

@implementation WaitForPayViewController

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
    self.title = @"待付款";
    
    orderIds = [[NSMutableArray alloc] init];
    [self creatKongUI];
    _amountPrice.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    _jiesuanBackView.hidden = YES;
    //评价table
    waitForPayTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50-64) style:UITableViewStyleGrouped];
    waitForPayTable.delegate = self;
    waitForPayTable.dataSource = self;

    waitForPayTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:waitForPayTable];
    
    //注册XIB
    [waitForPayTable registerNib:[UINib nibWithNibName:@"WaitForPayCell" bundle:nil] forCellReuseIdentifier:@"waitForPay"];
    
    // 集成待付款订单刷新控件
    [self setupwaitForPayRefresh];
    
    [self judge];
}

- (void)setupwaitForPayRefresh
{
    
    // 上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [waitForPayTable addFooterWithTarget:self action:@selector(waitForPayFooterRereshing)];
    
    waitForPayTable.footerPullToRefreshText = @"上拉加载更多";
    waitForPayTable.footerReleaseToRefreshText = @"松开马上加载更多";
    waitForPayTable.footerRefreshingText = @"正在帮你加载中.....";
}




#pragma mark 已完成订单请求
-(void)requestWaitForPayOrder{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllOrderWaitForPay"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"orderType":@"0"};
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
    
    flag= 0;
    currentpage = 1;
    [payInfoArr removeAllObjects];
    pageRows = 10;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestWaitForPayOrder];
    }
}

#pragma mark 无数据时的视图
-(void)creatKongUI{
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
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




#pragma mark - waitForPayTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return payInfoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaitForPayCell *cell = (WaitForPayCell *)[tableView dequeueReusableCellWithIdentifier:@"waitForPay"];
    cell.orderAmount.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.productPrice.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.iconmoneyLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    [cell.checkBoxBtn addTarget:self action:@selector(chenkOne:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkBoxBtn.tag = indexPath.section + 100;
    
    //赋值
    if (payInfoArr.count > 0) {
        [cell.productImage loadImageFromURL:[NSURL URLWithString:payInfoArr[indexPath.section][@"productPic"]]];
        cell.productPrice.text = payInfoArr[indexPath.section][@"orderPrice"];
        cell.orderID.text = payInfoArr[indexPath.section][@"orderId"];
        cell.orderstate.text = payInfoArr[indexPath.section][@"orderState"];
        cell.orderTime.text = payInfoArr[indexPath.section][@"orderTime"];
        cell.orderAmount.text = payInfoArr[indexPath.section][@"totalNumber"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = payInfoArr[indexPath.section][@"orderId"];
    [self.navigationController pushViewController:orderDetail animated:YES];
}


#pragma mark 左滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self requestDeleteData:indexPath];
    }
}

#pragma mark - Method

#pragma mark 删除cell请求
-(void)requestDeleteData:(NSIndexPath *)indexpath{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/deleteOrder"];
    NSLog(@"urlStr ==inputCode== %@,orderId====%@",urlStr,payInfoArr[indexpath.section][@"orderId"]);
    deleteIndexpath = indexpath;
    
    
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderId":payInfoArr[indexpath.section][@"orderId"]};
    NSLog(@"parameters====%@",parameters);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}





#pragma mark cell上的复选按钮方法
-(void)chenkOne:(UIButton *)btn{
    WaitForPayCell *cell = (WaitForPayCell *)[waitForPayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:btn.tag-100]];
    cell.checkBoxBtn.selected = !cell.checkBoxBtn.selected;
    if (cell.checkBoxBtn.selected == YES) {
        [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else if (cell.checkBoxBtn.selected == NO){
        [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
    [self amountallPrice];
}


#pragma mark 全选按钮方法
- (IBAction)allCheckBoxBtnAction:(UIButton *)sender {
    NSLog(@"点击全选按钮");
    _allCheckBoxBtn.selected = !_allCheckBoxBtn.selected;
    if (_allCheckBoxBtn.selected == YES) {
        [_allCheckBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        for (int i = 0; i < payInfoArr.count; i++) {
            WaitForPayCell *cell = (WaitForPayCell *)[waitForPayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.checkBoxBtn.selected = YES;
            [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        }
    }else if (_allCheckBoxBtn.selected == NO){
        [_allCheckBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        for (int i = 0; i < payInfoArr.count; i++) {
            WaitForPayCell *cell = (WaitForPayCell *)[waitForPayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.checkBoxBtn.selected = NO;
            [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
    [self amountallPrice];
}


-(void)amountallPrice{
    float amount = 0;
    for (int i = 0; i < payInfoArr.count; i++) {
        WaitForPayCell *cell = (WaitForPayCell *)[waitForPayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        if (cell.checkBoxBtn.selected == YES) {
            amount += [cell.productPrice.text floatValue];
            tempDic =  @{@"orderId":payInfoArr[i][@"orderId"]};
            [orderIds addObject:tempDic];
            NSLog(@"orderIds====%@",orderIds);
            flag++;
        }
    }
    _amountPrice.text = [NSString stringWithFormat:@"￥%.2f",amount];
}

#pragma mark 立即支付按钮方法
- (IBAction)accountBtnAction:(UIButton *)sender {
    NSLog(@"点击结算按钮");
    if (flag > 0) {
        MakeSureViewController *makesure = [[MakeSureViewController alloc] init];
        makesure.orderNumber = orderIds;
        [self.navigationController pushViewController:makesure animated:YES];
    }else{
        NSLog(@"请勾选要支付的订单");
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
        }else {
            NSLog(@"%@,self.class=====%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                currentpage++;
                if (payInfoArr == nil) {
                    payInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                }else{
                    if ([object[@"info"][@"orderLists"]count] > 0) {
                        [payInfoArr addObjectsFromArray:object[@"info"][@"orderLists"]];
                    }else{
                        [self showToast:@"没有更多的数据可以加载"];
                    }
                }
                [self judge];
                [waitForPayTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        }else {
            NSLog(@"%@,self.clas=====%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [payInfoArr removeObjectAtIndex:[deleteIndexpath section]];  //删除数组里的数据
                [waitForPayTable reloadData];
                [self judge];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}



-(void)waitForPayFooterRereshing{
    [self requestWaitForPayOrder];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [waitForPayTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [waitForPayTable footerEndRefreshing];
    });
}



-(void)judge{
    if (payInfoArr.count == 0) {
        _jiesuanBackView.hidden = YES;
        grayView.hidden = NO;
        waitForPayTable.hidden = YES;
    }else{
        _jiesuanBackView.hidden = NO;
        grayView.hidden = YES;
        waitForPayTable.hidden = NO;
    }
}

@end
