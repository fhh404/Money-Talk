//
//  ResultForScanViewController.m
//  jiankemall
//
//  Created by kunge on 15/1/6.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "ResultForScanViewController.h"
#import "RootTabBarController.h"
#import "HomeViewController.h"
#import "SuccessScanCell.h"
@interface ResultForScanViewController ()
{
    UIView *grayBackView;
    UITableView *successScanTable;
    NSMutableDictionary *productDic;
    NSString *accesstoken;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation ResultForScanViewController
@synthesize barCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"识别结果";
    
    
    [self creatFailUI];
    
    [self creatSuccessTable];
    successScanTable.hidden = YES;
    
}



-(void)requestSaoMiaoData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/searchByBarCode"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"barCode":self.barCode};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    NSLog(@"self.barCode====%@",self.barCode);
    [self requestSaoMiaoData];
}



#pragma mark - successScanTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 350;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuccessScanCell *cell = (SuccessScanCell *)[tableView dequeueReusableCellWithIdentifier:@"successScanCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    //label
    if (productDic != nil) {
        cell.drugName.text = productDic[@"productName"];
        cell.guigeLabel.text = productDic[@"productSize"];
        cell.companyLabel.text = productDic[@"productMake"];
        cell.ourPriceLabel.text = [NSString stringWithFormat:@"健客价:￥%.2f",[productDic[@"productPrice"]floatValue]];
        cell.ourPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
        cell.marketPriceLabel.text = [NSString stringWithFormat:@"市场价:￥%.2f",[productDic[@"productMarketPrice"]floatValue]];
        [cell.drugPic loadImageFromURL:[NSURL URLWithString:productDic[@"productPic"]]];
    }
    //给label添加删除线
    NSUInteger length = [cell.marketPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.marketPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
    [cell.marketPriceLabel setAttributedText:attri];
    
    //按钮
    cell.addNoticeBtn.layer.cornerRadius = 3;
    [cell.addNoticeBtn addTarget:self action:@selector(addNoticeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyNowBtn.layer.cornerRadius = 3;
    cell.buyNowBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [cell.buyNowBtn addTarget:self action:@selector(buyNowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buyNowBtn setImage:[UIImage imageNamed:@"shopCartBtn(white)"] forState:UIControlStateNormal];
    cell.buyNowBtn.titleEdgeInsets = UIEdgeInsetsMake(3,20, 2, 10);
    cell.buyNowBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 15, 2, 75);
    [cell.collectionBtn addTarget:self action:@selector(collectionBtnAtion:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}




#pragma mark - Method
#pragma mark 加入用药提醒按钮
-(void)addNoticeBtnAction:(UIButton *)btn{
    NSLog(@"点击加入用药提醒按钮");
}

#pragma mark 立即购买按钮
-(void)buyNowBtnAction:(UIButton *)btn{
    NSLog(@"点击立即购买按钮");
}

#pragma mark 收藏按钮
-(void)collectionBtnAtion:(UIButton *)btn{
    NSLog(@"点击收藏按钮");
    if (accesstoken.length > 0) {
        [self requestAddCollectData];
    }else{
        [self showToast:@"请先登录！"];
    }
}

#pragma mark 收藏按钮请求
-(void)requestAddCollectData{
    [[Loading shareLoading] beginLoading];
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/addMyCollection"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);

    NSDictionary *parameters = @{@"ProductID":productDic[@"productId"],@"accesstoken":accesstoken};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}



#pragma mark 创建扫描结果失败视图
-(void)creatFailUI{
    grayBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    grayBackView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:grayBackView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, 120, 64, 64)];
    iconImage.image = [UIImage imageNamed:@"saomiaoFail"];
    [grayBackView addSubview:iconImage];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-130, 240, 260, 20)];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"抱歉，没有扫描到您想要找得产品~";
    tipsLabel.font = [UIFont fontWithName:@"Arial" size:16];
    [grayBackView addSubview:tipsLabel];
    
    UILabel *youLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-80, 270, 80, 20)];
    youLabel.textColor = [UIColor lightGrayColor];
    youLabel.textAlignment = NSTextAlignmentCenter;
    youLabel.text = @"你可以去";
    youLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [grayBackView addSubview:youLabel];
    
    //为首页添加下划线
    UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-10, 270, 70, 20)];
    homeLabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    homeLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"首页"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    homeLabel.attributedText = content;
    homeLabel.userInteractionEnabled = YES;
    [homeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToHome:)]];
    homeLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [grayBackView addSubview:homeLabel];

    UILabel *seeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2+50, 270, 60, 20)];
    seeLabel.textColor = [UIColor lightGrayColor];
    seeLabel.textAlignment = NSTextAlignmentCenter;
    seeLabel.text = @"看看";
    seeLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [grayBackView addSubview:seeLabel];

}

#pragma mark 创建扫描成功视图
-(void)creatSuccessTable{
    successScanTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-0) style:UITableViewStyleGrouped];
    successScanTable.delegate = self;
    successScanTable.dataSource = self;
    successScanTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    successScanTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:successScanTable];
    
    //注册xib
    [successScanTable registerNib:[UINib nibWithNibName:@"SuccessScanCell" bundle:nil] forCellReuseIdentifier:@"successScanCell"];
}


#pragma mark 返回首页手势方法
-(void)backToHome:(UITapGestureRecognizer *)gesture{
    HomeViewController *home = (HomeViewController *)self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:home animated:YES];
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
            NSLog(@"object======%@", object);
            if([object[@"result"] isEqualToNumber:@0]){
                [self showToast:@"扫描成功！"];
                grayBackView.hidden = YES;
                successScanTable.hidden = NO;
                productDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                [successScanTable reloadData];
            }else{
                grayBackView.hidden = NO;
                successScanTable.hidden = YES;
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"object======%@", object);
            if([object[@"result"] isEqualToNumber:@0]){
                [self showToast:@"添加收藏成功！"];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


@end
