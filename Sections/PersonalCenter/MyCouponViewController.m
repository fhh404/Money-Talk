//
//  MyCouponViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MyCouponViewController.h"

#import "RootTabBarController.h"
#import "HMSegmentedControl.h"
#import "MyCouponCell.h"
#import "MyActionCouponCell.h"
#import "CouponUseRuleViewController.h"
@interface MyCouponViewController ()
{
    HMSegmentedControl *segmentedControl1;
    UITableView *myCouponTable;
    UITableView *myActionCouponTable;
    NSString *accesstoken;
    int currentOnepage;
    int currentTwopage;
    int currentThreepage;
    int currentFourpage;
    int currentFivepage;
    int currentSixpage;
    int pageRows;
    NSMutableArray *nonUsedCouponOneArr;
    NSMutableArray *usedCouponOneArr;
    NSMutableArray *failedCouponOneArr;
    NSMutableArray *nonUsedCouponTwoArr;
    NSMutableArray *usedCouponTwoArr;
    NSMutableArray *failedCouponTwoArr;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;


@end

@implementation MyCouponViewController

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
    self.title = @"我的优惠券";
    
    
    
    //带scrollow的segmentControl
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"积分优惠券", @"活动优惠券"]];
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
    }];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
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
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height-104);
    self.scrollView.delegate = self;
    
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-104) animated:NO];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = self.scrollView.contentOffset.x / pageWidth;
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
    
    [self.view addSubview:self.scrollView];

    //未完成订单
    myCouponTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    myCouponTable.delegate = self;
    myCouponTable.dataSource = self;
    myCouponTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    myCouponTable.tag = 300;
    myCouponTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:myCouponTable];
    
    //已完成订单
    myActionCouponTable = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    myActionCouponTable.delegate = self;
    myActionCouponTable.dataSource = self;
    myActionCouponTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    myActionCouponTable.tag = 301;
    myActionCouponTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:myActionCouponTable];
    
    
    //注册XIB
    [myCouponTable registerNib:[UINib nibWithNibName:@"MyCouponCell" bundle:nil] forCellReuseIdentifier:@"myCoupon"];
    [myActionCouponTable registerNib:[UINib nibWithNibName:@"MyActionCouponCell" bundle:nil] forCellReuseIdentifier:@"myActionCoupon"];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    currentOnepage = 1;
    currentTwopage = 1;
    currentThreepage = 1;
    currentFourpage = 1;
    currentFivepage = 1;
    currentSixpage = 1;
    pageRows = 10;
    if (accesstoken.length > 0) {
        [self requestNonUseCouponOneData];
        [self requestUsedCouponOneData];
        [self requestFailedCouponOneData];
        [self requestNonUseCouponTwoData];
        [self requestUsedCouponTwoData];
        [self requestFailedCouponTwoData];
    }
    
}


#pragma mark - 积分优惠券请求
#pragma mark 未使用优惠券请求
-(void)requestNonUseCouponOneData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"1"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}

#pragma mark 已使用优惠券请求
-(void)requestUsedCouponOneData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"2"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}

#pragma mark 已失效优惠券请求
-(void)requestFailedCouponOneData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"3"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}

#pragma mark - 活动优惠券请求
#pragma mark 未使用优惠券请求
-(void)requestNonUseCouponTwoData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"1"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:400];
}

#pragma mark 已使用优惠券请求
-(void)requestUsedCouponTwoData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"2"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:500];
}

#pragma mark 已失效优惠券请求
-(void)requestFailedCouponTwoData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentOnepage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"type":@"3"};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getCouponFromIntrgral"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:600];
}


#pragma mark - segmentedControlMehtod
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



