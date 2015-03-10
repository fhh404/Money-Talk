//
//  MyCollectionViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MyCollectionViewController.h"

#import "RootTabBarController.h"
#import "MyCollectionCell.h"
#import "ProductDetailViewController.h"
@interface MyCollectionViewController ()
{
    UITableView *myCollectionTabel;
    NSString *accesstoken;
    int currentpage;
    int pageRows;
    NSMutableArray *collectionInfoArr;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;


@end

@implementation MyCollectionViewController

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
    self.title = @"我的收藏";
    
    myCollectionTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    myCollectionTabel.dataSource = self;
    myCollectionTabel.delegate = self;
    myCollectionTabel.backgroundColor  = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:myCollectionTabel];
    
    //注册xib
    [myCollectionTabel registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellReuseIdentifier:@"myCollection"];
}

#pragma mark 收藏请求
-(void)requestCollectionData{
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getMyCollections"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
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
    currentpage = 1;
    pageRows = 10;
    if (accesstoken.length > 0) {
        [self requestCollectionData];
    }

}


#pragma mark - TableView_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return collectionInfoArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionCell *cell = (MyCollectionCell *)[tableView dequeueReusableCellWithIdentifier:@"myCollection"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.notificationBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [cell.notificationBtn addTarget:self action:@selector(notificationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.notificationBtn.tag = 100+indexPath.section;
    [cell.immediateBuyBtn addTarget:self action:@selector(immediateBuyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.immediateBuyBtn.tag = 200 +indexPath.section;
    cell.currentPrice.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.grayLine.backgroundColor = [UIColor darkGrayColor];
    
    if ([collectionInfoArr[indexPath.section][@"productOldPrice"]length] > 0) {
        cell.originalPrice.hidden = NO;
        cell.grayLine.hidden = NO;
        cell.depreciateLabel.hidden = NO;
        cell.depreciateLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    }else{
        cell.originalPrice.hidden = YES;
        cell.grayLine.hidden = YES;
        cell.depreciateLabel.hidden = YES;
    }
    
    //赋值
    if (collectionInfoArr.count > 0) {
        cell.currentPrice.text = collectionInfoArr[indexPath.section][@"productPrice"];
        cell.originalPrice.text = collectionInfoArr[indexPath.section][@"productOldPrice"];
        cell.productName.text = collectionInfoArr[indexPath.section][@"productName"];
        [cell.productImage loadImageFromURL:[NSURL URLWithString:collectionInfoArr[indexPath.section][@"productPic"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
    productDetail.priductCode = collectionInfoArr[indexPath.section][@"productId"];
    [self.navigationController pushViewController:productDetail animated:YES];
}

#pragma mark - Method
#pragma mark 买药提醒按钮方法
-(void)notificationBtnAction:(UIButton *)btn{
    NSLog(@"点击买药提醒按钮，%ld",btn.tag-100);
}

#pragma mark 立即购买按钮方法
-(void)immediateBuyBtnAction:(UIButton *)btn{
    NSLog(@"点击立即购买按钮,%ld",btn.tag-200);
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
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                collectionInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"myfavorlist"]];
                [myCollectionTabel reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
