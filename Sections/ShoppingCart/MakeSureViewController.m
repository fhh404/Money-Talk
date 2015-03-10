//
//  MakeSureViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/19.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MakeSureViewController.h"
#import "RootTabBarController.h"
#import "OnlinePayHeadCell.h"
#import "OnlinePayContentCell.h"
#import "PayStyleCell.h"
#import "OrderFinishedViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "SBJson4.h"
#import "SBJson4Writer.h"
@interface MakeSureViewController ()
{
    UITableView *onlinePayTable;
    NSMutableArray *_dataArray;
    BOOL isopen;
    UIImageView *iconImage;
    NSString *accesstoken;
    NSMutableArray *payOrderInfoArr;
    NSMutableDictionary *totalDic;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation MakeSureViewController
@synthesize orderNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"确认支付";
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    



    onlinePayTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-0) style:UITableViewStyleGrouped];
    onlinePayTable.delegate = self;
    onlinePayTable.dataSource = self;
    onlinePayTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    onlinePayTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:onlinePayTable];
    
    //注册xib
    [onlinePayTable registerNib:[UINib nibWithNibName:@"OnlinePayHeadCell" bundle:nil] forCellReuseIdentifier:@"onlinePayHead"];
    [onlinePayTable registerNib:[UINib nibWithNibName:@"OnlinePayContentCell" bundle:nil] forCellReuseIdentifier:@"onlinePayContentCell"];
    [onlinePayTable registerNib:[UINib nibWithNibName:@"PayStyleCell" bundle:nil] forCellReuseIdentifier:@"paystyleCell"];
}


#pragma mark 未完成订单请求
-(void)requestPayOrderData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/orderWaitForPayPayRightNow"];
    NSLog(@"urlStr ==inputCode== %@,orderNumber===%@",urlStr,self.orderNumber);
    
    //数组转换为字符串
    NSString *jsonString = [JKJsonHelper toJsonString:self.orderNumber];
    NSLog(@"str=====%@",jsonString);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderIds":jsonString};
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
    if (accesstoken.length > 0) {
        [self requestPayOrderData];
    }
}

