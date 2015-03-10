//
//  TypesDetailViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-17.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "TypesDetailViewController.h"
#import "RootTabBarController.h"
#import "SearchViewController.h"
#import "TypesDetailCell.h"
#import "ShoppingCartViewController.h"
#import "MJRefresh.h"
//动画时间
#define kAnimationDuration 0.2
@interface TypesDetailViewController ()
{
    UITableView *typesDetailTable;
    UIView *grayBackView;
    UITextField *field1;
    UITextField *field2;
    UIView *alphaVIew;
    int flag;
    UITableView *conditionTable;
    NSMutableArray *priceArr;
    NSArray *chufangArr;
    NSString *doubleprice;//价格区间
    NSString *icetype;//品牌类型
    NSString *searchType;//搜索分类（0为默认，1为销量）
    NSString *medictype;//2为处方药，1为非处方药
    NSString *searchId;
    int currentpage;
    int pagerows;
    NSMutableArray *productInfoArr;
    NSMutableArray *nameArr;
    BOOL isRefresh;
    NSString *accesstoken;
    NSString *uniquedid;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)salesBtn:(UIButton *)sender;
- (IBAction)screenBtn:(UIButton *)sender;
- (IBAction)defaultBtn:(UIButton *)sender;
@end

@implementation TypesDetailViewController
@synthesize diseaseId,keyWord,requestFlag;
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
    _conditionbackView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    chufangArr = @[@"处方",@"非处方"];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    [self addRightBarButtonItem:searchBtn];
    
    
    typesDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50-64) style:UITableViewStylePlain];
    typesDetailTable.delegate = self;
    typesDetailTable.dataSource = self;
    typesDetailTable.tag = 1000;
    [self.view addSubview:typesDetailTable];
    
    //注册xib
    [typesDetailTable registerNib:[UINib nibWithNibName:@"TypesDetailCell" bundle:nil] forCellReuseIdentifier:@"typesDetailCell"];
    
    //集成药品分类刷新控件
    [self setupTypeDetailRefresh];
}

- (void)setupTypeDetailRefresh
{
    // 上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [typesDetailTable addFooterWithTarget:self action:@selector(shopCartFooterRereshing)];
    
    typesDetailTable.footerPullToRefreshText = @"上拉加载更多";
    typesDetailTable.footerReleaseToRefreshText = @"松开马上加载更多";
    typesDetailTable.footerRefreshingText = @"正在帮你加载中.....";
}


#pragma mark 查询条件接口
-(void)requestConditionData{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/queryCondition"];
    NSLog(@"self.keyWord== %@",self.keyWord);
    NSLog(@"self.diseaseId====%@",self.diseaseId);
    
    //参数
    NSDictionary *parameters;
    switch (self.requestFlag) {
        case 1:
        {
            parameters = @{@"searchType":@"0",@"key":self.keyWord};
        }
            break;
        case 2:
        {
            parameters = @{@"searchType":@"1",@"key":self.diseaseId};
        }
            break;
        default:
            break;
    }

    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}

#pragma mark 药品信息请求方法
-(void)requestDrugInfoData{
    [[Loading shareLoading] beginLoading];
    [self judege];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/searchByType"];
    NSLog(@"urlStr ==drugInfo== %@",urlStr);

    NSString *temp2 = [NSString stringWithFormat:@"%d",currentpage];
    NSString *temp3 = [NSString stringWithFormat:@"%d",pagerows];
    NSDictionary *parameters = @{@"typeId":self.diseaseId,@"searchType":searchType,@"currentpage":temp2,@"pagerows":temp3,@"doubleprice":doubleprice,@"medictype":medictype,@"icotype":icetype};
    NSLog(@"parameters======%@",parameters);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
    currentpage++;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    if (self.requestFlag == 1) {
        self.title = self.keyWord;
    }
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    
    NSLog(@"self.keyWord====%@",keyWord);
    [self requestConditionData];

    currentpage = 1;
    pagerows = 10;
    searchType = @"0";
    doubleprice = @"";
    icetype = @"";
    medictype = @"";
    [self requestDrugInfoData];
}

