//
//  CheckLogisticsViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "CheckLogisticsViewController.h"
#import "RootTabBarController.h"
#import "MyLogisticsCell.h"

@interface CheckLogisticsViewController ()
{
    UITableView *logisticTable;
    NSString *accesstoken;
    NSMutableArray *logisticsArr;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation CheckLogisticsViewController
@synthesize trackingNum;
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
    
    self.title = @"查看物流";
    
    logisticTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];

    logisticTable.delegate = self;
    logisticTable.dataSource = self;
    logisticTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:logisticTable];
    
    //注册xib
    [logisticTable registerNib:[UINib nibWithNibName:@"MyLogisticsCell" bundle:nil] forCellReuseIdentifier:@"myLogisticsCell"];
    
}

#pragma mark 已完成订单请求
-(void)requestLogisticsData{
    [[Loading shareLoading] beginLoading];
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getLogisticsInfo"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"trackingNum":self.trackingNum};
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
        [self requestLogisticsData];
    }
}

#pragma mark - logisticTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return logisticsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MyLogisticsCell *newsCell = (MyLogisticsCell *)[tableView dequeueReusableCellWithIdentifier:@"myLogisticsCell"];
    newsCell.backgroundColor = [UIColor whiteColor];
    newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        newsCell.lineImageView.image = [UIImage imageNamed:@"blue（verical）"];
        newsCell.contentBackImageView.image = [UIImage imageNamed:@"currentNewscaseBack"];
        newsCell.timeLabel.textColor = [UIColor whiteColor];
        newsCell.newsLabel.textColor = [UIColor whiteColor];
    }else{
        newsCell.lineImageView.image = [UIImage imageNamed:@"grayLine（vertical ）"];
        newsCell.contentBackImageView.image = [UIImage imageNamed:@"failNewscaseBack"];
        newsCell.timeLabel.textColor = [UIColor darkGrayColor];
        newsCell.newsLabel.textColor = [UIColor darkGrayColor];
        
    }
    
    if (logisticsArr.count > 0) {
        newsCell.newsLabel.text = logisticsArr[indexPath.row][@"action"];
        newsCell.timeLabel.text = logisticsArr[indexPath.row][@"time"];
    }

    newsCell.newsLabel.numberOfLines = 0;

    return newsCell;
}



#pragma mark - Method

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
            NSLog(@"%@,self.class====%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                logisticsArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"infos"]];
                _companyNameLabel.text = object[@"info"][@"logisticsCompany"];
                _expressNumber.text = object[@"info"][@"expressNumber"];
                [logisticTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
        [[Loading shareLoading] endLoading];
    }
}


@end
