//
//  OrderSureViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "OrderSureViewController.h"
#import "RootTabBarController.h"
#import "HeadForOrderCell.h"
#import "OrderContentCell.h"
#import "OrderSureFootCell.h"
#import "OrderDetailViewController.h"
#import "MyAddressViewController.h"
#import "OrderFinishedViewController.h"
#import "MakeSureViewController.h"
#import "SBJson4.h"
#import "SBJson4Writer.h"
@interface OrderSureViewController ()
{
    UITableView *orderSureTable;
    int flag;
    NSString *accesstoken;
    NSMutableDictionary *orderDataDic;
    UIButton *isUseBtn;
    NSString *isOnlinepay;
    NSString *isNeedInovice;
    NSString *yuanNumber;
    UIToolbar *topView1 ;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation OrderSureViewController
@synthesize carGoodsIds;
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
    self.title = @"订单确认";
    self.showMoreBtn = NO;

    isNeedInovice = @"false";
    
    orderSureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
    orderSureTable.delegate = self;
    orderSureTable.dataSource = self;
    orderSureTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderSureTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:orderSureTable];
    
    //注册xib
    [orderSureTable registerNib:[UINib nibWithNibName:@"HeadForOrderCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [orderSureTable registerNib:[UINib nibWithNibName:@"OrderContentCell" bundle:nil] forCellReuseIdentifier:@"orderContentCell"];
    [orderSureTable registerNib:[UINib nibWithNibName:@"OrderSureFootCell" bundle:nil] forCellReuseIdentifier:@"orderFootCell"];
    
    //给键盘添加收回按钮
    topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard2)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];

}

-(void)dismissKeyBoard2{
    HeadForOrderCell *cell = (HeadForOrderCell *)[orderSureTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.invoiceField resignFirstResponder];
    [cell.remarkTextView resignFirstResponder];
}


#pragma mark 结算请求
-(void)requestOrderData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/jiesuan"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    //数组转换为字符串
//    NSString *jsonString = [JsonUtil toJSONString:self.carGoodsIds];
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [writer stringWithObject:self.carGoodsIds];
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"carGoodsIds":jsonStr};
    NSLog(@"parameters=====%@",parameters);
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
    
    yuanNumber = @"0";
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestOrderData];
    }
}


