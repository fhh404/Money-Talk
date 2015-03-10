//
//  EvaluteViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "EvaluteViewController.h"
#import "EvaluteCell.h"

#import "RootTabBarController.h"
#import "OrderDetailViewController.h"
#import "CustomLabel.h"
#import "MarkupParser.h"
#import "AllOrderViewController.h"
#import "WaitForEvaluteViewController.h"
//动画时间
#define kAnimationDuration 0.2
@interface EvaluteViewController ()
{
    UIToolbar * topView;
    NSString *integrateNum;
    NSTimer *timer;
    int flag;
    UIView *grayBackView;
    NSString *accesstoken;
    float stars;
    NSMutableArray *orderInfoArr;
    NSMutableArray *starsArr;
    NSMutableArray *evaluatesArr;
    NSString *couponNum;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)evaluteBtn:(UIButton *)sender;



@end

@implementation EvaluteViewController
@synthesize productID;
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
    
    self.title = @"商品评价";
    
    //评价table
    _evaluteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-50) style:UITableViewStylePlain];
    _evaluteTable.delegate = self;
    _evaluteTable.dataSource = self;
    _evaluteTable.tag = 2000;
    _evaluteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _evaluteTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:_evaluteTable];
    
    //注册XIB
    [_evaluteTable registerNib:[UINib nibWithNibName:@"EvaluteCell" bundle:nil] forCellReuseIdentifier:@"evaluteProduct"];
    
    
    //给键盘添加收回按钮
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    
    starsArr = [[NSMutableArray alloc] init];
    evaluatesArr = [[NSMutableArray alloc] init];
    
}


#pragma mark 订单信息请求
-(void)requestEvaluteOrderInfo{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getOrderInfo"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"orderId":self.productID};
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
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    stars = 0.0;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken.length > 0) {
        [self requestEvaluteOrderInfo];
    }
}


// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    //调整放置有输入框的view的位置
    if ([cell.EvaluteTextView isFirstResponder]) {
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        UITableView *table =  (UITableView *)[self.view viewWithTag:2000];
        table.contentOffset = CGPointMake(0, 2*280);

        [UIView commitAnimations];
    }
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    UITableView *table =  (UITableView *)[self.view viewWithTag:2000];
    table.contentOffset = CGPointMake(0, 2*280-320);
    [UIView commitAnimations];
}

-(void)dismissKeyBoard{
    for (int i = 0; i < 3; i++) {
        EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.EvaluteTextView resignFirstResponder];
        _evaluteFrameVIew.hidden = NO;
    }
}

#pragma mark - evaluteTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderInfoArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluteCell *cell = (EvaluteCell *)[tableView dequeueReusableCellWithIdentifier:@"evaluteProduct"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [cell.firstStarBtn addTarget:self action:@selector(starBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.secondStarBtn addTarget:self action:@selector(starBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
    [cell.thirdStarBtn addTarget:self action:@selector(starBtnAction3:) forControlEvents:UIControlEventTouchUpInside];
    [cell.fourthStarBtn addTarget:self action:@selector(starBtnAction4:) forControlEvents:UIControlEventTouchUpInside];
    [cell.fifthStarBtn addTarget:self action:@selector(starBtnAction5:) forControlEvents:UIControlEventTouchUpInside];
    cell.EvaluteTextView.inputAccessoryView = topView;
    cell.EvaluteTextView.tag = 1000 + indexPath.row;
    cell.firstStarBtn.tag = indexPath.row + 100;
    cell.secondStarBtn.tag = indexPath.row + 200;
    cell.thirdStarBtn.tag = indexPath.row + 300;
    cell.fourthStarBtn.tag = indexPath.row + 400;
    cell.fifthStarBtn.tag = indexPath.row + 500;
    
    if (orderInfoArr.count > 0) {
        cell.productName.text = orderInfoArr[indexPath.row][@"productName"];
        [cell.productImage loadImageFromURL:[NSURL URLWithString:orderInfoArr[indexPath.row][@"productPic"]]];
        cell.productAmount.text = [NSString stringWithFormat:@"%@袋",orderInfoArr[indexPath.row][@"productSize"]];
    }
    //赋值
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = orderInfoArr[indexPath.row][@"productId"];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark - Method
#pragma mark 第一颗评价五角星按钮
-(void)starBtnAction1:(UIButton *)btn{
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-100 inSection:0]];
    [cell.firstStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.secondStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.thirdStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.fourthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.fifthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    stars = 1.0;
    [self getStars:(int)btn.tag-100];
}