#pragma mark - typesDetailTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1000:
        {
            return productInfoArr.count;
        }
            break;
        case 2000:
        {
            return 1;
        }
            break;
    
        default:
            break;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 1000:
        {
            return 1;
        }
            break;
        case 2000:
        {
            return 3;
        }
            break;
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1000:
        {
            return 100;
        }
            break;
        case 2000:
        {
            switch (indexPath.section) {
                case 0:
                {
                    int largeNums = (int)nameArr.count/4;
                    if (nameArr.count > largeNums*4) {
                        largeNums++;
                    }
                    return largeNums*40;
                }
                    break;
                case 1:
                {
                    int numbers = (int)priceArr.count/4;
                    if (priceArr.count > numbers*4) {
                        numbers++;
                    }
                    return 40*numbers;
                }
                    break;
                case 2:
                {
                    return 40;
                }
                    break;
                default:
                    break;
            }
            return 0;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1000:
        {
            return 1;
        }
            break;
        case 2000:
        {
            return 30;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1000:
        {
            return 1;
        }
            break;
        case 2000:
        {
            
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1000:
        {
            TypesDetailCell *cell = (TypesDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"typesDetailCell"];
            cell.priceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            
            
            
            [cell.jionshopcartBtn addTarget:self action:@selector(jionshopcartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.jionshopcartBtn.tag = 700 + indexPath.row;
            
            //赋值
            if (productInfoArr.count > 0) {
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",productInfoArr[indexPath.row][@"productOurprice"]];
                cell.marketPriceLabel.text = [NSString stringWithFormat:@"%@",productInfoArr[indexPath.row][@"productMarketPrice"]];
                cell.standardLabel.text = [NSString stringWithFormat:@"%@",productInfoArr[indexPath.row][@"productSize"]];
                cell.companyNamelabel.text = [NSString stringWithFormat:@"%@",productInfoArr[indexPath.row][@"productMake"]];
                cell.productNameLabel.text = [NSString stringWithFormat:@"%@",productInfoArr[indexPath.row][@"productName"]];
                [cell.productImageView loadImageFromURL:[NSURL URLWithString:productInfoArr[indexPath.row][@"info"][@"productPic"]]];
            }
            
            NSUInteger length = [cell.marketPriceLabel.text length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.marketPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
            [cell.marketPriceLabel setAttributedText:attri];
            return cell;

        }
            break;
        case 2000:
        {
            NSLog(@"priceArr====%@",priceArr);
            static NSString *identifier = @"cellMark";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // IOS 子视图批量从父视图中移除。
            NSArray *subViews = [cell.contentView subviews];
            if([subViews count] != 0) {
                [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
            
            
            if (indexPath.section == 0) {
                int largeNums = (int)nameArr.count/4;
                if (nameArr.count > largeNums*4) {
                    largeNums++;
                }
                for (int i = 0; i < largeNums; i++) {
                    for (int j = 0; j < 4; j++) {
                        if (4*i+j >= nameArr.count) {
                            break;
                        }
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5+70*j, 10+40*i, 20, 20)];
                        btn.tag = 100+4*i+j;
                        [btn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(nameCondition:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25+70*j, 10+40*i, 55, 20)];
                        label.text = nameArr[4*i+j][@"brandName"];
                        label.textAlignment = NSTextAlignmentLeft;
                        label.font = [UIFont fontWithName:@"Arial" size:10];
                        label.textColor = [UIColor darkGrayColor];
                        [cell.contentView addSubview:label];
                    }
                }
            }else if (indexPath.section == 1) {
                int numbers = (int)priceArr.count/4;
                if (priceArr.count > numbers*4) {
                    numbers++;
                }
                for (int i = 0; i < numbers; i++) {
                    for (int j = 0; j < 4; j++) {
                        if (4*i+j >= priceArr.count) {
                            break;
                        }
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5+70*j, 10+40*i, 20, 20)];
                        btn.tag = 200+4*i+j;
                        [btn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(conditionBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25+70*j, 10+40*i, 55, 20)];
                        label.text = priceArr[4*i+j][@"price"];
                        label.textAlignment = NSTextAlignmentLeft;
                        label.font = [UIFont fontWithName:@"Arial" size:10];
                        label.textColor = [UIColor darkGrayColor];
                        [cell.contentView addSubview:label];
                    }
                }
            }else if (indexPath.section == 2){
                for (int i = 0; i < 2; i++) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+80*i, 10, 20, 20)];
                    btn.tag = 300+i;
                    [btn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(isCFBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40+80*i, 10, 40, 20)];
                    label.text = chufangArr[i];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.font = [UIFont fontWithName:@"Arial" size:12];
                    label.textColor = [UIColor darkGrayColor];
                    [cell.contentView addSubview:label];
                }
            }
            return cell;
        }
            break;
        default:
            break;
    }
    return 0;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titleArr = @[@"药品品牌",@"价格区间",@"是否处方"];
    switch (tableView.tag) {
        case 2000:
        {
            return titleArr[section];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    switch (tableView.tag) {
        case 1000:
        {
            
        }
            break;
         default:
            break;
    }
}


#pragma mark - Method
#pragma mark 加入购物车按钮方法
-(void)jionshopcartBtnAction:(UIButton *)btn{
    
    accesstoken = accesstoken == nil ? @"" : accesstoken;
    uniquedid = [[MyUserDefaults defaults] readFromUserDefaults:@"uniquedid"];
    if (uniquedid.length > 0) {
        [self requestJionShopCartData:(int)btn.tag-700];
    }else if (uniquedid.length == 0){
        NSLog(@"设备号获取失败");
    }
    
}

#pragma mark 加入购物车请求
-(void)requestJionShopCartData:(int)tagFlag{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/addShoppingCar"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"ProductID":productInfoArr[tagFlag][@"productId"],@"uniquedid":uniquedid,@"accesstoken":accesstoken,@"number":@"1",@"eMark":[NSString stringWithFormat:@"%@",productInfoArr[tagFlag][@"eMark"]],@"iShopCart":[NSString stringWithFormat:@"%@",productInfoArr[tagFlag][@"iShopCart"]]};
    NSLog(@"parameters=======%@",parameters);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}




-(void)initShopCartSuceessUI{
    grayBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayBackView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.25];
    [self.view addSubview:grayBackView];
    
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-160-64, [UIScreen mainScreen].bounds.size.width, 160)];
    whiteview.backgroundColor = [UIColor whiteColor];
    [grayBackView addSubview:whiteview];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 160, 20)];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = [UIColor blackColor];
    successLabel.text = @"成功加入购物车！";
    [whiteview addSubview:successLabel];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30+i*135, 80, 105, 40)];
        btn.tag = 800+i;
        if (i == 0) {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"继续购物" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0.2;
            btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
        }else{
            btn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
            [btn setTitle:@"进入购物车" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        btn.layer.cornerRadius = 3;
        [btn addTarget:self action:@selector(shopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteview addSubview:btn];
    }
    
}



-(void)shopBtnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 800:
        {
            //继续购物
            [grayBackView removeFromSuperview];
        }
            break;
        case 801:
        {
            [grayBackView removeFromSuperview];
            //进入购物车
            ShoppingCartViewController *shopcart = [[ShoppingCartViewController alloc] init];
            [self.navigationController pushViewController:shopcart animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark 条件视图方法
-(void)creatconditionUI{
    alphaVIew = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alphaVIew.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.7];
//    [alphaVIew addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self.view addSubview:alphaVIew];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height)];
    grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    grayView.tag = 1000;
    [alphaVIew addSubview:grayView];
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-20, 40, 40)];
    [iconBtn setImage:[UIImage imageNamed:@"strechLeft"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
    [alphaVIew addSubview:iconBtn];
    
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 60)];
    whiteview.backgroundColor = [UIColor whiteColor];
    [grayView addSubview:whiteview];
    
    UILabel *saixuanLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 15, 60, 30)];
    saixuanLable.text = @"筛选";
    saixuanLable.font = [UIFont fontWithName:@"Arial" size:20];
    saixuanLable.textAlignment = NSTextAlignmentCenter;
    saixuanLable.textColor = [UIColor blackColor];
    [whiteview addSubview:saixuanLable];
    
    
    conditionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height-60-64-80) style:UITableViewStyleGrouped];
    conditionTable.delegate = self;
    conditionTable.dataSource = self;
    conditionTable.tag = 2000;
    conditionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    conditionTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [grayView addSubview:conditionTable];
    
    
    NSArray *titleArr = @[@"取消",@"确定"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*([UIScreen mainScreen].bounds.size.width/2-20), [UIScreen mainScreen].bounds.size.height-60-64, [UIScreen mainScreen].bounds.size.width/2-60, 30)];
        if (i == 0) {
            btn.backgroundColor = [UIColor darkGrayColor];
        }else{
            btn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
        }
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 900 + i;
        [btn addTarget:self action:@selector(sureOrCancle:) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:btn];
    }
}


