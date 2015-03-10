//
//  OrderDetailViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "RootTabBarController.h"
#import "OrderDetailCell.h"
#import "AddressDetailCell.h"
#import "OrderStateCell.h"
@interface OrderDetailViewController ()
{
    UITableView *orderDetailTabel;
    NSString *accesstoken;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;


@end

@implementation OrderDetailViewController
@synthesize orderId;
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
    
    self.title = @"订单详情";
    
    
    //评价table
    orderDetailTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    orderDetailTabel.delegate = self;
    orderDetailTabel.dataSource = self;
    orderDetailTabel.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:orderDetailTabel];
    
    //注册XIB
    [orderDetailTabel registerNib:[UINib nibWithNibName:@"OrderDetailCell" bundle:nil] forCellReuseIdentifier:@"productDeatil"];
    [orderDetailTabel registerNib:[UINib nibWithNibName:@"AddressDetailCell" bundle:nil] forCellReuseIdentifier:@"addressDetail"];
    [orderDetailTabel registerNib:[UINib nibWithNibName:@"OrderStateCell" bundle:nil] forCellReuseIdentifier:@"orderState"];
}

#pragma mark 订单详情请求
-(void)requestOrderDetailData{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/orderDetials"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderId":self.orderId};
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
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (self.orderId.length > 0) {
        [self requestOrderDetailData];
    }
}



#pragma mark - orderDetailTabel_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        return 170;
    }
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else if (section == 2){
        return 50;
    }
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailCell *cell1 = (OrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"productDeatil"];
    AddressDetailCell *cell2 = (AddressDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"addressDetail"];
    OrderStateCell *cell3 = (OrderStateCell *)[tableView dequeueReusableCellWithIdentifier:@"orderState"];
    if (indexPath.section == 0) {
        cell1.productPrice.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
        return cell1;
    }else if (indexPath.section == 1){
        return cell2;
    }else if (indexPath.section == 2){
        cell3.payMoney.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
        cell3.stateLabel.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
        return cell3;
    }
    return 0;
}

/*
 订单详情分三种情况：
 1.已完成订单详情：底部包含两个按钮（查看物流按钮(蓝色)、确认收货按钮（橙红色））标识为100
 2.已签收订单详情: 底部包含两个按钮（评论按钮（蓝色）、再次购买按钮（橙红色））标识位200
 3.已付款订单详情：底部包含一个按钮（再次购买按钮（橙红色））标识位300
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    int flag = 300;
    
    if (section == 0) {
        UIView *presentAllView = [[UIView alloc] init];
        presentAllView.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 60, 20)];
        label1.text = @"显示全部";
        label1.font = [UIFont fontWithName:@"Arial" size:12];
        label1.textColor = [UIColor darkTextColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [presentAllView addSubview:label1];
        
        UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [downBtn setImage:[UIImage imageNamed:@"presentAll"] forState:UIControlStateNormal];
        downBtn.frame = CGRectMake(175, 5, 20, 20);
        [downBtn addTarget:self action:@selector(presentAll:) forControlEvents:UIControlEventTouchUpInside];
        [presentAllView addSubview:downBtn];
        
        return presentAllView;
    }else if (section == 2){
        UIView *footerView = [[UIView alloc] init];
        if (flag == 100) {
            //查看物流按钮
            UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 120, 30)];
            checkBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
            [checkBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:checkBtn];
            //确认收货按钮
            UIButton *sureReciveBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, 10, 120, 30)];
            sureReciveBtn.backgroundColor = [UIColor jk_colorWithHexString:@"ff6a63"];
            [sureReciveBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [sureReciveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sureReciveBtn addTarget:self action:@selector(sureReciveAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sureReciveBtn];
            
        }else if (flag == 200){
            //评论按钮
            UIButton *evaluteBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 120, 30)];
            evaluteBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
            [evaluteBtn setTitle:@"评价" forState:UIControlStateNormal];
            [evaluteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [evaluteBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:evaluteBtn];
            //再次购买按钮
            UIButton *rebuyBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, 10, 120, 30)];
            rebuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"ff6a63"];
            [rebuyBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            [rebuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rebuyBtn addTarget:self action:@selector(rebuyAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:rebuyBtn];
        }else if (flag == 300){
            //再次购买按钮
            UIButton *rebuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, 30)];
            rebuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"ff6a63"];
            [rebuyBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            [rebuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rebuyBtn addTarget:self action:@selector(rebuyAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:rebuyBtn];
        }
        return footerView;
    }
    return  0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色

}

#pragma mark - Method
#pragma mark 显示全部按钮方法
-(void)presentAll:(UIButton *)btn{
    NSLog(@"显示全部");
}

#pragma mark 查看物流按钮方法
-(void)checkAction:(UIButton *)btn{
    NSLog(@"查看物流");
}

#pragma mark 确认收货按钮方法
-(void)sureReciveAction:(UIButton *)btn{
    NSLog(@"确认收货");
}

#pragma mark 再次购买按钮方法
-(void)rebuyAction:(UIButton *)btn{
    NSLog(@"再次购买");
}

#pragma mark 评论按钮方法
-(void)evaluateAction:(UIButton *)btn{
    NSLog(@"评论");
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
            NSLog(@"%@,self.class====%@", object,self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
               
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}
@end
