//
//  AllOrderViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AllOrderViewController.h"
#import "HMSegmentedControl.h"
#import "UnFinishedOrderCell.h"
#import "FinishedOrderCell.h"
#import "EvaluteViewController.h"
#import "RootTabBarController.h"
#import "OrderDetailViewController.h"
#import "CheckLogisticsViewController.h"
#import "MakeSureViewController.h"

@interface AllOrderViewController ()
{
    HMSegmentedControl *segmentedControl1;
    UITableView *unFinishedOrderTable;
    UITableView *finishedOrderTable;
    NSArray *fakeDataArr;
    NSString *accesstoken;
    int currentFinishedpage;
    int currentUnfinishedpage;
    int pageRows;
    NSMutableArray *unFinishedArr;
    NSMutableArray *finishedArr;
    int cancleId;
    UIView *grayView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation AllOrderViewController

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
    
    self.title = @"全部订单";
    
    [self creatKongUI];
    
    //请求常量
    pageRows = 10;
    currentFinishedpage = 1;
    currentUnfinishedpage = 1;

    
    
    //带scrollow的segmentControl
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"未完成订单", @"已完成订单"]];
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
    }];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, 320, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    //分隔线
    UIImageView *LineImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 11, 1, 15)];
    LineImage.image = [UIImage imageNamed:@"grayLine（vertical ）"];
    [segmentedControl1 addSubview:LineImage];
    
    
    
    
    __weak typeof(self) weakSelf = self;
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width * index, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) animated:YES];
    }];
    
    [self.view addSubview:segmentedControl1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    self.scrollView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height-40);
    self.scrollView.delegate = self;

    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) animated:NO];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = self.scrollView.contentOffset.x / pageWidth;
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
    [self.view addSubview:self.scrollView];
    
    //未完成订单
    unFinishedOrderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    unFinishedOrderTable.delegate = self;
    unFinishedOrderTable.dataSource = self;
    unFinishedOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    unFinishedOrderTable.tag = 300;
    unFinishedOrderTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:unFinishedOrderTable];

    //已完成订单
    finishedOrderTable = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    finishedOrderTable.delegate = self;
    finishedOrderTable.dataSource = self;
    finishedOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    finishedOrderTable.tag = 301;
    finishedOrderTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:finishedOrderTable];
    
    
    //注册XIB
    [unFinishedOrderTable registerNib:[UINib nibWithNibName:@"UnFinishedOrderCell" bundle:nil] forCellReuseIdentifier:@"unfinishedorder"];
    [finishedOrderTable registerNib:[UINib nibWithNibName:@"FinishedOrderCell" bundle:nil] forCellReuseIdentifier:@"finishedOrder"];
    


    
    [self judge];
}





#pragma mark 已完成订单请求
-(void)requestFinishedOrderData{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllOrderFinished"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentFinishedpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}

#pragma mark 未完成订单请求
-(void)requestUnFinishedOrderData{
    
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllOrderUnFinish"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentUnfinishedpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        
        [self requestUnFinishedOrderData];
        [self requestFinishedOrderData];
    }
}

#pragma mark segmentedControlMehtod
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //判断scrollow是否是当前的scrollow
    if (self.scrollView == scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
    }
    
}

#pragma mark TableView_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 300:
        {
            return unFinishedArr.count;
        }
            break;
        case 301:
        {
            return finishedArr.count;
        }
            break;
        default:
            break;
    }
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 300:
        {
            if ([unFinishedArr[indexPath.section][@"orderState"]intValue] == 1) {
                return 130;
            }
            return 170;
        }
            break;
        case 301:
        {
            if ([finishedArr[indexPath.section][@"orderState"]intValue] == 5) {
                return 130;
            }
            return 170;
        }
            break;
        default:
            break;
    }
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
        {
            if (section == unFinishedArr.count-1) {
                return 40;
            }
            return 5;
        }
            break;
        case 301:
        {
            if (section == finishedArr.count-1) {
                return 40;
            }
            return 5;
        }
            break;
        default:
            break;
    }
    return 0;
}



