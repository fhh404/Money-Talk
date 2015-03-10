//
//  AccountCenterViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AccountCenterViewController.h"
#import "RootTabBarController.h"
#import "AccountCenterCell.h"
#import "PostHeadImageViewController.h"
#import "NameChangeViewController.h"
#import "PassWordChangeViewController.h"

@interface AccountCenterViewController ()
{
    UITableView *accountCenterTabel;
    NSString *phone;
    NSString *nickName;
}


@end

@implementation AccountCenterViewController

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
    
    self.title = @"账号中心";
    
    //评价table
    accountCenterTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    accountCenterTabel.delegate = self;
    accountCenterTabel.dataSource = self;
    accountCenterTabel.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:accountCenterTabel];
    
    //注册XIB
    [accountCenterTabel registerNib:[UINib nibWithNibName:@"AccountCenterCell" bundle:nil] forCellReuseIdentifier:@"accountCenter"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    phone = [[MyUserDefaults defaults] readFromUserDefaults:@"phone"];
    nickName = [[MyUserDefaults defaults] readFromUserDefaults:@"nickName"];
    [accountCenterTabel reloadData];
    
}



#pragma mark - accountCenterTabel_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 90;
    }
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *imageArr = @[@"name",@"password",@"bindTelephone"];
    NSArray *itemArr = @[@"昵称:",@"密码:",@"绑定手机:"];
    NSArray *contentArr = @[nickName,@"*********",phone];
    
    AccountCenterCell *cell = (AccountCenterCell *)[tableView dequeueReusableCellWithIdentifier:@"accountCenter"];
    cell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.contentLabel.text = contentArr[indexPath.row];
    cell.itemLabel.text = itemArr[indexPath.row];
    
    if (indexPath.row == 2) {
        cell.itemLabel.frame = CGRectMake(55, 15, 120, 20);
        cell.contentLabel.frame = CGRectMake(185, 15, 135, 20);
        cell.editBtn.hidden = YES;
    }else{
        cell.itemLabel.frame = CGRectMake(55, 15, 50, 20);
        cell.contentLabel.frame = CGRectMake(125, 15, 125, 20);
        [cell.editBtn addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.editBtn.tag = 100 + indexPath.row;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] init];
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-65, 40, 130, 130)];
        headImage.image = [UIImage imageNamed:@"headportrait"];
        headImage.userInteractionEnabled = YES;
        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap:)]];
        [headerView addSubview:headImage];
        return headerView;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        UIButton *logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 50)];
        logOutBtn.backgroundColor = [UIColor whiteColor];
        [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOutBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [logOutBtn addTarget:self action:@selector(logOutAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logOutBtn];
        return footerView;
    }
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    
}

#pragma mark - Method

#pragma mark 退出登录按钮方法
-(void)logOutAction:(UIButton *)btn{
    NSLog(@"点击退出登录按钮");
    [self showToast:@"退出登录成功！"];
    [[MyUserDefaults defaults] saveToUserDefaults:@"" withKey:@"accesstoken"];
    [[MyUserDefaults defaults] saveToUserDefaults:@"No" withKey:@"isLogin"];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 编辑按钮方法
-(void)editBtn:(UIButton *)btn{
    switch (btn.tag ) {
        case 100:
        {
            NSLog(@"跳转到昵称修改页面");
            NameChangeViewController *nameChange = [[NameChangeViewController alloc] init];
            [self.navigationController pushViewController:nameChange animated:YES];
        }
            break;
        case 101:
        {
            NSLog(@"跳转到密码修改页面");
            PassWordChangeViewController *passWordChange = [[PassWordChangeViewController alloc] init];
            [self.navigationController pushViewController:passWordChange animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark 头像点击方法
-(void)headImageTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到头像上传页面");
    PostHeadImageViewController *postHeadImage = [[PostHeadImageViewController alloc] init];
    [self.navigationController pushViewController:postHeadImage animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