#pragma mark 品牌按钮方法
-(void)nameCondition:(UIButton *)btn{
    NSLog(@"品牌按钮");
    btn.selected = YES;
    for (int i = 100; i <= 100+nameArr.count; i++) {
        if (i == btn.tag) {
            if (btn.selected == YES) {
                [btn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            }
        }else{
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            [button setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
}


#pragma mark 价格区间按钮方法
-(void)conditionBtn:(UIButton *)btn{
    NSLog(@"价格区间按钮");
    btn.selected = YES;
    for (int i = 200; i <= 200+priceArr.count; i++) {
        if (i == btn.tag) {
            if (btn.selected == YES) {
                [btn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            }
        }else{
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            [button setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark 是否处方按钮方法
-(void)isCFBtn:(UIButton *)btn{
    NSLog(@"是否处方按钮");
    btn.selected = YES;
    for (int i = 300; i < 302; i++) {
        if (i == btn.tag) {
            if (btn.selected == YES) {
                [btn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
            }
        }else{
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            [button setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
}

-(void)judege{
    for (int i = 200; i < priceArr.count+200; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        if (btn.selected == YES) {
            doubleprice = priceArr[i-200][@"search"];
        }
    }
    for (int i = 300; i < 302; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        if (btn.selected == YES) {
            switch (i) {
                case 300:
                    medictype = @"2";
                    break;
                case 301:
                    medictype = @"1";
                    break;
                default:
                    break;
            }
        }
    }
    for (int i = 100; i <= nameArr.count+100; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        if (btn.selected == YES) {
            icetype = nameArr[i-100][@"brandCode"];
        }
    }

}


#pragma mark 左侧按钮方法
-(void)hideView:(UIButton *)btn{
    NSLog(@"左侧按钮");
    [alphaVIew removeFromSuperview];
    
}


#pragma mark 筛选的取消和确定按钮方法
-(void)sureOrCancle:(UIButton *)btn{
    NSLog(@"筛选的取消和确定");
    switch (btn.tag) {
        case 900:
        {
            NSLog(@"点击取消按钮");
        }
            break;
        case 901:
        {
            NSLog(@"点击确定按钮");
            isRefresh = NO;
            [self requestDrugInfoData];
        }
            break;
        default:
            break;
    }
    [alphaVIew removeFromSuperview];
}


#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark 销量按钮方法
- (IBAction)salesBtn:(UIButton *)sender {
    NSLog(@"点击销量按钮");
    isRefresh = NO;
    searchType = @"1";
    currentpage = 1;
    doubleprice = @"";
    icetype = @"";
    medictype = @"";
    [self requestDrugInfoData];
}

#pragma mark 筛选按钮方法
- (IBAction)screenBtn:(UIButton *)sender {
    NSLog(@"点击筛选按钮");
    [self creatconditionUI];
}

#pragma mark 默认按钮方法
- (IBAction)defaultBtn:(UIButton *)sender {
    NSLog(@"点击默认按钮");
    isRefresh = NO;
    searchType = @"0";
    currentpage = 1;
    doubleprice = @"";
    icetype = @"";
    medictype = @"";
    [self requestDrugInfoData];
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
        } else {
            NSLog(@"object====%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                if (productInfoArr.count == 0) {
                    priceArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"doubleprice"]];
                }else{
                    [priceArr removeAllObjects];
                    [priceArr addObjectsFromArray:object[@"info"][@"doubleprice"]];
                }
                if (productInfoArr.count == 0) {
                    nameArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"medictype"]];
                }else{
                    [nameArr removeAllObjects];
                    [nameArr addObjectsFromArray:object[@"info"][@"medictype"]];
                }
                NSLog(@"priceArr====%@,nameArr===%@",priceArr,nameArr);
                [conditionTable reloadData];
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"object%@,msg===%@,self.class===%@", object,object[@"msg"],self.class);
            if ([object[@"result"] isEqualToNumber:@0]) {
                if ([object[@"info"][@"productResults"]count] == 0) {
                    [self showToast:@"没有可加载的数据"];
                }
                if (isRefresh == YES) {
                    [productInfoArr addObjectsFromArray:object[@"info"][@"productResults"]];
                }else{
                    if (productInfoArr.count == 0) {
                        productInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"productResults"]];
                    }else{
                        [productInfoArr removeAllObjects];
                        [productInfoArr addObjectsFromArray:object[@"info"][@"productResults"]];
                    }
                }
                
                [typesDetailTable reloadData];
                [[Loading shareLoading] endLoading];
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"object%@,self.class===%@",object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self initShopCartSuceessUI];
                [self showToast:@"加入购物车成功！"];
                [[Loading shareLoading] endLoading];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


-(void)shopCartFooterRereshing{
    isRefresh = YES;
    currentpage++;
    [self requestDrugInfoData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [typesDetailTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [typesDetailTable footerEndRefreshing];
    });
}


@end