/*
 未完成订单cell有三种状态：
 1.等待付款（包含两个按钮：取消订单（白色）、立即支付（橙红）） ||orderState = 0；
 2.已付款,已发货（包含两个按钮：查看物流（蓝色）、确认收货（蓝色））||orderState = 2；
 3.已付款,待发货（不包含按钮）|orderState = 1；
 
 已完成订单cell有三种状态：
 1.已签收,待评论（包含两个按钮：评价（白色）、再次购买（蓝色））||orderType  = 3；
 2.已签收,已评论（包含一个按钮：再次购买（蓝色））||orderType = 4；
 3.活动订单（不包含按钮）标号：|orderType = 5;
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 300:
        {
            UnFinishedOrderCell *cell_unfinished = (UnFinishedOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"unfinishedorder"];
            [cell_unfinished.arrowBtn addTarget:self action:@selector(ToDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell_unfinished.orderPrice.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
            cell_unfinished.orderAmount.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
           
            //赋值
            if (unFinishedArr.count > 0) {
                cell_unfinished.orderPrice.text = unFinishedArr[indexPath.section][@"orderPrice"];
                cell_unfinished.orderAmount.text = unFinishedArr[indexPath.section][@"totalNumber"];
                cell_unfinished.orderNumber.text = unFinishedArr[indexPath.section][@"orderId"];
                cell_unfinished.orderTime.text = unFinishedArr[indexPath.section][@"orderTime"];
                [cell_unfinished.productImage loadImageFromURLString:unFinishedArr[indexPath.section][@"productPic"]];
            }
            
            
  
            //订单状态
            if ([unFinishedArr[indexPath.section][@"orderType"]intValue] == 0) {
                //取消订单按钮
                [cell_unfinished.orderLeftBtn setImage:[UIImage imageNamed:@"whiteBtn_short（cricle）"] forState:UIControlStateNormal];
                cell_unfinished.leftLabel.text = @"取消订单";
                cell_unfinished.orderLeftBtn.tag = 600+indexPath.section;
                cell_unfinished.leftLabel.textColor = [UIColor darkTextColor];
                cell_unfinished.leftLabel.textAlignment = NSTextAlignmentCenter;
                cell_unfinished.leftLabel.font = [UIFont fontWithName:@"Arial" size:10];
                [cell_unfinished.orderLeftBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                //立即支付按钮
                [cell_unfinished.orderRightBtn setImage:[UIImage imageNamed:@"redBtn_short（circle）"] forState:UIControlStateNormal];
                cell_unfinished.rightLabel.text = @"立即支付";
                cell_unfinished.orderRightBtn.tag = 700+indexPath.section;
                cell_unfinished.rightLabel.textColor = [UIColor whiteColor];
                cell_unfinished.rightLabel.textAlignment = NSTextAlignmentCenter;
                cell_unfinished.rightLabel.font = [UIFont fontWithName:@"Arial" size:10];
                [cell_unfinished.orderRightBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                cell_unfinished.orderState.text = unFinishedArr[indexPath.section][@"orderState"];
                
            }else if ([unFinishedArr[indexPath.section][@"orderType"]intValue] == 2){
                //查看物流按钮
                [cell_unfinished.orderLeftBtn setImage:[UIImage imageNamed:@"blueBtn_short"] forState:UIControlStateNormal];
                cell_unfinished.leftLabel.text = @"查看物流";
                cell_unfinished.leftLabel.textColor = [UIColor whiteColor];
                cell_unfinished.leftLabel.textAlignment = NSTextAlignmentCenter;
                cell_unfinished.leftLabel.font = [UIFont fontWithName:@"Arial" size:10];
                [cell_unfinished.orderLeftBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
                cell_unfinished.orderLeftBtn.tag = 100+indexPath.section;
                //确认收货按钮
                [cell_unfinished.orderRightBtn setImage:[UIImage imageNamed:@"blueBtn_short"] forState:UIControlStateNormal];
                cell_unfinished.rightLabel.text = @"确认收货";
                cell_unfinished.rightLabel.textColor = [UIColor whiteColor];
                cell_unfinished.rightLabel.textAlignment = NSTextAlignmentCenter;
                cell_unfinished.rightLabel.font = [UIFont fontWithName:@"Arial" size:10];
                [cell_unfinished.orderRightBtn addTarget:self action:@selector(sureReciveOrder:) forControlEvents:UIControlEventTouchUpInside];
                cell_unfinished.orderState.text = unFinishedArr[indexPath.section][@"orderState"];
                cell_unfinished.orderRightBtn.tag = 200+indexPath.section;
            }else if ([unFinishedArr[indexPath.section][@"orderType"]intValue] == 1){
                cell_unfinished.orderRightBtn.hidden = YES;
                cell_unfinished.orderLeftBtn.hidden = YES;
                cell_unfinished.bottomLine.hidden = YES;
                cell_unfinished.rightLabel.hidden = YES;
                cell_unfinished.leftLabel.hidden = YES;
                cell_unfinished.orderState.text = unFinishedArr[indexPath.section][@"orderState"];
            }
             return cell_unfinished;
         }
            break;
        case 301:
        {
            FinishedOrderCell *cell_finished = (FinishedOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"finishedOrder"];
            [cell_finished.arrowBtn addTarget:self action:@selector(ToDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell_finished.flagLabel.hidden = YES;
            cell_finished.orderPrice.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
            cell_finished.orderAmount.textColor = [UIColor jk_colorWithHexString:@"#FF6A6A"];
            if ([finishedArr[indexPath.section][@"orderType"]intValue] == 5) {
                cell_finished.whiteBtn.hidden = YES;
                cell_finished.whiteBtnLabel.hidden = YES;
                cell_finished.blueBtn.hidden = YES;
                cell_finished.blueBtnLabel.hidden = YES;
                cell_finished.orderState.text = finishedArr[indexPath.section][@"orderState"];
            }else if ([finishedArr[indexPath.section][@"orderType"]intValue] == 4){
                //评价按钮
                cell_finished.whiteBtn.tag = 900+indexPath.section;
                [cell_finished.whiteBtn addTarget:self action:@selector(evaluteOrder:) forControlEvents:UIControlEventTouchUpInside];
                //再次购买按钮
                [cell_finished.blueBtn addTarget:self action:@selector(reBuy:) forControlEvents:UIControlEventTouchUpInside];
                cell_finished.blueBtn.tag = 800+indexPath.section;
                cell_finished.orderState.text = finishedArr[indexPath.section][@"orderState"];
            }else if ([finishedArr[indexPath.section][@"orderType"]intValue] == 3){
                cell_finished.whiteBtn.hidden = YES;
                cell_finished.whiteBtnLabel.hidden = YES;
                cell_finished.flagLabel.hidden = NO;
                //再次购买按钮
                [cell_finished.blueBtn addTarget:self action:@selector(evaluteOrder:) forControlEvents:UIControlEventTouchUpInside];
                cell_finished.blueBtn.tag = 800+indexPath.section;
                cell_finished.orderState.text = finishedArr[indexPath.section][@"orderState"];
            }
            //赋值
            if (finishedArr.count > 0) {
                cell_finished.orderPrice.text = finishedArr[indexPath.section][@"orderPrice"];
                cell_finished.orderAmount.text = finishedArr[indexPath.section][@"totalNumber"];
                cell_finished.orderNumber.text = finishedArr[indexPath.section][@"orderId"];
                cell_finished.orderTime.text = finishedArr[indexPath.section][@"orderTime"];
                [cell_finished.productImage loadImageFromURLString:finishedArr[indexPath.section][@"productPic"]];
            }
            return cell_finished;
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
        {
            if (section == unFinishedArr.count-1) {
                UIView *viewForMore = [[UIView alloc] init];
                UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 5, 100, 30)];
                moreBtn.tag = 400;
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [moreBtn addTarget:self action:@selector(reloadMore:) forControlEvents:UIControlEventTouchUpInside];
                moreBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                [viewForMore addSubview:moreBtn];
                return viewForMore;
            }

        }
            break;
        case 301:
        {
            if (section == finishedArr.count-1) {
                UIView *viewForMore = [[UIView alloc] init];
                UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 5, 100, 30)];
                moreBtn.tag = 500;
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [moreBtn addTarget:self action:@selector(reloadMore:) forControlEvents:UIControlEventTouchUpInside];
                moreBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                [viewForMore addSubview:moreBtn];
                return viewForMore;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    switch (tableView.tag) {
        case 300:
            orderDetail.orderId = unFinishedArr[indexPath.section][@"orderId"];
            break;
        case 301:
            orderDetail.orderId = finishedArr[indexPath.section][@"orderId"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:orderDetail animated:YES];
}


#pragma mark - Method
#pragma mark 加载更多方法
-(void)reloadMore:(UIButton *)btn{
    NSLog(@"加载更多数据");
    switch (btn.tag) {
        case 400:
        {
            NSLog(@"未完成订单加载更多");
            [self requestUnFinishedOrderData];
        }
            break;
        case 500:
        {
            NSLog(@"已完成订单加载更多");
            [self requestFinishedOrderData];
        }
            break;
        default:
            break;
    }
}



#pragma mark 取消订单按钮方法
-(void)cancelOrder:(UIButton *)btn{
    NSLog(@"取消订单%ld",btn.tag-600);
    cancleId = (int)btn.tag-600;
    [self requestCancleOrderData:unFinishedArr[btn.tag-600][@"orderId"]];
}


#pragma mark 取消订单请求
-(void)requestCancleOrderData:(NSString *)orderId{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/deleteOrder"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderId":orderId};
    NSLog(@"orderId===%@,accesstoken===%@",orderId,accesstoken);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}


#pragma mark 立即支付按钮方法
-(void)payOrder:(UIButton *)btn{
    NSLog(@"立即支付");
    MakeSureViewController *makeSure = [[MakeSureViewController alloc] init];
    makeSure.orderNumber = unFinishedArr[btn.tag - 700][@"orderId"];
    [self.navigationController pushViewController:makeSure animated:YES];
}

#pragma mark 查看物流按钮方法
-(void)checkOrder:(UIButton *)btn{
    NSLog(@"查看物流");
    CheckLogisticsViewController *checkLogistic = [[CheckLogisticsViewController alloc] init];
    checkLogistic.trackingNum = unFinishedArr[btn.tag-100][@"trackingNum"];
    [self.navigationController pushViewController:checkLogistic animated:YES];
}

#pragma mark 确认收货按钮方法
-(void)sureReciveOrder:(UIButton *)btn{
    NSLog(@"确认收货");
}



#pragma mark 箭头按钮方法
-(void)ToDetail:(UIButton *)btn{
    NSLog(@"点击箭头按钮");
}

#pragma mark 评价按钮方法
-(void)evaluteOrder:(UIButton *)btn{
    NSLog(@"评价按钮");
    EvaluteViewController *evalute = [[EvaluteViewController alloc] init];
    evalute.productID = finishedArr[btn.tag-900][@"orderId"];
    [self.navigationController pushViewController:evalute animated:YES];
}

#pragma mark 再次购买按钮方法
-(void)reBuy:(UIButton *)btn{
    NSLog(@"再次购买按钮%d",(int)btn.tag-800);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)judge{
    if (unFinishedArr.count == 0 && finishedArr.count == 0) {
        grayView.hidden = NO;
        segmentedControl1.hidden = YES;
        self.scrollView.hidden = YES;
    }else if (unFinishedArr.count > 0 || finishedArr.count > 0){
        grayView.hidden = YES;
        segmentedControl1.hidden = NO;
        self.scrollView.hidden = NO;
    }
}


#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class==finished=%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]){
                if (finishedArr == nil) {
                    finishedArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                }else{
                    if ([object[@"info"][@"orderLists"]count] > 0) {
                        [finishedArr addObjectsFromArray:object[@"info"][@"orderLists"]];
                    }else{
                        [self showToast:@"没有更多的数据可以加载"];
                    }
                }
                [finishedOrderTable reloadData];
                currentFinishedpage++;
                [self judge];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,self.class==unfinished=%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                if (unFinishedArr == nil) {
                    unFinishedArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"orderLists"]];
                }else{
                    if ([object[@"info"][@"orderLists"]count] > 0) {
                        [unFinishedArr addObjectsFromArray:object[@"info"][@"orderLists"]];
                    }else{
                        [self showToast:@"没有更多的数据可以加载"];
                    }
                }
                [unFinishedOrderTable reloadData];
                currentUnfinishedpage++;
                [self judge];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,msg==unfinished=%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                NSLog(@"cancleId===%d,unFinishedArr===%@",cancleId,unFinishedArr);
                [unFinishedArr removeObjectAtIndex:cancleId];
                [unFinishedOrderTable reloadData];
                [self judge];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