#pragma mark - TableView_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
        {
            if (section == 0) {
                return nonUsedCouponOneArr.count;
            }else if (section == 1) {
                return usedCouponOneArr.count;
            }else if (section == 2) {
                return failedCouponOneArr.count;
            }
        }
            break;
        case 301:
        {
            if (section == 0) {
                return nonUsedCouponTwoArr.count;
            }else if (section == 1) {
                return usedCouponTwoArr.count;
            }else if (section == 2) {
                return failedCouponOneArr.count;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"ttableView.tag===%ld",tableView.tag);
    switch (tableView.tag) {
        case 300:
        {
            MyCouponCell *cell = (MyCouponCell *)[tableView dequeueReusableCellWithIdentifier:@"myCoupon"];
            cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell.whiteView.backgroundColor = [UIColor whiteColor];
            cell.grayView.backgroundColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 0 ) {
                cell.couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                cell.backCouponImage.image = [UIImage imageNamed:@"nonUsedCoupon"];
                //赋值
                if (nonUsedCouponOneArr.count > 0) {
                    cell.couponPriceLabel.text = nonUsedCouponOneArr[indexPath.row][@"couponValue"];
                    cell.originalLabel.text = nonUsedCouponOneArr[indexPath.row][@"couponFrom"];
                    cell.itemLabel.text = nonUsedCouponOneArr[indexPath.row][@"couponType"];
                    cell.useRuleLabel.text = nonUsedCouponOneArr[indexPath.row][@"couponUseType"];
                    cell.validityLabel.text = nonUsedCouponOneArr[indexPath.row][@"usefulTime"];
                    cell.couponID.text = nonUsedCouponOneArr[indexPath.row][@"couponId"];
                }
            }else if (indexPath.section == 1){
                cell.backCouponImage.image = [UIImage imageNamed:@"hasUsedCoupon"];
                cell.couponPriceLabel.textColor = [UIColor darkGrayColor];
                if (usedCouponOneArr.count > 0) {
                    cell.couponPriceLabel.text = usedCouponOneArr[indexPath.row][@"couponValue"];
                    cell.originalLabel.text = usedCouponOneArr[indexPath.row][@"couponFrom"];
                    cell.itemLabel.text = usedCouponOneArr[indexPath.row][@"couponType"];
                    cell.useRuleLabel.text = usedCouponOneArr[indexPath.row][@"couponUseType"];
                    cell.validityLabel.text = usedCouponOneArr[indexPath.row][@"usefulTime"];
                    cell.couponID.text = usedCouponOneArr[indexPath.row][@"couponId"];
                }
            }else if (indexPath.section == 2){
                cell.backCouponImage.image = [UIImage imageNamed:@"hasUsedCoupon"];
                cell.couponPriceLabel.textColor = [UIColor darkGrayColor];
                if (failedCouponOneArr.count > 0) {
                    cell.couponPriceLabel.text = failedCouponOneArr[indexPath.row][@"couponValue"];
                    cell.originalLabel.text = failedCouponOneArr[indexPath.row][@"couponFrom"];
                    cell.itemLabel.text = failedCouponOneArr[indexPath.row][@"couponType"];
                    cell.useRuleLabel.text = failedCouponOneArr[indexPath.row][@"couponUseType"];
                    cell.validityLabel.text = failedCouponOneArr[indexPath.row][@"usefulTime"];
                    cell.couponID.text = failedCouponOneArr[indexPath.row][@"couponId"];
                }
            }
            
            
            
            return cell;
        }
            break;
        case 301:
        {
            MyActionCouponCell *cell_action = (MyActionCouponCell *)[tableView dequeueReusableCellWithIdentifier:@"myActionCoupon"];
            cell_action.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell_action.whiteView.backgroundColor = [UIColor whiteColor];
            cell_action.grayView.backgroundColor = [UIColor lightGrayColor];
            cell_action.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 0 ) {
                cell_action.couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
                cell_action.backCouponImage.image = [UIImage imageNamed:@"nonUsedCoupon"];
                //赋值
                if (nonUsedCouponTwoArr.count > 0) {
                    cell_action.couponPriceLabel.text = nonUsedCouponTwoArr[indexPath.row][@"couponValue"];
                    cell_action.orginalLabel.text = nonUsedCouponTwoArr[indexPath.row][@"couponFrom"];
                    cell_action.itemLabel.text = nonUsedCouponTwoArr[indexPath.row][@"couponType"];
                    cell_action.useRuleLabel.text = nonUsedCouponTwoArr[indexPath.row][@"couponUseType"];
                    cell_action.timeLabel.text = nonUsedCouponTwoArr[indexPath.row][@"usefulTime"];
                }
            }else if (indexPath.section == 1){
                cell_action.backCouponImage.image = [UIImage imageNamed:@"hasUsedCoupon"];
                cell_action.couponPriceLabel.textColor = [UIColor darkGrayColor];
                if (usedCouponTwoArr.count > 0) {
                    cell_action.couponPriceLabel.text = usedCouponTwoArr[indexPath.row][@"couponValue"];
                    cell_action.orginalLabel.text = usedCouponTwoArr[indexPath.row][@"couponFrom"];
                    cell_action.itemLabel.text = usedCouponTwoArr[indexPath.row][@"couponType"];
                    cell_action.useRuleLabel.text = usedCouponTwoArr[indexPath.row][@"couponUseType"];
                    cell_action.timeLabel.text = usedCouponTwoArr[indexPath.row][@"usefulTime"];
                }
            }else if (indexPath.section == 2){
                cell_action.backCouponImage.image = [UIImage imageNamed:@"hasUsedCoupon"];
                cell_action.couponPriceLabel.textColor = [UIColor darkGrayColor];
                if (failedCouponTwoArr.count > 0) {
                    cell_action.couponPriceLabel.text = failedCouponTwoArr[indexPath.row][@"couponValue"];
                    cell_action.orginalLabel.text = failedCouponTwoArr[indexPath.row][@"couponFrom"];
                    cell_action.itemLabel.text = failedCouponTwoArr[indexPath.row][@"couponType"];
                    cell_action.useRuleLabel.text = failedCouponTwoArr[indexPath.row][@"couponUseType"];
                    cell_action.timeLabel.text = failedCouponTwoArr[indexPath.row][@"usefulTime"];
                }
            }
            return cell_action;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titleArr = @[@"未使用优惠券:",@"已使用优惠券:",@"已失效优惠券:"];
    if ( tableView.tag == 300 ||tableView.tag == 301) {
        
            UIView *headerView = [[UIView alloc] init];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 30)];
            titleLabel.text = titleArr[section];
            titleLabel.textColor = [UIColor darkGrayColor];
            [headerView addSubview:titleLabel];
            
            if (section == 0) {
                UILabel *couponuseRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 10, 130, 30)];
                couponuseRuleLabel.userInteractionEnabled = YES;
                couponuseRuleLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                couponuseRuleLabel.text = @"优惠券使用规则";
                couponuseRuleLabel.textAlignment = NSTextAlignmentRight;
                [couponuseRuleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponAction:)]];
                [headerView addSubview:couponuseRuleLabel];
            }
            return headerView;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
        {
            UIView *viewForMore = [[UIView alloc] init];
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 5, 100, 30)];
            moreBtn.tag = 400+section;
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(reloadMore:) forControlEvents:UIControlEventTouchUpInside];
            moreBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            [viewForMore addSubview:moreBtn];
            return viewForMore;
        }
            break;
        case 301:
        {
            UIView *viewForMore = [[UIView alloc] init];
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 5, 100, 30)];
            moreBtn.tag = 500+section;
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(reloadMoreTwo:) forControlEvents:UIControlEventTouchUpInside];
            moreBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            [viewForMore addSubview:moreBtn];
            return viewForMore;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark - Method


