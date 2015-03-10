//
//  AddNewNotifiyViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AddNewNotifiyViewController.h"
#import "RootTabBarController.h"
#import "AccountInfoCell.h"
#import "AddDrugCell.h"
#import "CycleContentCell.h"
#import "FooterViewCell.h"
#import "DrugCell.h"
#import "SBJson4.h"
#import "SBJson4Writer.h"
//动画时间
#define kAnimationDuration 0.2
@interface AddNewNotifiyViewController ()
{
    UITableView *addNewNotifyTabel;
    int drugNumber;
    UIToolbar * topView;
    
    UIView *alphaView;
    UITableView *drugTable;
    UITextField *drugNameField;
    UIView *alphaPickerView;
    UIPickerView *pickerView1;
    NSMutableArray *dayArr;
    NSMutableArray *monthArr;
    NSMutableArray *yearArr;
    int currentYear;
    int currentMonth;
    int currentDay;
    UIPickerView *pickerView2;
    NSArray *repeatesArr;
    UIPickerView *pickerView3;
    NSMutableArray *timeArr;
    NSString *yearTxt;
    NSString *monthTxt;
    NSString *dayTxt;
    NSString *frequencyTxt;
    NSString *fristUseTime;
    NSString *secondUseTime;
    NSString *thirdUseTime;
    NSString *fourthUseTime;
    NSString *drugNameTxt;
    NSArray *arr;//假数据源
    int flagNumber;//判断是否新增药品cell
    int gesutreTag;//判断具体要更改名称的药品
    int usetTimeFlag;//判断具体要更改用药时间的cell
    
    //请求参数
    NSString *accesstoken;
    NSString *nameStr;
    NSString *diseaseStr;
    NSString *frequenStr;
    NSString *endDayStr;
    NSString *startDayStr;
    NSString *remindWay;
    NSString *phoneNumberStr;
    NSMutableArray *medicationsArr;
    
    NSMutableArray *alreadyBuys;
    NSMutableArray *myCollections;
    UIView *clearView;
    
    NSMutableArray *drugArr;
    NSMutableArray *drugNameArr;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation AddNewNotifiyViewController
@synthesize flag,dataDic;
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
    
    self.title = @"新增提醒";
    
    //获取当前的日期
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    startDayStr = [formatter stringFromDate:date];
    
    //通过字符“-”将日期分成年月日并放入数组
    NSArray *dateArr = [startDayStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    currentYear =[dateArr[0] intValue];
    currentMonth = [dateArr[1] intValue];
    currentDay = [dateArr[2] intValue];
    
    
    
    drugNumber = 1;
    
    addNewNotifyTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    addNewNotifyTabel.delegate = self;
    addNewNotifyTabel.dataSource = self;
    addNewNotifyTabel.tag = 2001;
    addNewNotifyTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    addNewNotifyTabel.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:addNewNotifyTabel];
    
    
    //注册xib
    [addNewNotifyTabel registerNib:[UINib nibWithNibName:@"AccountInfoCell" bundle:nil] forCellReuseIdentifier:@"accountInfoCell"];
    [addNewNotifyTabel registerNib:[UINib nibWithNibName:@"AddDrugCell" bundle:nil] forCellReuseIdentifier:@"addDrugCell"];
    [addNewNotifyTabel registerNib:[UINib nibWithNibName:@"CycleContentCell" bundle:nil] forCellReuseIdentifier:@"CycleCell"];
    [addNewNotifyTabel registerNib:[UINib nibWithNibName:@"FooterViewCell" bundle:nil] forCellReuseIdentifier:@"footerCell"];
    
    
    //给键盘添加收回按钮
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];

    medicationsArr = [[NSMutableArray alloc] init];
    drugArr = [[NSMutableArray alloc] init];
    drugNameArr = [[NSMutableArray alloc] init];
    [drugNameArr addObject:@""];
    NSLog(@"drugNameArr====%@",drugNameArr);
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    [self dealWithDataDic];
    
     
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
}

-(void)dealWithDataDic{
    NSLog(@"self.dataDic=======%@",self.dataDic);
    if (self.dataDic != nil) {
        //数据处理
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        [tempArr removeAllObjects];
        for (int j = 0; j < [self.dataDic[@"times"]count]; j++) {
            int number = (int)[self.dataDic[@"times"][j][@"medicals"]count];
            for (int k = 0; k < number; k++) {
                NSString *tempStr1 = self.dataDic[@"times"][j][@"medicals"][k][@"name"];
                NSString *tempStr2 = self.dataDic[@"times"][j][@"medicaltime"];
                NSString *tempStr3 = self.dataDic[@"times"][j][@"medicals"][k][@"waytoeat"];
                NSDictionary *dict = @{@"name":tempStr1,@"time":tempStr2,@"waytoeat":tempStr3};
                [tempArr insertObject:dict atIndex:0];
            }
        }
        NSArray *dataArr = [NSArray arrayWithObject:tempArr];
        NSMutableArray *lastArr = [NSMutableArray arrayWithObject:[self deleteSameObject:dataArr[0]]];
        NSLog(@"lastArr====%@",lastArr[0]);
        
        
        [drugArr removeAllObjects];
        for (int i = 0; i < [lastArr[0] count]; i++) {
            NSString *timeStr;
            for (int j = 0; j < [lastArr[0][i]count]; j++) {
                if (timeStr != nil) {
                    timeStr = [NSString stringWithFormat:@"%@ %@",lastArr[0][i][j][@"time"],timeStr];
                }else{
                    timeStr = [NSString stringWithFormat:@"%@",lastArr[0][i][j][@"time"]];
                }
            }
            NSDictionary *dict = @{@"name":lastArr[0][i][0][@"name"],@"time":timeStr,@"waytoeat":lastArr[0][i][0][@"waytoeat"]};
            [drugArr insertObject:dict atIndex:0];
        }
        NSLog(@"drugArr====%@",drugArr);
    }
}