#pragma mark - onlinePayTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (payOrderInfoArr.count > 0) {
        if (section >= 1 && section < 1+payOrderInfoArr.count) {
            if ([_dataArray[section] intValue] == 0) {
                return 0;
            }
            return [payOrderInfoArr[section-1][@"orderDetails"]count];
        }
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+payOrderInfoArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (payOrderInfoArr.count > 0) {
        if (indexPath.section >= 1 && indexPath.section < 1+payOrderInfoArr.count){
            return 40;
        }else if (indexPath.section == 0) {
            return 60;
        }else if (indexPath.section == 1+payOrderInfoArr.count) {
            return 140;
        }
    }else{
        if (indexPath.section == 0) {
            return 60;
        }
        return 140;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (payOrderInfoArr.count > 0) {
        if (section >= 1 && section < 1+payOrderInfoArr.count) {
            return 50;
        }else if (section == 1+payOrderInfoArr.count){
            return 40;
        }
        return 10;
    }else{
        if (section == 1) {
            return  40;
        }
    }
        
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (payOrderInfoArr.count > 0) {
        if (section >= 1 && section < 1+payOrderInfoArr.count) {
            return 40;
        }else if (section == 1+payOrderInfoArr.count){
            return 80;
        }
        return 1;
    }else{
        if (section == 1) {
            return 80;
        }
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OnlinePayHeadCell *cell_head = (OnlinePayHeadCell *)[tableView dequeueReusableCellWithIdentifier:@"onlinePayHead"];
        cell_head.backgroundColor = [UIColor whiteColor];
        cell_head.amountpriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        if (payOrderInfoArr.count > 0) {
            cell_head.amountpriceLabel.text = totalDic[@"totalPay"];
            cell_head.addtionlabel.text = [NSString stringWithFormat:@"(包含%@元运费)",totalDic[@"sendValue"]];
        }
        return cell_head;
    }else if (indexPath.section >= 1 && indexPath.section < 1+ payOrderInfoArr.count){
        if (payOrderInfoArr.count > 0) {
            OnlinePayContentCell *cell_content = (OnlinePayContentCell *)[tableView dequeueReusableCellWithIdentifier:@"onlinePayContentCell"];
            cell_content.backgroundColor = [UIColor whiteColor];
            //赋值
            cell_content.productPriceLabel.text = [NSString stringWithFormat:@"￥%@",payOrderInfoArr[indexPath.section-1][@"orderDetails"][indexPath.row][@"productTotalPrice"]];
            cell_content.pruductNameLabel.text = [NSString stringWithFormat:@"￥%@",payOrderInfoArr[indexPath.section-1][@"orderDetails"][indexPath.row][@"productName"]];
            cell_content.productNumberLabel.text = [NSString stringWithFormat:@"￥%@",payOrderInfoArr[indexPath.section-1][@"orderDetails"][indexPath.row][@"procuctNum"]];
            return cell_content;
        }else{
            PayStyleCell *cell_paystyle = (PayStyleCell *)[tableView dequeueReusableCellWithIdentifier:@"paystyleCell"];
            cell_paystyle.backgroundColor = [UIColor whiteColor];
            [cell_paystyle.zhifubaoBtn addTarget:self action:@selector(zhifubaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell_paystyle.caifutongBtn addTarget:self action:@selector(caifutongBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell_paystyle;
        }
    }else{
        PayStyleCell *cell_paystyle = (PayStyleCell *)[tableView dequeueReusableCellWithIdentifier:@"paystyleCell"];
        cell_paystyle.backgroundColor = [UIColor whiteColor];
        [cell_paystyle.zhifubaoBtn addTarget:self action:@selector(zhifubaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell_paystyle.caifutongBtn addTarget:self action:@selector(caifutongBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell_paystyle;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (payOrderInfoArr.count > 0) {
        if (section >= 1 && section <= payOrderInfoArr.count) {
            UIView *allview = [[UIView alloc] init];
            allview.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
            control.tag = section;
            control.backgroundColor = [UIColor whiteColor];
            [control addTarget:self action:@selector(controlCliked:) forControlEvents:UIControlEventTouchUpInside];
            [allview addSubview:control];
            
            UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20,10,200, 20)];
            titleLabel1.font = [UIFont fontWithName:@"Arial" size:15];
            titleLabel1.textAlignment = NSTextAlignmentLeft;
            titleLabel1.textColor = [UIColor blackColor];
            titleLabel1.text = payOrderInfoArr[section-1][@"orderId"];
            [control addSubview:titleLabel1];
            
            iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 20, 20)];
            iconImage.image = [UIImage imageNamed:@"presentAll"];
            [control addSubview:iconImage];
            
            
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
            lineImageView.image = [UIImage imageNamed:@"grayLine"];
            lineImageView.alpha = 0.5;
            [control addSubview:lineImageView];
            
            return allview;
            
        }else if (section == payOrderInfoArr.count+1){
            UIView *allview = [[UIView alloc] init];
            allview.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
            view.backgroundColor = [UIColor whiteColor];
            [allview addSubview:view];
            
            UILabel *styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
            styleLabel.text = @"选择支付方式";
            styleLabel.textColor = [UIColor blackColor];
            styleLabel.textAlignment = NSTextAlignmentLeft;
            styleLabel.font = [UIFont fontWithName:@"Arial" size:15];
            [view addSubview:styleLabel];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 39, 280, 1)];
            lineImageView.image = [UIImage imageNamed:@"grayLine"];
            lineImageView.alpha = 0.5;
            [view addSubview:lineImageView];
            
            
            return allview;
        }
    }else if (section == 1){
        UIView *allview = [[UIView alloc] init];
        allview.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [allview addSubview:view];
        
        UILabel *styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
        styleLabel.text = @"选择支付方式";
        styleLabel.textColor = [UIColor blackColor];
        styleLabel.textAlignment = NSTextAlignmentLeft;
        styleLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [view addSubview:styleLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 39, 280, 1)];
        lineImageView.image = [UIImage imageNamed:@"grayLine"];
        lineImageView.alpha = 0.5;
        [view addSubview:lineImageView];
        
        
        return allview;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section >= 1 && section <= payOrderInfoArr.count) {
        UIView *allView = [[UIView alloc] init];
        allView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [allView addSubview:view];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        lineImageView.image = [UIImage imageNamed:@"grayLine"];
        lineImageView.alpha = 0.5;
        [view addSubview:lineImageView];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 20)];
        numberLabel.text = [NSString stringWithFormat:@"共%ld件商品",[payOrderInfoArr[section-1]count]];
        numberLabel.textColor = [UIColor lightGrayColor];
        numberLabel.textAlignment = NSTextAlignmentLeft;
        numberLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [view addSubview:numberLabel];

        UILabel *transferCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 90, 20)];
        float cost = 10.00;
        transferCostLabel.text = [NSString stringWithFormat:@"运费:￥%.2f",cost];
        transferCostLabel.textColor = [UIColor lightGrayColor];
        transferCostLabel.textAlignment = NSTextAlignmentLeft;
        transferCostLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [view addSubview:transferCostLabel];
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 90, 20)];
        float cost1 = 31.20;
        amountLabel.text = [NSString stringWithFormat:@"小计:￥%.2f",cost1];
        amountLabel.textColor = [UIColor lightGrayColor];
        amountLabel.textAlignment = NSTextAlignmentLeft;
        amountLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [view addSubview:amountLabel];
        return allView;
    }else if (section == payOrderInfoArr.count+1){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        UIButton *sureFOrPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        [sureFOrPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [sureFOrPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureFOrPayBtn.layer.cornerRadius = 3;
        sureFOrPayBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        [sureFOrPayBtn addTarget:self action:@selector(sureforPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureFOrPayBtn];
        return view;
    }
    return 0;
}
#pragma mark - Method
#pragma mark 确认支付按钮方法
-(void)sureforPayBtnAction:(UIButton *)btn{
    NSLog(@"点击确认支付按钮");
    
    if (accesstoken.length > 0) {
        [self requestForPay];
    }
}

-(void)requestForPay{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PreUrl,@"/Alipay/requestParams"];
    NSLog(@"%@",urlStr);
    //数组转换为字符串
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.orderNumber.count; i++) {
        [tempArr addObject:self.orderNumber[i][@"orderId"]];
    }
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [writer stringWithObject:tempArr];
    
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderIds":jsonStr};
    NSLog(@"parameters=====%@",parameters);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:101];
}