#pragma mark 积分优惠券更多方法
-(void)reloadMore:(UIButton *)btn{
    switch (btn.tag) {
        case 400:
        {
            [self requestNonUseCouponOneData];
        }
            break;
        case 401:
        {
            [self requestUsedCouponOneData];
        }
            break;
        case 402:
        {
            [self requestFailedCouponOneData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 活动优惠券更多方法
-(void)reloadMoreTwo:(UIButton *)btn{
    switch (btn.tag) {
        case 500:
        {
            [self requestNonUseCouponTwoData];
        }
            break;
        case 501:
        {
            [self requestUsedCouponTwoData];
        }
            break;
        case 502:
        {
            [self requestFailedCouponTwoData];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark 优惠券使用规则
-(void)couponAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到优惠券使用规则页面");
    CouponUseRuleViewController *couponUseRule = [[CouponUseRuleViewController alloc] init];
    [self.navigationController pushViewController:couponUseRule animated:YES];
}

#pragma mark 更多按钮方法
- (IBAction)moreBtn:(UIButton *)sender {
    NSLog(@"点击更多按钮");
    CGPoint point = CGPointMake(275, 64);
    NSArray *titles = @[@"首页", @"用药提醒", @"个人中心",@"购物车"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        RootTabBarController *root = (RootTabBarController *)self.tabBarController;
        if (index == 0) {
            NSLog(@"首页");
            [root selectAtIndex:10];
        }else if (index == 1){
            NSLog(@"用药提醒");
            [root selectAtIndex:11];
        }else if (index == 2){
            NSLog(@"个人中心");
            [root selectAtIndex:12];
        }else if (index == 3){
            NSLog(@"购物车");
            [root selectAtIndex:13];
        }
    };
    [pop show];
}

#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (nonUsedCouponOneArr.count == 0) {
                    nonUsedCouponOneArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [nonUsedCouponOneArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }
                [myCouponTable reloadData];
                currentOnepage++;
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (usedCouponOneArr.count == 0) {
                    usedCouponOneArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [usedCouponOneArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }

                [myCouponTable reloadData];
                currentTwopage++;
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
                
                if (failedCouponOneArr.count == 0) {
                    failedCouponOneArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [failedCouponOneArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }

                [myCouponTable reloadData];
                currentThreepage++;
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 400) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (nonUsedCouponTwoArr.count == 0) {
                    nonUsedCouponTwoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [nonUsedCouponTwoArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }
                [myActionCouponTable reloadData];
                currentFourpage++;
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 500) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                if (usedCouponTwoArr.count == 0) {
                    usedCouponTwoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [usedCouponTwoArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }

                [myActionCouponTable reloadData];
                currentFivepage++;
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 600) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (failedCouponTwoArr.count == 0) {
                    failedCouponTwoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"couponLists"]];
                }else{
                    [failedCouponTwoArr addObjectsFromArray:object[@"info"][@"couponLists"]];
                }

                [myActionCouponTable reloadData];
                currentSixpage++;
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}



@end