//实现方法：
-(NSMutableArray *)deleteSameObject:(NSArray *)array1{
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    NSMutableArray *array = [NSMutableArray arrayWithArray:array1];
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i][@"name"];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:array[i]];
        for (int j = i+1; j < array.count; j++) {
            NSString *jstring = array[j][@"name"];
            if([string isEqualToString:jstring]){
                [tempArray addObject:array[j]];
                [array removeObjectAtIndex:j];
                j--;
            }
        }
        [dateMutablearray addObject:tempArray];
    }
//    NSLog(@"array:%@",array);//将不同的存入一个数组
    NSLog(@"dateMutable:%@",dateMutablearray);//将相同的存入一个数组
    return dateMutablearray;
}




#pragma mark - addNewNotifyTabel_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2000:
        {
            if (section == 0) {
                return alreadyBuys.count;
            }else if (section == 1){
                return myCollections.count;
            }
        }
            break;
        case 2001:
        {
            if (section == 1){
                if (self.flag == 2) {
                    return drugArr.count;
                }
                return drugNameArr.count;
            }
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
        case 2000:
        {
            return 2;
        }
            break;
        case 2001:
        {
            return 4;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 2000:
        {
            return 30;
        }
            break;
        case 2001:
        {
            if (indexPath.section == 3){
                return 200;
            }
            return 80;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2000:
        {
            if (section == 0 || section == 1) {
                return 50;
            }
            return 15;
        }
            break;
        case 2001:
        {
            if (section == 3) {
                return 1;
            }
            return 10;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2000:
        {
            return 5;
        }
            break;
        case 2001:
        {
            if (section == 3) {
                return 1;
            }else if (section == 1){
                return 45;
            }
            return 5;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 2000:
        {
            
            DrugCell *cell = (DrugCell *)[tableView dequeueReusableCellWithIdentifier:@"drugCell"];
            [cell.singleBtn addTarget:self action:@selector(singleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.singleBtn.tag = 200 + indexPath.row + 10*indexPath.section;
            if (indexPath.section == 0) {
                cell.drugNameLabel.text = alreadyBuys[indexPath.row][@"name"];
            }else{
                cell.drugNameLabel.text = myCollections[indexPath.row][@"name"];
            }
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }
            break;
        case 2001:
        {
            if (indexPath.section == 0) {
                AccountInfoCell *cell_account = (AccountInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"accountInfoCell"];
                cell_account.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                cell_account.selectionStyle = UITableViewCellSelectionStyleNone;
                cell_account.diseaseField.inputAccessoryView = topView;
                cell_account.contentField.inputAccessoryView = topView;
                if (self.flag == 2) {
                    cell_account.diseaseField.text = self.dataDic[@"disease"];
                    cell_account.contentField.text = self.dataDic[@"who"];
                }
                return cell_account;
            }else if (indexPath.section == 1){
                AddDrugCell *cell_adddrug = (AddDrugCell *)[tableView dequeueReusableCellWithIdentifier:@"addDrugCell"];
                cell_adddrug.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                cell_adddrug.selectionStyle = UITableViewCellSelectionStyleNone;
                cell_adddrug.drugNameLabel.userInteractionEnabled = YES;
                [cell_adddrug.drugNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useDrugTime:)]];
                cell_adddrug.drugNameLabel.tag = indexPath.row;
                [cell_adddrug.useDrugtimeBtn addTarget:self action:@selector(useDrugtimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell_adddrug.useDrugtimeBtn.tag = 1000+indexPath.row;
                cell_adddrug.numberField.inputAccessoryView = topView;
                cell_adddrug.numberField.tag = 100 + indexPath.row;
                if (self.flag == 2) {
                    cell_adddrug.numberField.text = drugArr[indexPath.row][@"waytoeat"];
                    cell_adddrug.drugNameLabel.text = drugArr[indexPath.row][@"name"];
                    cell_adddrug.timeLabel.text = drugArr[indexPath.row][@"time"];
                }else if (self.flag == 1){
                    cell_adddrug.drugNameLabel.text = drugNameArr[indexPath.row];
                }
                return cell_adddrug;
            }else if (indexPath.section == 2){
                CycleContentCell *cell_cycle = (CycleContentCell *)[tableView dequeueReusableCellWithIdentifier:@"CycleCell"];
                cell_cycle.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                cell_cycle.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell_cycle.daysBtn addTarget:self action:@selector(daysBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell_cycle.dateCycleBtn addTarget:self action:@selector(dateCycleBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell_cycle.currentDayLabel.text = startDayStr;
                if (self.flag == 2) {
                    cell_cycle.currentDayLabel.text = self.dataDic[@"startDay"];
                    cell_cycle.endDateLabel.text = self.dataDic[@"endDay"];
                    NSString *daysStr;
                    if ([self.dataDic[@"repeatRemindDay"]intValue] == 0) {
                        daysStr = @"每天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 1){
                        daysStr = @"每两天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 2){
                        daysStr = @"每三天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 3){
                        daysStr = @"每四天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 4){
                        daysStr = @"每五天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 5){
                        daysStr = @"每六天";
                    }else if ([self.dataDic[@"repeatRemindDay"]intValue] == 6){
                        daysStr = @"每七天";
                    }
                    cell_cycle.daysLabel.text = daysStr;
                }
                return cell_cycle;
            }else if (indexPath.section == 3){
                FooterViewCell *cell_foot= (FooterViewCell *)[tableView dequeueReusableCellWithIdentifier:@"footerCell"];
                cell_foot.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                cell_foot.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell_foot.newsBtn addTarget:self action:@selector(newsNotifyBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell_foot.messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell_foot.sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell_foot.sureBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                cell_foot.tipsView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                cell_foot.fieldBackView.backgroundColor = [UIColor whiteColor];
                cell_foot.tipsView.hidden  = YES;
                cell_foot.sureBtn.frame = CGRectMake(20, 75, 280, 40);
                cell_foot.telephoneNumberField.inputAccessoryView = topView;
                if (self.flag == 2) {
                    if ([self.dataDic[@"remindWay"]intValue] == 0) {
                        cell_foot.newsBtn.selected = YES;
                        cell_foot.tipsView.hidden = YES;
                        cell_foot.sureBtn.frame = CGRectMake(20, 75, 280, 40);
                        [cell_foot.newsBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
                    }else{
                        cell_foot.messageBtn.selected = YES;
                        cell_foot.tipsView.hidden = NO;
                        cell_foot.sureBtn.frame = CGRectMake(20, 155, 280, 40);
                        [cell_foot.messageBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
                        cell_foot.telephoneNumberField.text = self.dataDic[@"phone"];
                    }
                }
                return cell_foot;
            }
            
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2001:
        {
            if (section == 1) {
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
                UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
                whiteView.backgroundColor = [UIColor whiteColor];
                [view addSubview:whiteView];
                
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(90, 0, 140, 40);
                [addBtn setImage:[UIImage imageNamed:@"add_notific"] forState:UIControlStateNormal];
                addBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 100);
                [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [whiteView addSubview:addBtn];
                
                
                UILabel *addlabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 60, 20)];
                addlabel.text = @"添加药品";
                addlabel.textAlignment = NSTextAlignmentCenter;
                addlabel.font = [UIFont fontWithName:@"Arial" size:14];
                addlabel.textColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
                [whiteView addSubview:addlabel];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
                lineImageView.image = [UIImage imageNamed:@"grayLine"];
                lineImageView.alpha = 0.5;
                [whiteView addSubview:lineImageView];
                return view;
            }
            
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2000:
        {
            if (section == 0) {
                UIView *view1 = [[UIView alloc] init];
                view1.backgroundColor = [UIColor whiteColor];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
                titleLabel.text = @"已购买药品";
                titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                titleLabel.textColor = [UIColor darkGrayColor];
                [view1 addSubview:titleLabel];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 49, 240, 1)];
                lineImageView.image = [UIImage imageNamed:@"grayLine"];
                lineImageView.alpha = 0.5;
                [view1 addSubview:lineImageView];
                return view1;
            }else if (section == 1){
                UIView *view2 = [[UIView alloc] init];
                view2.backgroundColor = [UIColor whiteColor];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
                titleLabel.text = @"我的收藏";
                titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                titleLabel.textColor = [UIColor darkGrayColor];
                [view2 addSubview:titleLabel];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 49, 240, 1)];
                lineImageView.image = [UIImage imageNamed:@"grayLine"];
                lineImageView.alpha = 0.5;
                [view2 addSubview:lineImageView];
                return view2;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}





#pragma mark - pickers视图
-(void)getUseTimePicker{
    
    alphaPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    alphaPickerView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.75];
    [alphaPickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPickerAction:)]];
    [self.view addSubview:alphaPickerView];
    
    
    
    
    pickerView3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-180-64, 320, 200)];
    pickerView3.delegate = self;
    pickerView3.dataSource = self;
    pickerView3.tag = 802;
    pickerView3.backgroundColor = [UIColor whiteColor];
    [alphaPickerView addSubview:pickerView3];
    
    timeArr = [[NSMutableArray alloc] init];
    
    int flagTime1 = 0;
    for (int i = 0; i < 17; i++) {
        if (i%2==0) {
            NSString *str = [NSString stringWithFormat:@"%d:00",flagTime1];
            [timeArr addObject:str];
        }else if (i%2 == 1){
            
            NSString *str = [NSString stringWithFormat:@"%d:30",flagTime1];
            [timeArr addObject:str];
            flagTime1++;
        }
    }
    
    NSString *kongstr = @"无";
    [timeArr insertObject:kongstr atIndex:timeArr.count-1];
    
    int flagTime = 8;
    for (int i = 0; i < 31; i++) {
        if (i%2==0) {
            NSString *str = [NSString stringWithFormat:@"%d:30",flagTime];
            [timeArr addObject:str];
            flagTime++;
        }else if (i%2 == 1){
            
            NSString *str = [NSString stringWithFormat:@"%d:00",flagTime];
            [timeArr addObject:str];
            
        }
    }
    
    [pickerView3 selectRow:17 inComponent:0 animated:YES];
    [pickerView3 selectRow:31 inComponent:1 animated:YES];
    [pickerView3 selectRow:31 inComponent:2 animated:YES];
    [pickerView3 selectRow:31 inComponent:3 animated:YES];
    
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, [UIScreen mainScreen].bounds.size.height-270-64, 50, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.tag = 502;
    [cancleBtn addTarget:self action:@selector(canclePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:cancleBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, [UIScreen mainScreen].bounds.size.height-270-64, 50, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    sureBtn.tag = 602;
    [sureBtn addTarget:self action:@selector(surePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:sureBtn];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-230-64, [UIScreen mainScreen].bounds.size.width, 50)];
    backview.backgroundColor = [UIColor darkGrayColor];
    [alphaPickerView addSubview:backview];
    NSArray *headArr = @[@"第一次",@"第二次",@"第三次",@"第四次"];
    for (int i = 0; i < 4; i++) {
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 +70*i, 15, 70, 20)];
        headLabel.text = headArr[i];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [backview addSubview:headLabel];
    }
    
}





-(void)getRepeatsPicker{
    repeatesArr = @[@"每天",@"每两天",@"每三天",@"每四天",@"每五天",@"每六天",@"每七天"];
    
    alphaPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    alphaPickerView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.75];
    [alphaPickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPickerAction:)]];
    [self.view addSubview:alphaPickerView];
    
    pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-180-64, 320, 200)];
    pickerView2.delegate = self;
    pickerView2.dataSource = self;
    pickerView2.tag = 801;
    pickerView2.backgroundColor = [UIColor whiteColor];
    [alphaPickerView addSubview:pickerView2];
    
    
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, [UIScreen mainScreen].bounds.size.height-220-64, 50, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.tag = 501;
    [cancleBtn addTarget:self action:@selector(canclePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:cancleBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, [UIScreen mainScreen].bounds.size.height-220-64, 50, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    sureBtn.tag = 601;
    [sureBtn addTarget:self action:@selector(surePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:sureBtn];
    
}


-(void)getDatePicker{
    
    
    dayArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 32; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [dayArr addObject:str];
    }
    
    monthArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 13; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [monthArr addObject:str];
    }
    
    yearArr = [[NSMutableArray alloc] init];
    for (int i = 2013; i < 2021; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [yearArr addObject:str];
    }
    
    
    alphaPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    alphaPickerView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.75];
    [alphaPickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPickerAction:)]];
    [self.view addSubview:alphaPickerView];
    
    pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-180-64, 320, 200)];
    pickerView1.delegate = self;
    pickerView1.dataSource = self;
    pickerView1.tag = 800;
    pickerView1.backgroundColor = [UIColor whiteColor];
    [alphaPickerView addSubview:pickerView1];
    
    [pickerView1 selectRow:currentYear-2013 inComponent:0 animated:YES];
    [pickerView1 selectRow:currentMonth-1 inComponent:1 animated:YES];
    [pickerView1 selectRow:currentDay-1 inComponent:2 animated:YES];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, [UIScreen mainScreen].bounds.size.height-220-64, 50, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.tag = 500;
    [cancleBtn addTarget:self action:@selector(canclePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:cancleBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, [UIScreen mainScreen].bounds.size.height-220-64, 50, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    sureBtn.tag = 600;
    [sureBtn addTarget:self action:@selector(surePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [alphaPickerView addSubview:sureBtn];
    
}



#pragma mark 取消按钮方法
-(void)canclePickerAction:(UIButton *)btn{
    NSLog(@"取消指示器");
    switch (btn.tag) {
        case 500:
        {
            [alphaPickerView removeFromSuperview];
        }
            break;
        case 501:
        {
            [alphaPickerView removeFromSuperview];
        }
            break;
        case 502:
        {
            [alphaPickerView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

#pragma mark 确定按钮方法
-(void)surePickerAction:(UIButton *)btn{
    NSLog(@"确定指示器");
    switch (btn.tag) {
        case 600:
        {
            if (yearTxt == NULL) {
                yearTxt = yearArr[currentYear-2013];
            }
            if (monthTxt == NULL){
                monthTxt = monthArr[currentMonth-1];
            }
            if (dayTxt == NULL){
                dayTxt = dayArr[currentDay-1];
            }
            CycleContentCell *cell_cycle = (CycleContentCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            cell_cycle.endDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",yearTxt,monthTxt,dayTxt];
            [alphaPickerView removeFromSuperview];
        }
            break;
        case 601:
        {
            if (frequencyTxt == NULL) {
                frequencyTxt = @"每天";
            }
            CycleContentCell *cell_cycle = (CycleContentCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            cell_cycle.daysLabel.text = frequencyTxt;
            [alphaPickerView removeFromSuperview];
        }
            break;
        case 602:
        {
            if (fristUseTime == NULL) {
                fristUseTime = @"8:00";
            }else if ([fristUseTime isEqualToString:@"无"]) {
                fristUseTime = @"";
            }
            if (secondUseTime == NULL){
                secondUseTime = @"15:00";
            }else if ([secondUseTime isEqualToString:@"无"]) {
                secondUseTime = @"";
            }
            if (thirdUseTime == NULL){
                thirdUseTime = @"15:00";
            }else if ([thirdUseTime isEqualToString:@"无"]) {
                thirdUseTime = @"";
            }
            if (fourthUseTime == NULL){
                fourthUseTime = @"15:00";
            }else if ([fourthUseTime isEqualToString:@"无"]) {
                fourthUseTime = @"";
            }
            
            AddDrugCell *cell_addDrug = (AddDrugCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:usetTimeFlag inSection:1]];
            cell_addDrug.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",fristUseTime,secondUseTime,thirdUseTime,fourthUseTime];
            [alphaPickerView removeFromSuperview];
            
        }
            break;
        default:
            break;
    }
}



#pragma mark PickerView_delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (pickerView.tag) {
        case 800:
        {
            return 3;
        }
            break;
        case 801:
        {
            return 1;
        }
            break;
        case 802:
        {
            return 4;
        }
            break;
        default:
            break;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 800:
        {
            if (component == 0) {
                return 8;
            }else if (component == 1){
                return 12;
            }
            return 31;
        }
            break;
        case 801:
        {
            return 7;
        }
            break;
        case 802:
        {
            return 49;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 800:
        {
            if (component == 0) {
                return 100;
            }
            return 70;
        }
            break;
        case 801:
        {
            return 120;
        }
            break;
        case 802:
        {
            return 70;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"row===%d,component==%d",(int)row,(int)component);
    switch (pickerView.tag) {
        case 800:
        {
            NSString *str1;
            NSString *str2;
            NSString *str3;
            
            if (component == 0) {
                str1 = yearArr[row];
            }else if (component == 1){
                str2 = monthArr[row];
            }else if (component == 2){
                str3 = dayArr[row];
            }
            
            if (str2 == NULL && str3 == NULL && str1 != NULL) {
                yearTxt = str1;
            }else if (str1 == NULL && str3 == NULL && str2 != NULL){
                monthTxt = str2;
            }else if (str1 == NULL && str2 == NULL && str3 != NULL){
                dayTxt = str3;
            }
        }
            break;
        case 801:
        {
            frequencyTxt = repeatesArr[row];
            NSLog(@"frequencyTxt===%@",frequencyTxt);
        }
            break;
        case 802:
        {
            NSString *str1;
            NSString *str2;
            NSString *str3;
            NSString *str4;
            
            if (component == 0) {
                str1 = timeArr[row];
            }else if (component == 1){
                str2 = timeArr[row];
            }else if (component == 2){
                str3 = timeArr[row];
            }else if (component == 3){
                str4 = timeArr[row];
            }
            
            
            if (str2 == NULL && str3 == NULL && str4 == NULL && str1 != NULL) {
                fristUseTime = str1;
            }else if (str1 == NULL && str3 == NULL && str4 == NULL && str2 != NULL){
                secondUseTime = str2;
            }else if (str1 == NULL && str2 == NULL && str4 == NULL && str3 != NULL){
                thirdUseTime = str3;
            }else if (str1 == NULL && str2 == NULL && str3 == NULL && str4 != NULL){
                fourthUseTime = str4;
            }
            
            
        }
            break;
        default:
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 800:
        {
            if (component == 0) {
                return yearArr[row];
            }else if (component == 1){
                return monthArr[row];
            }else if (component == 2){
                return dayArr[row];
            }
        }
            break;
        case 801:
        {
            return repeatesArr[row];
        }
            break;
        case 802:
        {
            return timeArr[row];
        }
            break;
        default:
            break;
    }
    
    return 0;
}





#pragma mark - Method
#pragma mark 键盘方法
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    FooterViewCell *cell_foot = (FooterViewCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    //调整放置有输入框的view的位置
    if ([cell_foot.telephoneNumberField isFirstResponder]) {
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
        UITableView *table = (UITableView *)[self.view viewWithTag:2001];
        table.contentOffset = CGPointMake(0, table.frame.size.height-200+80);
        [UIView commitAnimations];
    }else if ([drugNameField isFirstResponder]){
        drugNameTxt = @"";
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        CGFloat height;
        if (drugTable.hidden == NO) {
            height = -220;
        }else{
            height = -140;
        }
        //设置view的frame，往上平移
        [(UIScrollView *)[self.view viewWithTag:3000] setFrame:CGRectMake(0, height, 320, [UIScreen mainScreen].bounds.size.height+150)];//keyboardRect.size.height-kViewHeight
        [UIView commitAnimations];
    }
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    UITableView *table = (UITableView *)[self.view viewWithTag:2001];
    table.contentOffset = CGPointMake(0,80);
    [(UIScrollView *)[self.view viewWithTag:3000] setFrame:alphaView.bounds];
    [UIView commitAnimations];
}





-(void)creatAddDrugView{
    alphaView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.75];
    [alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self.view addSubview:alphaView];
    
    UIScrollView *scrollowAddDrug = [[UIScrollView alloc] initWithFrame:alphaView.frame];
    scrollowAddDrug.backgroundColor = [UIColor clearColor];
    scrollowAddDrug.tag = 3000;
    scrollowAddDrug.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [alphaView addSubview:scrollowAddDrug];
    
    drugTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, 280, 280) style:UITableViewStyleGrouped];
    drugTable.delegate = self;
    drugTable.dataSource = self;
    drugTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    drugTable.tag = 2000;
    drugTable.backgroundColor = [UIColor whiteColor];
    [scrollowAddDrug addSubview:drugTable];
    //注册xib
    [drugTable registerNib:[UINib nibWithNibName:@"DrugCell" bundle:nil] forCellReuseIdentifier:@"drugCell"];
    
    
    
    clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 180)];
    clearView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.75];
    [scrollowAddDrug addSubview:clearView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [clearView addSubview:whiteView];
    
    drugNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 180, 30)];
    drugNameField.borderStyle = UITextBorderStyleNone;
    drugNameField.placeholder = @"输入需要提醒的药品";
    drugNameField.font = [UIFont fontWithName:@"Arial" size:14];
    drugNameField.tag = 400;
    [whiteView addSubview:drugNameField];
    
    UIButton *saomiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saomiaoBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [saomiaoBtn setImage:[UIImage imageNamed:@"drugSaomiao"] forState:UIControlStateNormal];//扫描按钮
    saomiaoBtn.frame = CGRectMake(240, 20, 40, 40);
    [saomiaoBtn addTarget:self action:@selector(saomiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:saomiaoBtn];
    
    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 270, 40)];
    flagLabel.numberOfLines = 0;
    flagLabel.text = @"药箱没有的药物可直接输入,之后系统将加入到您的药箱";
    flagLabel.font = [UIFont fontWithName:@"Arial" size:14];
    flagLabel.textAlignment = NSTextAlignmentJustified;
    flagLabel.textColor = [UIColor whiteColor];
    [clearView addSubview:flagLabel];
    
    
    UIButton *addSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
    addSureBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [addSureBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [addSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addSureBtn addTarget:self action:@selector(addSureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    addSureBtn.tag = gesutreTag;
    [clearView addSubview:addSureBtn];
    
    
    //给键盘添加收回按钮
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, alphaView.frame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard2)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView1 setItems:buttonsArray];
    
    drugNameField.inputAccessoryView = topView1;
    
    [self requestDrugInfoData];
}

#pragma mark 添加用户提醒请求
-(void)requestDrugInfoData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/MedicationRemind/getMedicationName"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:POST tag:200];
}


