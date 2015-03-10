//
//  MyIntegeralViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MyIntegeralViewController.h"
#import "RootTabBarController.h"
#import "HMSegmentedControl.h"
#import "IntegralCell.h"
#import "ObtainIntegralCell.h"
#import "ExpanseIntegralCell.h"
#import "IntegralSummary Cell.h"
#import "ObtainSummeryCell.h"
#import "ExpanseSummeryCell.h"
#import "IntegralIintroductionViewController.h"
#import "ExchangeIntegralViewController.h"
@interface MyIntegeralViewController ()
{
    HMSegmentedControl *segmentedControl1;
    UITableView *allIntegralTable;
    UITableView *obtainIntegralTable;
    UITableView *expenseIntegralTable;
    NSString *accesstoken;
    int currentpage;
    int obtainCurrentpage;
    int expanseCurrentpage;
    int pageRows;
    NSMutableArray *allInfoArr;
    NSMutableDictionary *allDic;
    NSMutableArray *obtainInfoArr;
    NSMutableDictionary *obtainDic;
    NSMutableArray *expanseInfoArr;
    NSMutableDictionary *expanseDic;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;


@end

@implementation MyIntegeralViewController

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
    self.title = @"我的积分";
    
    //带scrollow的segmentControl
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"获得",@"支出"]];
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
    }];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    //分隔线
    for (int i = 0; i < 2; i++) {
        UIImageView *LineImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*(i+1)/3, 11, 1, 15)];
        LineImage.image = [UIImage imageNamed:@"grayLine（vertical ）"];
        [segmentedControl1 addSubview:LineImage];
    }
    
      __weak typeof(self) weakSelf = self;
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width * index, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) animated:YES];
    }];
    
    [self.view addSubview:segmentedControl1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    self.scrollView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, [UIScreen mainScreen].bounds.size.height-120);
    self.scrollView.delegate = self;
    
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) animated:NO];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = self.scrollView.contentOffset.x / pageWidth;
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
    
    [self.view addSubview:self.scrollView];
    
    //全部
    allIntegralTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    allIntegralTable.delegate = self;
    allIntegralTable.dataSource = self;
    allIntegralTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    allIntegralTable.tag = 300;
    allIntegralTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:allIntegralTable];
    
    //获得
    obtainIntegralTable = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    obtainIntegralTable.delegate = self;
    obtainIntegralTable.dataSource = self;
    obtainIntegralTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    obtainIntegralTable.tag = 301;
    obtainIntegralTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:obtainIntegralTable];
    
    
    //支出
    expenseIntegralTable = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    expenseIntegralTable.delegate = self;
    expenseIntegralTable.dataSource = self;
    expenseIntegralTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    expenseIntegralTable.tag = 302;
    expenseIntegralTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:expenseIntegralTable];
    
    //注册XIB
    [allIntegralTable registerNib:[UINib nibWithNibName:@"IntegralCell" bundle:nil] forCellReuseIdentifier:@"allIntegral"];
    [obtainIntegralTable registerNib:[UINib nibWithNibName:@"ObtainIntegralCell" bundle:nil] forCellReuseIdentifier:@"obtainIntegral"];
    [expenseIntegralTable registerNib:[UINib nibWithNibName:@"ExpanseIntegralCell" bundle:nil] forCellReuseIdentifier:@"expanseIntegral"];
    
    [allIntegralTable registerNib:[UINib nibWithNibName:@"IntegralSummary Cell" bundle:nil] forCellReuseIdentifier:@"allSummery"];
    [obtainIntegralTable registerNib:[UINib nibWithNibName:@"ObtainSummeryCell" bundle:nil] forCellReuseIdentifier:@"obtainSummery"];
    [expenseIntegralTable registerNib:[UINib nibWithNibName:@"ExpanseSummeryCell" bundle:nil] forCellReuseIdentifier:@"expanseSummery"];

}

#pragma mark 全部积分请求
-(void)requestAllIntegratedInfoData{
    [[Loading shareLoading] beginLoading];
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllMyIngetrals"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}

#pragma mark 获得积分请求
-(void)requestObtainIntegratedInfoData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",obtainCurrentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllMyIngetralsGet"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}

#pragma mark 支出积分请求
-(void)requestExpanseIntegratedInfoData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",expanseCurrentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getAllMyIngetralsPay"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];

    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    currentpage = 1;
    obtainCurrentpage = 1;
    expanseCurrentpage = 1;
    pageRows = 10;
    if (accesstoken.length > 0) {
        [self requestAllIntegratedInfoData];
        [self requestObtainIntegratedInfoData];
        [self requestExpanseIntegratedInfoData];
    }
}


