//
//  MyAddressViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-11.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MyAddressViewController.h"
#import "RootTabBarController.h"
#import "MyAddressCell.h"
#import "EditAddressViewController.h"
@interface MyAddressViewController ()
{
    UITableView *myAddressTable;
    NSString *accesstoken;
    NSMutableArray *addressDataDic;
    int tagFlag;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation MyAddressViewController

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
    self.title = @"我的收货地址";
    
    
    myAddressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
    myAddressTable.delegate = self;
    myAddressTable.dataSource = self;
    myAddressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myAddressTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:myAddressTable];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.height, 50)];
    UIButton *newAddAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    newAddAddressBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [newAddAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [newAddAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newAddAddressBtn addTarget:self action:@selector(newAddAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    newAddAddressBtn.layer.cornerRadius = 5;
    [footview addSubview:newAddAddressBtn];
    myAddressTable.tableFooterView = footview;
    
    //注册xib
    [myAddressTable registerNib:[UINib nibWithNibName:@"MyAddressCell" bundle:nil] forCellReuseIdentifier:@"myAddressCell"];
}

-(void)requestAddressListData{
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/getRecieverAddress"];
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
    if (accesstoken.length > 0) {
        [self requestAddressListData];
    }
    
}


#pragma mark - waitForReciveTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return addressDataDic.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressCell *cell = (MyAddressCell *)[tableView dequeueReusableCellWithIdentifier:@"myAddressCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnActin:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = 200 + indexPath.section;
    [cell.editBtn addTarget:self action:@selector(editBtnActin:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = 300 + indexPath.section;
    cell.whiteView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    cell.whiteView.layer.borderWidth = 0.3;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //赋值
    if (addressDataDic.count > 0) {
        if ([addressDataDic[indexPath.section][@"isDefaultAddress"]isEqualToString:@"true"]) {
            [cell.defaultPic setImage:[UIImage imageNamed:@"hasSure"]];
        }else{
            [cell.defaultPic setImage:[UIImage imageNamed:@"waitForSure"]];
        }

        cell.reciverNameLabel.text = addressDataDic[indexPath.section][@"recieverName"];
        cell.telephoneNumLabel.text = addressDataDic[indexPath.section][@"contacePhone"];
        cell.detailAddressLabel.text = addressDataDic[indexPath.section][@"wholeAddress"];
    }
    
    return cell;
}




#pragma mark - action methods

#pragma mark 新增收货地址按钮方法
-(void)newAddAddressBtnAction:(UIButton *)btn{
    NSLog(@"点击新增收货地址按钮");
    EditAddressViewController *editView = [[EditAddressViewController alloc] init];
    editView.forNavTitle = @"新增收货地址";
    editView.flag = 2;
    [self.navigationController pushViewController:editView animated:YES];
}

-(void)requestDeleteAddressData:(int)tagFlag{
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"addressId":addressDataDic[tagFlag][@"addressId"]};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/deleteRecieverAddress"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
    
}


#pragma mark 删除按钮方法
-(void)deleteBtnActin:(UIButton *)btn{
    NSLog(@"点击删除按钮，btn.tag -200=%ld",btn.tag-200);
    tagFlag = (int)btn.tag-200;
    [self requestDeleteAddressData:tagFlag];
}

#pragma mark 编辑按钮方法
-(void)editBtnActin:(UIButton *)btn{
    NSLog(@"跳转到编辑地址页面，btn.tag -300=%ld",btn.tag-300);
    EditAddressViewController *editView = [[EditAddressViewController alloc] init];
    editView.forNavTitle = @"编辑收货地址";
    editView.flag = 1;
    editView.editDic = addressDataDic[btn.tag-300];
    [self.navigationController pushViewController:editView animated:YES];
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
                addressDataDic = [[NSMutableArray alloc] initWithArray:object[@"info"]];
                [myAddressTable reloadData];
                
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
                [addressDataDic removeObjectAtIndex:tagFlag];
                [myAddressTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