-(void)dismissKeyBoard2{
    [drugNameField resignFirstResponder];

}


#pragma mark 点击药品弹出视图方法
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击药品弹出视图");
    [alphaView removeFromSuperview];
}

#pragma mark 点击指示器弹出视图方法
-(void)tapPickerAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击指示器弹出视图");
    [alphaPickerView removeFromSuperview];
}

#pragma mark 扫描按钮方法
-(void)saomiaoAction:(UIButton *)btn{
    NSLog(@"点击扫描按钮");
}

#pragma mark 添加药品确认按钮方法
-(void)addSureBtnAction:(UIButton *)btn{
    NSLog(@"点击药品确认按钮");
    
    if (self.flag == 2) {
        NSLog(@"drugNameField.text====%@,drugNameTxt===%@",drugNameField.text,drugNameTxt);
        if (drugNameTxt.length > 0 && drugNameField.text.length == 0) {
            NSDictionary *dict = @{@"name":drugNameTxt};
            [drugArr insertObject:dict atIndex:0];
            [alphaView removeFromSuperview];
            [addNewNotifyTabel reloadData];
        }else if(drugNameField.text.length > 0 && drugNameTxt.length == 0){
            NSDictionary *dict = @{@"name":drugNameField.text};
            [drugArr insertObject:dict atIndex:0];
            [alphaView removeFromSuperview];
            [addNewNotifyTabel reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个药品或输入要提醒的药品名称！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }else{
        NSLog(@"drugNameField.text====%@,drugNameTxt===%@",drugNameField.text,drugNameTxt);
        if (drugNameTxt.length > 0 && drugNameField.text.length == 0) {
            [alphaView removeFromSuperview];
            if (flagNumber == 2) {
                [drugNameArr insertObject:drugNameTxt atIndex:0];
            }else if(flagNumber == 1){
                [drugNameArr replaceObjectAtIndex:btn.tag withObject:drugNameTxt];
            }
            [addNewNotifyTabel reloadData];
            
        }else if (drugNameTxt.length == 0 && drugNameField.text.length > 0){
            [alphaView removeFromSuperview];
            if (flagNumber == 2) {
                [drugNameArr insertObject:drugNameField.text atIndex:0];
            }else if(flagNumber == 1){
                [drugNameArr replaceObjectAtIndex:btn.tag withObject:drugNameField.text];
            }
            [addNewNotifyTabel reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个药品或输入要提醒的药品名称！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }
    
}


#pragma mark 复选按钮方法
-(void)singleBtnAction:(UIButton *)btn{
    NSLog(@"点击cell的复选按钮，btn.tag-200====%d",(int)btn.tag-200);
    int number_row = (int)(btn.tag-200)%10;
    int number_section = (int)(btn.tag-200)/10;
    NSLog(@"number_section====%d,number_row====%d",number_section,number_row);
    DrugCell *cell = (DrugCell *)[drugTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number_row inSection:number_section]];
    cell.singleBtn.selected = !cell.singleBtn.selected;
    if (cell.singleBtn.selected == YES) {
        [cell.singleBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
        if (number_section == 0) {
            drugNameTxt = alreadyBuys[number_row][@"name"];
        }else{
            drugNameTxt = myCollections[number_row][@"name"];
        }
        
    }else if (cell.singleBtn.selected == NO){
        [cell.singleBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
        drugNameTxt = NULL;
    }
}



#pragma mark 添加药品按钮方法
-(void)addBtnAction:(UIButton *)btn{
    NSLog(@"点击添加药品按钮");
    flagNumber = 2;
    [self creatAddDrugView];
}

#pragma mark 药品名称tap手势
-(void)useDrugTime:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击添加药品按钮");
    flagNumber = 1;
    gesutreTag = (int)gesture.view.tag;
    NSLog(@"gesutreTag===%d",gesutreTag);
    [self creatAddDrugView];
}

#pragma mark 用药时间按钮方法
-(void)useDrugtimeBtnAction:(UIButton *)btn{
    NSLog(@"点击用药时间按钮");
    usetTimeFlag = (int)btn.tag - 1000;
    [self getUseTimePicker];
}

#pragma mark 频率按钮方法
-(void)daysBtnAction:(UIButton *)btn{
    NSLog(@"点击重复次数按钮");
    [self getRepeatsPicker];
    
}

#pragma mark 起止时间按钮方法
-(void)dateCycleBtn:(UIButton *)btn{
    NSLog(@"点击结束日期按钮");
    [self getDatePicker];
}

#pragma mark 消息提醒按钮方法
-(void)newsNotifyBtn:(UIButton *)btn{
    FooterViewCell *cell_foot = (FooterViewCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    cell_foot.newsBtn.selected = !cell_foot.newsBtn.selected;
    if (cell_foot.newsBtn.selected == YES) {
        cell_foot.tipsView.hidden = YES;
        cell_foot.sureBtn.frame = CGRectMake(20, 75, 280, 40);
        [cell_foot.newsBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
        
    }else if (cell_foot.newsBtn.selected == NO){
        [cell_foot.newsBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    }
    cell_foot.messageBtn.selected = NO;
    [cell_foot.messageBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
}

#pragma mark 短信提醒按钮方法
-(void)messageBtnAction:(UIButton *)btn{
    FooterViewCell *cell_foot = (FooterViewCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    cell_foot.messageBtn.selected = !cell_foot.messageBtn.selected;
    if (cell_foot.messageBtn.selected == YES) {
        cell_foot.tipsView.hidden = NO;
        cell_foot.sureBtn.frame = CGRectMake(20, 155, 280, 40);
        [cell_foot.messageBtn setImage:[UIImage imageNamed:@"singleBtn(did)"] forState:UIControlStateNormal];
    }else if (cell_foot.messageBtn.selected == NO){
        cell_foot.tipsView.hidden = YES;
        cell_foot.sureBtn.frame = CGRectMake(20, 75, 280, 40);
        [cell_foot.messageBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
    }
    cell_foot.newsBtn.selected = NO;
    [cell_foot.newsBtn setImage:[UIImage imageNamed:@"singleBtn(undid)"] forState:UIControlStateNormal];
}

#pragma mark 确认按钮方法
-(void)sureBtnAction:(UIButton *)btn{
    NSLog(@"点击确认按钮");
    if (accesstoken.length > 0) {
        if (self.flag == 1) {
            [self requsetTest];
        }else if (self.flag == 2){
            [self requestEditRemind];
        }
    }
}

#pragma mark 添加用户提醒请求
-(void)requestEditRemind{
    
    [self getParametersData];
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/MedicationRemind/ModifyRemind"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    
    NSLog(@"%@",medicationsArr);
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [writer stringWithObject:medicationsArr];
    NSLog(@"str=====%@",jsonStr);

    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"whoId":self.dataDic[@"whoId"],@"who":nameStr,@"disease":diseaseStr,@"isRemind":@"true",@"medications":jsonStr,@"repeatRemindDay":frequenStr,@"startDay":startDayStr,@"endDay":endDayStr,@"remindWay":remindWay,@"remindPhone":phoneNumberStr};
    NSLog(@"parameters====%@",parameters);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


-(void)getParametersData{

    AccountInfoCell *cell_account = (AccountInfoCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    nameStr = cell_account.contentField.text;
    diseaseStr = cell_account.diseaseField.text;

    
    CycleContentCell *cell_cycle = (CycleContentCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    repeatesArr = @[@"每天",@"每两天",@"每三天",@"每四天",@"每五天",@"每六天",@"每七天"];
    for (int i = 0; i < repeatesArr.count; i++) {
        if ([cell_cycle.daysLabel.text isEqualToString:repeatesArr[i]]) {
            frequenStr = [NSString stringWithFormat:@"%d",i];
        }
    }

    startDayStr = cell_cycle.currentDayLabel.text;
    endDayStr = cell_cycle.endDateLabel.text;

    
    
    FooterViewCell *cell_foot = (FooterViewCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    if (cell_foot.newsBtn.selected == YES) {
        remindWay = @"0";
        phoneNumberStr = @"";
    }else if (cell_foot.messageBtn.selected == YES) {
        remindWay = @"1";
        phoneNumberStr = cell_foot.telephoneNumberField.text;
    }

    [medicationsArr removeAllObjects];
    if (self.flag == 2) {
        drugNumber = (int)drugArr.count;
    }else{
        drugNumber = (int)drugNameArr.count;
    }
    for (int i = 0; i < drugNumber; i++) {
        AddDrugCell *cell_add = (AddDrugCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i  inSection:1]];
        
        //通过字符“-”将日期分成年月日并放入数组
        NSArray *dateArr = [cell_add.timeLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSDictionary *tempDic = @{@"medicalName":cell_add.drugNameLabel.text,@"medicalMethod":cell_add.numberField.text,@"amTime":dateArr[0],@"lunTime":dateArr[1],@"pmTime":dateArr[2],@"fourthTime":dateArr[3]};
        [medicationsArr addObject:tempDic];
    }
}

-(void)requsetTest{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    [self getParametersData];//获取参数值
    [[Loading shareLoading] beginLoading];
    //数组转换为字符串
//    NSString *jsonString = [JsonUtil toJSONString:medicationsArr];
    NSLog(@"%@",medicationsArr);
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonStr = [writer stringWithObject:medicationsArr];
    NSLog(@"str=====%@,accesstoken===%@",jsonStr,accesstoken);
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://172.16.10.7:8081",@"/MedicationRemind/AddRemind"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"who":nameStr,@"disease":diseaseStr,@"isRemind":@"true",@"medications":jsonStr,@"repeatRemindDay":frequenStr,@"startDay":startDayStr,@"endDay":endDayStr,@"remindWay":remindWay,@"remindPhone":phoneNumberStr};
    NSLog(@"parameters===%@",parameters);
        // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
        [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict[@"msg"]);

            if ([dict[@"msg"] isEqualToString:@"添加成功！"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误 %@", error.localizedDescription);
        }];
}


-(void)dismissKeyBoard{
    AccountInfoCell *cell_account = (AccountInfoCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell_account.contentField resignFirstResponder];
    [cell_account.diseaseField resignFirstResponder];
    
    for (int i = 0; i < drugNumber; i++) {
        AddDrugCell *cell_addDrug = (AddDrugCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        [cell_addDrug.numberField resignFirstResponder];
    }
    
    FooterViewCell *cell_foot = (FooterViewCell *)[addNewNotifyTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell_foot.telephoneNumberField resignFirstResponder];
    
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
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
        [[Loading shareLoading] endLoading];
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                alreadyBuys = [[NSMutableArray alloc] initWithArray:object[@"info"][@"alreadyBuys"]];
                myCollections = [[NSMutableArray alloc] initWithArray:object[@"info"][@"myCollections"]];
                
                if (alreadyBuys.count == 0 && myCollections.count == 0) {
                    drugTable.hidden = YES;
                    clearView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-120, [UIScreen mainScreen].bounds.size.width, 180);
                }else{
                    drugTable.hidden = NO;
                    clearView.frame = CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 180);
                    [drugTable reloadData];
                }

            }else{
                [self showToast:object[@"msg"]];
            }
        }
        [[Loading shareLoading] endLoading];
    }
}

@end