#pragma mark segmentedControlMehtod
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
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
    switch (tableView.tag) {
        case 300:
        {
            if (section == 0) {
                return 1;
            }
            return allInfoArr.count;
        }
            break;
        case 301:
        {
            if (section == 0) {
                return 1;
            }
            return obtainInfoArr.count;
        }
            break;
        case 302:
        {
            if (section == 0) {
                return 1;
            }
            return expanseInfoArr.count;
        }
            break;
   
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    IntegralCell *cell_integral = (IntegralCell *)[tableView dequeueReusableCellWithIdentifier:@"allIntegral"];
    ObtainIntegralCell *cell_obtain = (ObtainIntegralCell *)[tableView dequeueReusableCellWithIdentifier:@"obtainIntegral"];
    ExpanseIntegralCell *cell_expanse = (ExpanseIntegralCell *)[tableView dequeueReusableCellWithIdentifier:@"expanseIntegral"];
    
    IntegralSummary_Cell *cell_allSummery = (IntegralSummary_Cell *)[tableView dequeueReusableCellWithIdentifier:@"allSummery"];
    ObtainSummeryCell *cell_obtainSummery = (ObtainSummeryCell *)[tableView dequeueReusableCellWithIdentifier:@"obtainSummery"];
    ExpanseSummeryCell *cell_expanseSummery = (ExpanseSummeryCell *)[tableView dequeueReusableCellWithIdentifier:@"expanseSummery"];
    
    if (indexPath.section == 0) {
        switch (tableView.tag) {
            case 300:
            {
                cell_allSummery.allIntegralLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                cell_allSummery.useableIntegralLabel.textColor = [UIColor jk_colorWithHexString:@"#6fbd36"];
                cell_allSummery.checkIntegralIntroduction.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                cell_allSummery.checkIntegralIntroduction.userInteractionEnabled = YES;
                [cell_allSummery.checkIntegralIntroduction addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCheck:)]];
                
                BOOL isableToexchange = YES;
                if (isableToexchange == YES) {
                    cell_allSummery.tempLabel.hidden = YES;
                    cell_allSummery.integralExchangeCoupon.hidden = NO;
                    cell_allSummery.periodLabel.hidden = NO;
                    cell_allSummery.integralExchangeCoupon.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                    cell_allSummery.integralExchangeCoupon.userInteractionEnabled = YES;
                    [cell_allSummery.integralExchangeCoupon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeCoupon:)]];
                    
                }else if (isableToexchange == NO){
                    cell_allSummery.tempLabel.hidden = NO;
                    cell_allSummery.integralExchangeCoupon.hidden = YES;
                    cell_allSummery.periodLabel.hidden = YES;
                    
                }
                //设置cell为不响应状态
                cell_allSummery.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //赋值
                cell_allSummery.allIntegralLabel.text = allDic[@"totalIntegral"];
                cell_allSummery.useableIntegralLabel.text = allDic[@"canUseIntegral"];
                cell_allSummery.expensesIntegralLabel.text = [NSString stringWithFormat:@"%d",[allDic[@"readyUseIntegral"]intValue]];
                return cell_allSummery;
            }
                break;
            case 301:
            {
                cell_obtainSummery.allIntegral.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                cell_obtainSummery.useableIntegralLabel.textColor = [UIColor jk_colorWithHexString:@"#6fbd36"];
                cell_obtainSummery.checkLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                cell_obtainSummery.checkLabel.userInteractionEnabled = YES;
                [cell_obtainSummery.checkLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCheck:)]];
                BOOL isableToexchange = YES;
                if (isableToexchange == YES) {
                    cell_obtainSummery.tempLabel.hidden = YES;
                    cell_obtainSummery.integralForCoupon.hidden = NO;
                    cell_obtainSummery.periodLabel.hidden = NO;
                    cell_obtainSummery.integralForCoupon.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                    cell_obtainSummery.integralForCoupon.userInteractionEnabled = YES;
                    [cell_obtainSummery.integralForCoupon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeCoupon:)]];
                    
                }else if (isableToexchange == NO){
                    cell_obtainSummery.tempLabel.hidden = NO;
                    cell_obtainSummery.integralForCoupon.hidden = YES;
                    cell_obtainSummery.periodLabel.hidden = YES;
                }
                //设置cell为不响应状态
                cell_obtainSummery.selectionStyle = UITableViewCellSelectionStyleNone;
                //赋值
                cell_obtainSummery.allIntegral.text = obtainDic[@"totalIntegral"];
                cell_obtainSummery.useableIntegralLabel.text = obtainDic[@"canUseIntegral"];
                cell_obtainSummery.hasExpanseIntegral.text = [NSString stringWithFormat:@"%d",[obtainDic[@"readyUseIntegral"]intValue]];

                return cell_obtainSummery;
            }
                break;
            case 302:
            {
                cell_expanseSummery.allIntegral.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                cell_expanseSummery.usealbeIntegral.textColor = [UIColor jk_colorWithHexString:@"#6fbd36"];
                cell_expanseSummery.checkLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                cell_expanseSummery.checkLabel.userInteractionEnabled = YES;
                [cell_expanseSummery.checkLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCheck:)]];
                BOOL isableToexchange = YES;
                if (isableToexchange == YES) {
                    cell_expanseSummery.tempLabel.hidden = YES;
                    cell_expanseSummery.integralForCoupon.hidden = NO;
                    cell_expanseSummery.periodLabel.hidden = NO;
                    cell_expanseSummery.integralForCoupon.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                    cell_expanseSummery.integralForCoupon.userInteractionEnabled = YES;
                    [cell_expanseSummery.integralForCoupon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeCoupon:)]];
                    
                }else if (isableToexchange == NO){
                    cell_expanseSummery.tempLabel.hidden = NO;
                    cell_expanseSummery.integralForCoupon.hidden = YES;
                    cell_expanseSummery.periodLabel.hidden = YES;
                }
                //设置cell为不响应状态
                cell_expanseSummery.selectionStyle = UITableViewCellSelectionStyleNone;
                //赋值
                cell_expanseSummery.allIntegral.text = expanseDic[@"totalIntegral"];
                cell_expanseSummery.usealbeIntegral.text = expanseDic[@"canUseIntegral"];
                cell_expanseSummery.hasExpanseIntegral.text = [NSString stringWithFormat:@"%d",[expanseDic[@"readyUseIntegral"]intValue]];
                return cell_expanseSummery;
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
    switch (tableView.tag) {
        case 300:
        {
            //设置cell为不响应状态
            cell_integral.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //赋值
            if (allInfoArr.count > 0) {
                NSString *integralState;
                if ([allInfoArr[indexPath.row][@"isGet"]isEqualToString:@"true"]) {
                    integralState = [NSString stringWithFormat:@"+%@",allInfoArr[indexPath.row][@"intetralState"]];
                    cell_integral.AddAndSubtractLabel.textColor = [UIColor jk_colorWithHexString:@"#6fbd36"];
                }else{
                    integralState = [NSString stringWithFormat:@"-%@",allInfoArr[indexPath.row][@"intetralState"]];
                    cell_integral.AddAndSubtractLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                }
                cell_integral.AddAndSubtractLabel.text = integralState;
                cell_integral.IDOrMoneyLabel.text = allInfoArr[indexPath.row][@"title"];
                cell_integral.ItemLabel.text = allInfoArr[indexPath.row][@"subTitle"];
                cell_integral.finishTimeLabel.text = allInfoArr[indexPath.row][@"time"];
            }
            return cell_integral;
        }
            break;
        case 301:
        {
            cell_obtain.obtainIntegralLabel.textColor = [UIColor jk_colorWithHexString:@"#6fbd36"];
            //设置cell为不响应状态
            cell_obtain.selectionStyle = UITableViewCellSelectionStyleNone;
            //赋值
            if (obtainInfoArr.count > 0) {
                cell_obtain.obtainIntegralLabel.text =  [NSString stringWithFormat:@"+%@",obtainInfoArr[indexPath.row][@"intetralState"]];
                cell_obtain.IDOrMoney.text = obtainInfoArr[indexPath.row][@"title"];
                cell_obtain.itemLabel.text = obtainInfoArr[indexPath.row][@"subTitle"];
                cell_obtain.timeLabel.text = obtainInfoArr[indexPath.row][@"time"];
            }

            return cell_obtain;
        }
            break;
        case 302:
        {
            
            cell_expanse.expanseIntegralLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            //设置cell为不响应状态
            cell_expanse.selectionStyle = UITableViewCellSelectionStyleNone;
            //赋值
            if (expanseInfoArr.count > 0) {
                cell_expanse.expanseIntegralLabel.text = [NSString stringWithFormat:@"-%@",expanseInfoArr[indexPath.row][@"intetralState"]];
                cell_expanse.valueLabel.text = expanseInfoArr[indexPath.row][@"title"];
                cell_expanse.itmeLabel.text = expanseInfoArr[indexPath.row][@"subTitle"];
                cell_expanse.expanseTimeLabel.text = expanseInfoArr[indexPath.row][@"time"];
            }

            return cell_expanse;
        }
            break;
        default:
            break;
            
    }
    }
   
    return 0;
}

#pragma mark - action methods

#pragma mark 查看积分说明手势点击方法
-(void)toCheck:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击查看积分说明");
    IntegralIintroductionViewController *integralIntrduction = [[IntegralIintroductionViewController alloc] init];
    integralIntrduction.integralNumber = allDic[@"canUseIntegral"];
    [self.navigationController pushViewController:integralIntrduction animated:YES];
}

#pragma mark 积分兑换手势点击方法
-(void)exchangeCoupon:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击积分兑换");
    ExchangeIntegralViewController *exchange = [[ExchangeIntegralViewController alloc] init];
    exchange.integralNumber = allDic[@"canUseIntegral"];
    [self.navigationController pushViewController:exchange animated:YES];
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
                allDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                allInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"allIngetrals"]];
                [allIntegralTable reloadData];
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
                obtainDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                obtainInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"allIngetrals"]];
                [obtainIntegralTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                expanseDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                expanseInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"allIngetrals"]];
                [expenseIntegralTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