#pragma mark - 表格折叠
-(void)controlCliked:(UIControl *)control{
    NSNumber *number = _dataArray[control.tag];
    isopen = [number boolValue];
    isopen = !isopen;
    if (isopen) {
        iconImage.image = [UIImage imageNamed:@"upArrow"];
    }else if (isopen == NO){
        iconImage.image = [UIImage imageNamed:@"presentAll"];
    }
    number = [NSNumber numberWithDouble:isopen];
    _dataArray[control.tag] = number;
    [onlinePayTable reloadSections:[NSIndexSet indexSetWithIndex:control.tag] withRowAnimation:UITableViewRowAnimationAutomatic];

}


#pragma mark 支付宝选项按钮方法
-(void)zhifubaoBtnAction:(UIButton *)btn{
    if (payOrderInfoArr.count > 0) {
        PayStyleCell *cell_paystyle = (PayStyleCell *)[onlinePayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1+payOrderInfoArr.count]];
        cell_paystyle.zhifubaoBtn.selected = !cell_paystyle.zhifubaoBtn.selected;
        if (cell_paystyle.zhifubaoBtn.selected == YES) {
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }else if (cell_paystyle.zhifubaoBtn.selected == NO){
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }else{
        PayStyleCell *cell_paystyle = (PayStyleCell *)[onlinePayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell_paystyle.zhifubaoBtn.selected = !cell_paystyle.zhifubaoBtn.selected;
        if (cell_paystyle.zhifubaoBtn.selected == YES) {
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }else if (cell_paystyle.zhifubaoBtn.selected == NO){
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark 财付通选项按钮方法
-(void)caifutongBtnAction:(UIButton *)btn{
    if (payOrderInfoArr.count > 0) {
        PayStyleCell *cell_paystyle = (PayStyleCell *)[onlinePayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1+payOrderInfoArr.count]];
        cell_paystyle.caifutongBtn.selected = !cell_paystyle.caifutongBtn.selected;
        if (cell_paystyle.caifutongBtn.selected == YES) {
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }else if (cell_paystyle.caifutongBtn.selected == NO){
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }else{
        PayStyleCell *cell_paystyle = (PayStyleCell *)[onlinePayTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell_paystyle.caifutongBtn.selected = !cell_paystyle.caifutongBtn.selected;
        if (cell_paystyle.caifutongBtn.selected == YES) {
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            [cell_paystyle.zhifubaoBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }else if (cell_paystyle.caifutongBtn.selected == NO){
            [cell_paystyle.caifutongBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }

    
}



- (void)didReceiveMemoryWarning {
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
                totalDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                payOrderInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                [_dataArray removeAllObjects];
                for (int i = 0; i < 2+payOrderInfoArr.count; i++) {
                    [_dataArray addObject:[NSNumber numberWithBool:NO]];
                }
                [onlinePayTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else{
        if (error){
            NSLog(@"%@ request error: %@", self.class, error.localizedDescription);
            
        } else {
            
            NSString *params = object[@"info"][@"parames"][@"params"];
            NSLog(@"%@ response alipay params: %@", self.class, params);

             NSString *appScheme = @"jiankemall";
            [[AlipaySDK defaultService] payOrder:params fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
            
        }
    }
}

-(NSString *)subString:(NSString *)string{
    
    NSString *str = string;
    NSRange range = [str rangeOfString:@"=\""];
    NSString *subStr = [str substringFromIndex:range.location+range.length];
    return [subStr substringToIndex:subStr.length-1];
}
@end
