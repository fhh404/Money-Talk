//
//  RemindViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import "RemindViewController.h"
#import "RootTabBarController.h"
#import "ReminderCell.h"
#import "AddNewNotifiyViewController.h"
#import "LoginViewController.h"
@interface RemindViewController ()
{
    UITableView *notificationTable;
    UIView *originalView;
    NSString *accesstoken;
    NSMutableArray *reminderArr;
    NSMutableDictionary *reminderDict;
    int number;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) AddNewNotifiyViewController *addNewNotifyVC;

@end

@implementation RemindViewController

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
    
    self.title = @"用药提醒";
    self.showMoreBtn = NO;
    
    //没有记录时显示的视图
    originalView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:originalView];
    
    UIImageView *notificationImage = [[UIImageView alloc] initWithFrame:CGRectMake(125, 125, 70, 70)];
    notificationImage.image = [UIImage imageNamed:@"notification"];
    [originalView addSubview:notificationImage];
    
    UILabel *notificLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 210, 180, 30)];
    notificLabel.text = @"您还未对药品创建用药提醒";
    notificLabel.textColor = [UIColor darkGrayColor];
    notificLabel.font = [UIFont fontWithName:@"Arial" size:14];
    notificLabel.textAlignment = NSTextAlignmentCenter;
    [originalView addSubview:notificLabel];
    
    UIButton *addNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 270, 120, 40)];
    [addNowBtn setTitle:@"现在添加" forState:UIControlStateNormal];
    [addNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addNowBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [addNowBtn addTarget:self action:@selector(addNotification:) forControlEvents:UIControlEventTouchUpInside];
    addNowBtn.tag = 1000;
    [originalView addSubview:addNowBtn];
    
    
    //提醒tableview
    notificationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40) style:UITableViewStyleGrouped];
    notificationTable.delegate = self;
    notificationTable.dataSource = self;
    notificationTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    notificationTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:notificationTable];
    

    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(addNotification:)];
    
    //注册xib
    [notificationTable registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil] forCellReuseIdentifier:@"reminderCell"];
    
    [self judge];
}

#pragma mark 用户提醒请求
-(void)requestReminderData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/MedicationRemind/CheckAllRemind"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root showTabBar];
    
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    NSLog(@"accesstoken=====%@",accesstoken);
    if (accesstoken.length > 0) {
        [self requestReminderData];
    }
    
}