#pragma mark 第二颗评价五角星按钮
-(void)starBtnAction2:(UIButton *)btn{
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-200 inSection:0]];
    [cell.firstStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.secondStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.thirdStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.fourthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.fifthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    stars = 2.0;
    [self getStars:(int)btn.tag-200];
}

#pragma mark 第三颗评价五角星按钮
-(void)starBtnAction3:(UIButton *)btn{
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-300 inSection:0]];
    [cell.firstStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.secondStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.thirdStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.fourthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    [cell.fifthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    stars = 3.0;
    [self getStars:(int)btn.tag-300];
}

#pragma mark 第四颗评价五角星按钮
-(void)starBtnAction4:(UIButton *)btn{
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-400 inSection:0]];
    [cell.firstStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.secondStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.thirdStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.fourthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.fifthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree（undid）"] forState:UIControlStateNormal];
    stars = 4.0;
    [self getStars:(int)btn.tag-400];
}

#pragma mark 第五颗评价五角星按钮
-(void)starBtnAction5:(UIButton *)btn{
    EvaluteCell *cell = (EvaluteCell *)[_evaluteTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-500 inSection:0]];
    [cell.firstStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.secondStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.thirdStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.fourthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    [cell.fifthStarBtn setImage:[UIImage imageNamed:@"evaluteDegree"] forState:UIControlStateNormal];
    stars = 5.0;
    [self getStars:(int)btn.tag-500];
}


-(void)getStars:(int)tagFlag{
    NSLog(@"starsArr===%@",starsArr);
    [starsArr replaceObjectAtIndex:tagFlag withObject:[NSString stringWithFormat:@"%.f",stars]];
}

-(void)getParameters{
    for (int i = 0; i < starsArr.count; i++) {
        UITextView *textView = (UITextView *)[self.view viewWithTag:1000+i];
        NSDictionary *dict;
        if ([starsArr[i] intValue] > 0) {
            dict = @{@"productId":orderInfoArr[i][@"productId"],@"star":starsArr[i],@"evaluate":textView.text};
            [evaluatesArr addObject:dict];
        }
    }
}


#pragma mark 评价按钮方法
- (IBAction)evaluteBtn:(UIButton *)sender {
    NSLog(@"评价");
    if (stars > 0.0) {
        [self getParameters];
        [self requestOrderEvaluate];
    }else{
        NSLog(@"评分不能为0");
    }
}


#pragma mark 评价订单请求
-(void)requestOrderEvaluate{
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/orderEvaluate"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //数组转换为字符串
    NSString *jsonString = [JKJsonHelper toJsonString:evaluatesArr];
    NSLog(@"str=====%@",jsonString);
    
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"evaluates":jsonString};
    NSLog(@"parameters====%@",parameters);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}


-(void)initUISuccessEvalute{
    grayBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayBackView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.75];
    [self.view addSubview:grayBackView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 160)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    [grayBackView addSubview:whiteView];
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 220, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Arial" size:14];
    label.text = [NSString stringWithFormat:@"评论成功！恭喜您获得%@积分!",couponNum];
    [whiteView addSubview:label];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 100, 15)];
    tipsLabel.font = [UIFont fontWithName:@"Arial" size:11];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.text = @"3秒后自动为您跳转";
    [whiteView addSubview:tipsLabel];
    
    UIButton *rightNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 100, 120, 40)];
    rightNowBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [rightNowBtn setTitle:@"立即跳转" forState:UIControlStateNormal];
    [rightNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNowBtn addTarget:self action:@selector(rightNowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:rightNowBtn];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    flag = 0;
    [timer fire];
}



-(void)timerAction{
    if (flag == 3) {
        [grayBackView removeFromSuperview];
        [self rightNowBtnAction];
        [timer invalidate];
    }
    flag++;
}


-(void)rightNowBtnAction{
    BOOL isLastEvalute = YES;
    if (isLastEvalute == YES) {
        AllOrderViewController *allorder = (AllOrderViewController *)self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:allorder animated:YES];
    }else{
        WaitForEvaluteViewController *waitForEvalute = (WaitForEvaluteViewController *)self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:waitForEvalute animated:YES];
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
        } else {
            NSLog(@"%@,msg==finished=%@", object,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                orderInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"]];
                [starsArr removeAllObjects];
                for (int i = 0; i < orderInfoArr.count; i++) {
                    [starsArr addObject:@"0"];
                }
                [_evaluteTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,msg==finished=%@", object,object[@"msg"]);
            if ([object[@"result"] isEqualToNumber:@0]) {
                couponNum = [NSString stringWithFormat:@"%@",object[@"info"][@"coupon"]];
                [self initUISuccessEvalute];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}


@end