#pragma mark - orderSureTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return [orderDataDic[@"priductLists"]count];
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 300;
    }else if (indexPath.section == 1){
        return 120;
    }else if (indexPath.section == 2){
        return 40;
    }
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 40;
    }else if (section == 2){
        if ([orderDataDic[@"couponHave"]count] > 0){
           return 50;
        }
        return 10;
    }else if (section == 3){
        return 10;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1){
        return 30;
    }else if (section == 3){
        return 80;
    }
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HeadForOrderCell *cell_head = (HeadForOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        cell_head.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        cell_head.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell_head.onlinePayBtn addTarget:self action:@selector(onlinePayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell_head.reciverPayBtn addTarget:self action:@selector(reciverPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell_head.whiteBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressDetail:)]];
        [cell_head.arrowBtn addTarget:self action:@selector(toAddressDetail:) forControlEvents:UIControlEventTouchUpInside];
        cell_head.invoiceView.hidden = YES;
        cell_head.invoiceLabel.hidden = YES;
        [cell_head.isNeedInvoiceBtn addTarget:self action:@selector(isNeedInvoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //赋值
        if (orderDataDic) {
            cell_head.reciverLabel.text = orderDataDic[@"receiverName"];
            cell_head.addressLabel.text = orderDataDic[@"receiverAddress"];
            cell_head.telephoneLabel.text = orderDataDic[@"receiverPhone"];
        }
        cell_head.invoiceField.inputAccessoryView = topView1;
        cell_head.remarkTextView.inputAccessoryView = topView1;
        
        return cell_head;
    }else if (indexPath.section == 1){
        OrderContentCell *cell_ordercontent = (OrderContentCell *)[tableView dequeueReusableCellWithIdentifier:@"orderContentCell"];
        cell_ordercontent.backgroundColor = [UIColor whiteColor];
        cell_ordercontent.priceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        
        
        //赋值
        if ([orderDataDic[@"priductLists"]count] > 0) {
            cell_ordercontent.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderDataDic[@"priductLists"][indexPath.row][@"productPrice"]];
            cell_ordercontent.marketPrice.text = [NSString stringWithFormat:@"￥%@",orderDataDic[@"priductLists"][indexPath.row][@"productMarketPrice"]];
            cell_ordercontent.productNumberLabel.text = [NSString stringWithFormat:@"共%@件",orderDataDic[@"priductLists"][indexPath.row][@"productNum"]];
            cell_ordercontent.productName.text = orderDataDic[@"priductLists"][indexPath.row][@"productName"];
            cell_ordercontent.orderStateLabel.text = orderDataDic[@"priductLists"][indexPath.row][@"productSize"];
            [cell_ordercontent.productImageView loadImageFromURL:[NSURL URLWithString:orderDataDic[@"priductLists"][indexPath.row][@"productPic"]]];
        }
        
        //添加删除线
        NSUInteger length = [cell_ordercontent.marketPrice.text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell_ordercontent.marketPrice.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
        [cell_ordercontent.marketPrice setAttributedText:attri];
        return cell_ordercontent;
    }else if (indexPath.section == 2){
        static NSString *identifer = @"cellMark";
        UITableViewCell *cell_couponbtn = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell_couponbtn == nil) {
            cell_couponbtn = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        if ([orderDataDic[@"couponHave"]count] > 0){
            for (int i = 0; i < [orderDataDic[@"couponHave"]count]; i++) {
                UIButton *yuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                yuanBtn.frame = CGRectMake(7+70*i, 10, 70, 20);
                [yuanBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
                [yuanBtn setTitle:orderDataDic[@"couponHave"][i][@"coupon"] forState:UIControlStateNormal];
                [yuanBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                yuanBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
                yuanBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 45);
                yuanBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
                yuanBtn.tag = 300+i;
                [yuanBtn addTarget:self action:@selector(yuanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell_couponbtn.contentView addSubview:yuanBtn];
                cell_couponbtn.textLabel.hidden = YES;
            }
        }else{
            cell_couponbtn.textLabel.text = @"暂时没有优惠券";
        }

        return cell_couponbtn;
    }else if (indexPath.section == 3){
        OrderSureFootCell *cell_orderfoot = (OrderSureFootCell *)[tableView dequeueReusableCellWithIdentifier:@"orderFootCell"];
        cell_orderfoot.backgroundColor = [UIColor whiteColor];
        cell_orderfoot.selectionStyle = UITableViewCellSelectionStyleNone;
        cell_orderfoot.amountPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        return cell_orderfoot;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
        titleLabel.text = @"订单信息";
        titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:titleLabel];
        
        return view;
    }else if (section == 2){
        if ([orderDataDic[@"couponHave"]count] > 0) {
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 30)];
            view.backgroundColor = [UIColor whiteColor];
            [backView addSubview:view];
            
            UILabel *useCouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
            useCouponLabel.textAlignment = NSTextAlignmentLeft;
            useCouponLabel.text = @"使用优惠券";
            useCouponLabel.font = [UIFont fontWithName:@"Arial" size:12];
            useCouponLabel.textColor = [UIColor darkGrayColor];
            [view addSubview:useCouponLabel];
            
            isUseBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 30, 30)];
            [isUseBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
            [isUseBtn addTarget:self action:@selector(isUseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:isUseBtn];
            
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29, [UIScreen mainScreen].bounds.size.width, 1)];
            lineImage.image = [UIImage imageNamed:@"grayLine"];
            lineImage.alpha = 0.7;
            [view addSubview:lineImage];
            return backView;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        lineImage.image = [UIImage imageNamed:@"grayLine"];
        lineImage.alpha = 0.7;
        [view addSubview:lineImage];
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 15, 20)];
        totalLabel.text = @"共";
        totalLabel.textAlignment = NSTextAlignmentCenter;
        totalLabel.font = [UIFont fontWithName:@"Arial" size:12];
        totalLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:totalLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 20, 20)];
        numberLabel.text = orderDataDic[@"totalCount"];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont fontWithName:@"Arial" size:12];
        numberLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        [view addSubview:numberLabel];
        
        UILabel *jianLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 15, 20)];
        jianLabel.text = @"件";
        jianLabel.font = [UIFont fontWithName:@"Arial" size:12];
        jianLabel.textAlignment = NSTextAlignmentCenter;
        jianLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:jianLabel];
        
        //商品金额
        UILabel *jineLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 5, 70, 20)];
        jineLabel.text = @"商品金额:";
        jineLabel.textAlignment = NSTextAlignmentRight;
        jineLabel.font = [UIFont fontWithName:@"Arial" size:12];
        jineLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:jineLabel];
        
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 5, 70, 20)];
        payLabel.text = [NSString stringWithFormat:@"￥%@",orderDataDic[@"payValue"]];
        payLabel.textAlignment = NSTextAlignmentLeft;
        payLabel.font = [UIFont fontWithName:@"Arial" size:12];
        payLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        [view addSubview:payLabel];
        
        
        return view;
    }else if (section == 3) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        UIButton *surePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        surePayBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        surePayBtn.layer.cornerRadius = 3;
        [surePayBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [surePayBtn addTarget:self action:@selector(surePayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:surePayBtn];
        return view;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    if (indexPath.section == 1) {
        OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
        orderDetail.orderId = orderDataDic[@"priductLists"][indexPath.row][@"productId"];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    
}

#pragma mark - Method
#pragma mark 是否需要发票按钮方法
-(void)isNeedInvoiceBtnAction:(UIButton *)btn{
    HeadForOrderCell *cell = (HeadForOrderCell *)[orderSureTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.isNeedInvoiceBtn.selected = !cell.isNeedInvoiceBtn.selected;
    if (cell.isNeedInvoiceBtn.selected == YES) {
        [cell.isNeedInvoiceBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        cell.invoiceLabel.hidden = NO;
        cell.invoiceView.hidden = NO;
        isNeedInovice = @"true";
    }else if (cell.isNeedInvoiceBtn.selected == YES) {
        [cell.isNeedInvoiceBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        cell.invoiceLabel.hidden = YES;
        cell.invoiceView.hidden = YES;
        isNeedInovice = @"false";
    }
}

#pragma mark 元按钮方法
-(void)yuanBtnAction:(UIButton *)btn{
    NSLog(@"点击元按钮");

    for (int i = 300; i < 300+[orderDataDic[@"couponHave"]count]; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        if (btn.tag == i ) {
            button.selected = !button.selected;
            if (button.selected == YES) {
                [button setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
                yuanNumber = orderDataDic[@"couponHave"][btn.tag-300][@"coupon"];
            }else if (button.selected == NO) {
                [button setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
                yuanNumber = @"";
            }
        }else{
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        }
    }
}


#pragma mark 箭头按钮方法
-(void)toAddressDetail:(UIButton *)btn{
    NSLog(@"点击箭头按钮");
    MyAddressViewController *myAddress = [[MyAddressViewController alloc] init];
    [self.navigationController pushViewController:myAddress animated:YES];
}

#pragma mark 使用优惠券按钮方法
-(void)isUseBtnAction:(UIButton *)btn{
    NSLog(@"点击使用优惠券按钮");
    isUseBtn.selected = !isUseBtn.selected;
    if (isUseBtn.selected == YES) {
        [isUseBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else if (isUseBtn.selected == NO){
        [isUseBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
}

#pragma mark 在线支付按钮方法
-(void)onlinePayBtnAction:(UIButton *)btn{
    NSLog(@"点击在线支付按钮");
    HeadForOrderCell *cell_head = (HeadForOrderCell *)[orderSureTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell_head.onlinePayBtn.selected = !cell_head.onlinePayBtn.selected;
    if (cell_head.onlinePayBtn.selected == YES) {
        [cell_head.onlinePayBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
        [cell_head.reciverPayBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        isOnlinepay = @"true";
        flag = 1;
    }else if (cell_head.onlinePayBtn.selected == NO){
        [cell_head.onlinePayBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        flag = 0;
    }
}

#pragma mark 货到付款按钮方法
-(void)reciverPayBtnAction:(UIButton *)btn{
    NSLog(@"点击货到付款按钮");
    HeadForOrderCell *cell_head = (HeadForOrderCell *)[orderSureTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell_head.reciverPayBtn.selected = !cell_head.reciverPayBtn.selected;
    if (cell_head.reciverPayBtn.selected == YES) {
        [cell_head.reciverPayBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
        [cell_head.onlinePayBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        isOnlinepay = @"false";
        flag = 2;
    }else if (cell_head.reciverPayBtn.selected == NO){
        [cell_head.reciverPayBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        flag = 0;
    }
}

#pragma mark 地址手势跳转方法
-(void)addressDetail:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到地址详细页面");
    MyAddressViewController *myAddress = [[MyAddressViewController alloc] init];
    [self.navigationController pushViewController:myAddress animated:YES];
}

#pragma mark 提交订单按钮方法
-(void)surePayBtnAction:(UIButton *)btn{
    NSLog(@"点击提交订单按钮");

    if (flag != 0 && [orderDataDic[@"addressOrderId"]length] > 0) {
        [self requestInputOrder];
    }else if (flag == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一种支付方式！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if ([orderDataDic[@"addressOrderId"]length] == 0){
        NSLog(@"收货地址不能为空");
    }
}

#pragma mark 结算请求
-(void)requestInputOrder{
    HeadForOrderCell *cell_head = (HeadForOrderCell *)[orderSureTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *remarkTxt = cell_head.remarkTextView.text;
    if (remarkTxt == nil) {
        remarkTxt = @"";
    }
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/submitOrder"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSLog(@"isOnlinepay >> %@",isOnlinepay);
    NSLog(@"isNeedInovice >> %@",isNeedInovice);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"addressOrderId":orderDataDic[@"addressOrderId"],@"isOnlinePay":isOnlinepay,@"isNeedInvoice":isNeedInovice,@"invoiceMsg":@"ddd",@"orderRemark":remarkTxt,@"couponType":yuanNumber};
    NSLog(@"parameters======%@",parameters);
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
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                orderDataDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                [orderSureTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (flag == 1){
                    NSLog(@"跳转到提交订单页面");
                    NSMutableArray *orderIds = [NSMutableArray array];
                    for (NSDictionary *dict in object[@"info"][@"orderLists"]) {
                        NSDictionary *tempDic = @{@"orderId":dict[@"orderId"]};
                        [orderIds addObject:tempDic];
                    }
                    MakeSureViewController *makesurePay = [[MakeSureViewController alloc] init];
                    makesurePay.orderNumber = orderIds;
                    [self.navigationController pushViewController:makesurePay animated:YES];
                }else if (flag == 2){
                    NSLog(@"跳转到订单完成页面");
                    OrderFinishedViewController *orderFinished = [[OrderFinishedViewController alloc] init];
                    [self.navigationController pushViewController:orderFinished animated:YES];
                }
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}


@end