#pragma mark - notificationTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [reminderArr[section][@"times"]count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return reminderArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:reminderArr[indexPath.section][@"times"][indexPath.row][@"medicals"]];

    NSString *tempStr;
    for (int i = 0; i < [tempArr count]; i++) {
        if (i == 0) {
           tempStr = [NSString stringWithFormat:@"%@ %@粒/次",tempArr[i][@"name"],tempArr[i][@"waytoeat"]];
        }else{
           tempStr = [NSString stringWithFormat:@"\n%@ %@粒/次",tempArr[i][@"name"],tempArr[i][@"waytoeat"]];
        }
    }
    
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [tempStr boundingRectWithSize:CGSizeMake(135, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (sizeText.height+40 > 100) {
        return sizeText.height+40;
    }else{
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReminderCell *cell = (ReminderCell *)[tableView dequeueReusableCellWithIdentifier:@"reminderCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:reminderArr[indexPath.section][@"times"][indexPath.row][@"medicals"]];
    //自适应label
    if ([tempArr count] > 0) {
        if ([tempArr[0][@"isRemind"]isEqualToString:@"true"] ) {
            cell.switchBtn.selected = YES;
            [cell.switchBtn setImage:[UIImage imageNamed:@"switchStart"] forState:UIControlStateNormal];
        }else{
            cell.switchBtn.selected = NO;
            [cell.switchBtn setImage:[UIImage imageNamed:@"switchStop"] forState:UIControlStateNormal];
        }
        if (tempArr.count == 1){
            cell.contentLabel.text = [NSString stringWithFormat:@"\n%@ %@粒/次",tempArr[0][@"name"],tempArr[0][@"waytoeat"]];//数据源
            cell.timeLabel.text = reminderArr[indexPath.section][@"times"][indexPath.row][@"medicaltime"];
        }else{
            NSString *tempStr;
            for (int i = 0; i < [tempArr count]; i++) {
                if (tempArr[i][@"name"] !=nil) {
                    if (tempStr == nil) {
                        tempStr = [NSString stringWithFormat:@"%@ %@粒/次",tempArr[i][@"name"],tempArr[i][@"waytoeat"]];
                    }else{
                        tempStr = [NSString stringWithFormat:@"\n%@ %@粒/次",tempArr[i][@"name"],tempArr[i][@"waytoeat"]];
                    }
                }
            }
            cell.contentLabel.text = tempStr;//数据源
            cell.timeLabel.text = reminderArr[indexPath.section][@"times"][indexPath.row][@"medicaltime"];
        }
    }
   
    cell.contentLabel.numberOfLines = 0;
    [cell.contentLabel sizeToFit];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(135, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cell.contentLabel.frame = CGRectMake(5, 40, 135, sizeText.height);
    
    
    
    [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.switchBtn.tag = indexPath.row + indexPath.section*10 + 100;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        UIView *headView = [[UIView alloc] init];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        backView.backgroundColor = [UIColor lightGrayColor];
        backView.alpha = 0.6;
        [headView addSubview:backView];
        
        UILabel *meLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 20)];
        meLabel.text = [NSString stringWithFormat:@"%@  |  %@",reminderArr[section][@"who"],reminderArr[section][@"disease"]];
        meLabel.textColor = [UIColor darkGrayColor];
        meLabel.textAlignment = NSTextAlignmentLeft;
        meLabel.font = [UIFont fontWithName:@"Arial" size:18];
        [backView addSubview:meLabel];
        
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 1, 40)];
        lineImage.image = [UIImage imageNamed:@"grayLine（vertical）"];
        lineImage.alpha = 0.5;
        [backView addSubview:lineImage];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = 200+section;
        deleteBtn.frame = CGRectMake(241, 0, 39, 40);
        [backView addSubview:deleteBtn];
    
        return headView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    AddNewNotifiyViewController *editInfo = [[AddNewNotifiyViewController alloc] init];
    editInfo.dataDic = [[NSDictionary alloc] initWithDictionary:reminderArr[indexPath.section]];
    editInfo.flag = 2;
    [self.navigationController pushViewController:editInfo animated:YES];
}



#pragma mark - Method
#pragma mark 现在添加按钮方法
-(void)addNotification:(UIButton *)btn{
    if (accesstoken.length > 0) {
        AddNewNotifiyViewController *addnew = [[AddNewNotifiyViewController alloc] init];
        addnew.flag = 1;
        [self.navigationController pushViewController:addnew animated:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}


#pragma mark 删除按钮方法
-(void)deleteBtnAction:(UIButton *)btn{
    NSLog(@"删除");
    number = (int)btn.tag-200;
    [self requestDeleteReminde:reminderArr[number][@"whoId"]];
}

#pragma mark 删除用户提醒请求
-(void)requestDeleteReminde:(NSString *)whoId{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/MedicationRemind/DeleteRemind"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"whoId":whoId};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}




#pragma mark 开关按钮方法
-(void)switchAction:(UIButton *)btn{
    ReminderCell *cell = (ReminderCell *)[notificationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag%10 inSection:(btn.tag-100)/10]];
    cell.switchBtn.selected = !cell.switchBtn.selected;
    NSString *remindStatus;
    if (cell.switchBtn.selected == YES) {
        remindStatus = @"0";
    }else if (cell.switchBtn.selected == NO){
        remindStatus = @"1";
    }
    
    [self requestOpenOrCloseReminde:reminderArr[(btn.tag-100)/10][@"whoId"] time:reminderArr[(btn.tag-100)/10][@"times"][btn.tag%10][@"medicaltime"] remindStatus:remindStatus];
}

#pragma mark 删除用户提醒请求（暂时不能用）
-(void)requestOpenOrCloseReminde:(NSString *)whoId time:(NSString *)time remindStatus:(NSString *)remindStatus{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/MedicationRemind/ChangeRemindStatus"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"whoId":whoId,@"time":time,@"remindStatus":remindStatus};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
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
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                reminderArr = [[NSMutableArray alloc] initWithArray:object[@"info"]];
                [self judge];
                [notificationTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
                originalView.hidden = NO;
                self.navigationItem.rightBarButtonItem = nil;
                notificationTable.hidden = YES;
            }
        }
        [[Loading shareLoading] endLoading];
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0] || [object[@"result"]intValue] == 0) {
                [self showToast:@"删除成功！"];
                [reminderArr removeObjectAtIndex:number];
                [self judge];
                [notificationTable reloadData];
                
            }else{
                [self showToast:object[@"msg"]];
            }
        }
        [[Loading shareLoading] endLoading];
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0] || [object[@"result"]intValue] == 0) {

                [notificationTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
        [[Loading shareLoading] endLoading];
    }
}

-(void)judge{
    if (reminderArr.count == 0) {
        originalView.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
        notificationTable.hidden = YES;
    }else {
        originalView.hidden = YES;
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        notificationTable.hidden = NO;
    }

}

@end
