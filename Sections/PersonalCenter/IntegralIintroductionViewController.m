//
//  IntegralIintroductionViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/23.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "IntegralIintroductionViewController.h"
#import "RootTabBarController.h"
#import "HMSegmentedControl.h"
#import "IntegralLabelCell.h"
#import "IntegralLabel2Cell.h"
@interface IntegralIintroductionViewController ()
{
    HMSegmentedControl *segmentedControl1;
    UITableView *intergalRuleTable;
    UITableView *intergalUseTabel;
    NSArray *useArr;
    UIImageView *integrateTipImage;
    UILabel *integrateTipsNum;
    UIImageView *integralProgress;
    UILabel *tipsLabel;
}
@end

@implementation IntegralIintroductionViewController
@synthesize integralNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"积分说明";
    
    [self creatProgressUI];
    
    //带scrollow的segmentControl
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"积分规则", @"积分使用"]];
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
    }];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 215-64, 320, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    //分隔线
    UIImageView *LineImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*(0+1)/2, 11, 1, 15)];
    LineImage.image = [UIImage imageNamed:@"grayLine（vertical ）"];
    [segmentedControl1 addSubview:LineImage];

     __weak typeof(self) weakSelf = self;
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width * index, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) animated:YES];
    }];
    
    [self.view addSubview:segmentedControl1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 255-65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-255+64)];
    self.scrollView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height-255);
    self.scrollView.delegate = self;
    
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-255) animated:NO];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = self.scrollView.contentOffset.x / pageWidth;
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
    
    [self.view addSubview:self.scrollView];
    
    //全部
    intergalRuleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-255+64) style:UITableViewStylePlain];
    intergalRuleTable.delegate = self;
    intergalRuleTable.dataSource = self;
    intergalRuleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    intergalRuleTable.tag = 300;
    intergalRuleTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:intergalRuleTable];
    
    //获得
    intergalUseTabel = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-255+64) style:UITableViewStylePlain];
    intergalUseTabel.delegate = self;
    intergalUseTabel.dataSource = self;
    intergalUseTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    intergalUseTabel.tag = 301;
    intergalUseTabel.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.scrollView addSubview:intergalUseTabel];
    
    
    
    useArr = @[@"积分长期有效、积分只能在本账户使用、不同账户积分不可转让使用。",@"兑换成电子代金优惠券(查看优惠券规则).",@"积分跟优惠券的兑换比例为100:1,即100健客积分等于1元，如500积分可兑换为5元优惠券，优惠券面值有：5元、10元、20元、50元四种；已兑换的优惠券不可再次兑换回积分，已兑换的优惠券需在有效期内使用，过期作废。有效期为：自兑换之日起1个月内有效。",@"积分抽奖（通过积分可参与积分抽奖活动，活动信息可持续关注网站各网站广告词、活动专题页面、社区各大版块）."];
}

-(void)creatProgressUI{
    _integralNumberLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    _backImage.layer.cornerRadius = 8;

    
    
    integrateTipImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 57, 26, 21)];
    integrateTipImage.image = [UIImage imageNamed:@"integrateNum"];
    [self.view addSubview:integrateTipImage];
    
    integralProgress = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45.5, 0, 9)];
    integralProgress.image = [UIImage imageNamed:@"progress"];
    [self.view addSubview:integralProgress];
    
    integrateTipsNum = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 26, 20)];
    integrateTipsNum.textAlignment = NSTextAlignmentCenter;
    integrateTipsNum.textColor = [UIColor whiteColor];
    integrateTipsNum.text = @"0";
    integrateTipsNum.font = [UIFont fontWithName:@"Arial" size:12];
    [self.view addSubview:integrateTipsNum];
    
    tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 40)];
    tipsLabel.textColor = [UIColor darkGrayColor];
    tipsLabel.font = [UIFont fontWithName:@"Arial" size:12];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
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



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    _integralNumberLabel.text = self.integralNumber;
    integrateTipsNum.text = self.integralNumber;
    int number = [self.integralNumber intValue];
    integrateTipImage.frame = CGRectMake(8+5*number/100, 57, 26, 21);
    integrateTipsNum.frame = CGRectMake(8+5*number/100, 60, 26, 20);
    integralProgress.frame = CGRectMake(20, 45.5, 5*number/100, 9);
    int tempNum;
    int money;
    if (number > 500) {
        if (number < 1500) {
            tempNum = 1500 - number;
            money = 10;
        }else if (number > 1500 && number < 3000){
            tempNum = 3000 - number;
            money = 20;
        }else if (number > 3000 && number < 5000){
            tempNum = 5000 - number;
        }
    }else{
        tempNum = 500 - number;
        money = 5;
    }
    tipsLabel.text = [NSString stringWithFormat:@"根据你目前的积分你可以参加积分换购(或者再获取%d积分就可以兑换%d元优惠券)",tempNum,money];
}


#pragma mark TableView_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 300:
        {
            return 6;
        }
            break;
        case 301:
        {
            return 4;
        }
            break;
    
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 300:
        {
            return 50;
        }
            break;
        case 301:
        {
            NSString *str = useArr[indexPath.row];
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [str boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            NSLog(@"%f",sizeText.height);
            return sizeText.height;
        }
            break;
   
        default:
            break;
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ruleArr = @[@"1、购买健客产品，订单完成后，获得与付款 金额数相等的积分数",@"2、对每个所购买的商品进行评论可获得100积分",@"3、凡成功注册为会员即可获得400积分（手机号码只能注册一次）",@"4、完善个人资料赚取积分(详细积分数额在相应页面有标识）",@"5、参加网站举行的积分赠送促销活动，可获得当次活动赠送的积分",@"6、会员每年都可获赠与当年消费金额数相等的积分数额的年度奖励"];

    
    switch (tableView.tag) {
        case 300:
        {
            static NSString *identifier = @"cellMark";
            IntegralLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[IntegralLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }

            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.intergalContentLabel.numberOfLines = 0;
            [cell.intergalContentLabel sizeToFit];

            cell.intergalContentLabel.text = ruleArr[indexPath.row];//数据源
            cell.intergalContentLabel.frame = CGRectMake(20, 0, 280, 50);
            return cell;
        }
            break;
        case 301:
        {
            static NSString *identifier1 = @"cellMark1";
            IntegralLabel2Cell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell1 == nil) {
                cell1 = [[IntegralLabel2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            cell1.backgroundColor = [UIColor whiteColor];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.intergalLabel2.numberOfLines = 0;
            [cell1.intergalLabel2 sizeToFit];

            cell1.intergalLabel2.text = useArr[indexPath.row];//数据源
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [cell1.intergalLabel2.text boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            NSLog(@"%f",sizeText.height);
            cell1.intergalLabel2.frame = CGRectMake(20, 0, 280, sizeText.height);
            return cell1;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
#pragma mark - Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
