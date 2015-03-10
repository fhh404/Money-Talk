//
//  EditAddressViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "EditAddressViewController.h"
#import "RootTabBarController.h"
#import "MyDatabase.h"
#import "ProtoclCell.h"
#import "RegexRuleMethod.h"
//动画时间
#define kAnimationDuration 0.2
@interface EditAddressViewController ()
{
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *countryArr;
    UITableView *provinceTable;
    UITableView *cityTable;
    UITableView *countryTable;
    NSString *areaId;
    NSString *provinceId;
    NSString *cityId;
    NSString *isDefaultAddress;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)stateBtnAction:(UIButton *)sender;
- (IBAction)cityBtnAction:(UIButton *)sender;
- (IBAction)countyBtnAction:(UIButton *)sender;
- (IBAction)sureBtnAction:(UIButton *)sender;
- (IBAction)isdefaultBtnAction:(UIButton *)sender;

@end

@implementation EditAddressViewController
@synthesize forNavTitle,flag,addressId,editDic;
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
    self.title = self.forNavTitle;
    self.showMoreBtn = NO;
    _sureBtn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
//    _navTitleLabel.text = self.forNavTitle;
//    _contentScrollow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    _contentScrollow.contentSize = CGSizeMake(320, 580);
    
    //给键盘添加收回按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    
    _reciverNameField.inputAccessoryView = topView;
    _telephoneNumField.inputAccessoryView = topView;
    _detailAddressTextView.inputAccessoryView = topView;
    _postcodeField.inputAccessoryView = topView;
    
    provinceTable = [[UITableView alloc] initWithFrame:CGRectMake(90, 125, 180, 150) style:UITableViewStylePlain];
    provinceTable.delegate = self;
    provinceTable.dataSource = self;
    provinceTable.tag = 100;
    provinceTable.hidden = YES;
    [_contentScrollow addSubview:provinceTable];
    
    cityTable = [[UITableView alloc] initWithFrame:CGRectMake(90, 170, 180, 150) style:UITableViewStylePlain];
    cityTable.delegate = self;
    cityTable.dataSource = self;
    cityTable.tag = 101;
    cityTable.hidden = YES;
    [_contentScrollow addSubview:cityTable];

    countryTable = [[UITableView alloc] initWithFrame:CGRectMake(90, 215, 180, 150) style:UITableViewStylePlain];
    countryTable.delegate = self;
    countryTable.dataSource = self;
    countryTable.tag = 102;
    countryTable.hidden = YES;
    [_contentScrollow addSubview:countryTable];


    
    provinceArr = [[MyDatabase sharedDatabase] seleteNameWithParentCode:@"0"];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    self.title = self.forNavTitle;
    isDefaultAddress = @"flase";
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    if (self.flag == 1) {
        NSLog(@"self.editDic====%@",self.editDic);
        [self placeValueForEdit];
    }

}

-(void)placeValueForEdit{
    isDefaultAddress = self.editDic[@"isDefaultAddress"];
    if ([isDefaultAddress isEqualToString:@"true"]) {
        _isdefaultBtn.selected = YES;
        [_isdefaultBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else{
        _isdefaultBtn.selected = NO;
        [_isdefaultBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
    _reciverNameField.text = self.editDic[@"recieverName"];
    _detailAddressTextView.text = self.editDic[@"detailAddress"];
    _telephoneNumField.text = self.editDic[@"contacePhone"];
    _postcodeField.text = self.editDic[@"postCode"];
    _stateLabel.text = self.editDic[@"province"];
    provinceId = self.editDic[@"provinceId"];
    _cityLabel.text = self.editDic[@"city"];
    cityId = self.editDic[@"cityId"];
    _countyLabel.text = self.editDic[@"area"];
    areaId = self.editDic[@"areaId"];
}


// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有输入框的view的位置
    if ([_detailAddressTextView isFirstResponder]) {
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
        [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, -160, 320, [UIScreen mainScreen].bounds.size.height+150)];//keyboardRect.size.height-kViewHeight
        [UIView commitAnimations];
    }else if ([_postcodeField isFirstResponder]){
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
        [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, -170, 320, [UIScreen mainScreen].bounds.size.height+150)];//keyboardRect.size.height-kViewHeight
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
    [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    [UIView commitAnimations];
}


#pragma mark waitForReciveTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 100:
        {
            return provinceArr.count;
        }
            break;
        case 101:
        {
            return cityArr.count;
        }
            break;
        case 102:
        {
            return countryArr.count;
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
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    switch (tableView.tag) {
        case 100:
        {
            static NSString *identifer = @"CellMark1";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            DataModel *model = provinceArr[indexPath.row];
            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            cell.contentLabel.text = model.AreaName;
            cell.contentLabel.frame = CGRectMake(0, 0, 180, 30);
            return cell;
        }
            break;
        case 101:
        {
            static NSString *identifer = @"CellMark2";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            DataModel *model = cityArr[indexPath.row];

            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            cell.contentLabel.text = model.AreaName;
            cell.contentLabel.frame = CGRectMake(0, 0, 180, 30);
            return cell;
        }
            break;
        case 102:
        {
            static NSString *identifer = @"CellMark3";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            DataModel *model = countryArr[indexPath.row];

            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            cell.contentLabel.text = model.AreaName;
            cell.contentLabel.frame = CGRectMake(0, 0, 180, 30);
            return cell;
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
        case 100:
        {
            provinceTable.hidden = YES;
            DataModel *datamodel = provinceArr[indexPath.row];
            _stateLabel.text = datamodel.AreaName;
            provinceId = datamodel.AreaCode;
            _cityLabel.text = @"";
            cityId = @"";
            cityArr = [[MyDatabase sharedDatabase] seleteNameWithParentCode:datamodel.AreaCode];
            [cityTable reloadData];
        }
            break;
        case 101:
        {
            cityTable.hidden = YES;
            DataModel *datamodel = cityArr[indexPath.row];
            _cityLabel.text = datamodel.AreaName;
            cityId = datamodel.AreaCode;
            _countyLabel.text = @"";
            areaId = @"";
            countryArr = [[MyDatabase sharedDatabase] seleteNameWithParentCode:datamodel.AreaCode];
            [countryTable reloadData];
        }
            break;
        case 102:
        {
            countryTable.hidden = YES;
            DataModel *datamodel = countryArr[indexPath.row];
            _countyLabel.text = datamodel.AreaName;
            areaId = datamodel.AreaCode;
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark 省份按钮方法
- (IBAction)stateBtnAction:(UIButton *)sender {
    NSLog(@"点击省份下拉按钮");
    provinceTable.hidden = NO;
    cityTable.hidden = YES;
    countryTable.hidden = YES;
}

#pragma mark 城市下拉按钮方法
- (IBAction)cityBtnAction:(UIButton *)sender {
    NSLog(@"点击城市下拉按钮");
    if (cityArr.count > 0) {
        cityTable.hidden = NO;
        provinceTable.hidden = YES;
        countryTable.hidden = YES;
    }
}

#pragma mark 县、区下拉按钮方法
- (IBAction)countyBtnAction:(UIButton *)sender {
    NSLog(@"点击县、区下拉按钮");
    if (countryArr.count > 0) {
        countryTable.hidden = NO;
        cityTable.hidden = YES;
        provinceTable.hidden = YES;
    }
}

#pragma mark 确认按钮方法
- (IBAction)sureBtnAction:(UIButton *)sender {
    if (_detailAddressTextView.text.length > 0 && [[RegexRuleMethod regexRule] isTelephone:_telephoneNumField.text] && _reciverNameField.text.length > 0 && _postcodeField.text.length > 0) {
        [self requestAddressData];
    }else if (_reciverNameField.text.length == 0){
        NSLog(@"收货人不能为空！");
    }else if ([[RegexRuleMethod regexRule] isTelephone:_telephoneNumField.text] == 0){
        NSLog(@"手机号不存在！");
    }else if (_detailAddressTextView.text.length == 0){
        NSLog(@"详细地址不能为空！");
    }else if (_postcodeField.text.length == 0){
        NSLog(@"邮编不能为空！");
    }
}

- (IBAction)isdefaultBtnAction:(UIButton *)sender {
    _isdefaultBtn.selected = !_isdefaultBtn.selected;
    if (_isdefaultBtn.selected == YES) {
        [_isdefaultBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        isDefaultAddress = @"true";
    }else{
        [_isdefaultBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        isDefaultAddress = @"false";
    }
}


-(void)requestAddressData{
    [[Loading shareLoading] beginLoading];
    NSString *accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    NSString *wholeAddress = [NSString stringWithFormat:@"%@%@%@%@",_stateLabel.text,_cityLabel.text,_countyLabel.text,_detailAddressTextView.text];
    NSDictionary *parameters = [[NSDictionary alloc] init];
    NSString *urlStr;
    if (self.flag == 2) {
        //新增收货地址的参数
        parameters = @{@"accesstoken":accesstoken,@"isDefaultAddress":isDefaultAddress,@"recieverName":_reciverNameField.text,@"detailAddress":_detailAddressTextView.text,@"wholeAddress":wholeAddress,@"contacePhone":_telephoneNumField.text,@"postCode":_postcodeField.text,@"province":_stateLabel.text,@"provinceId":provinceId,@"city":_cityLabel.text,@"cityId":cityId,@"area":_countyLabel.text,@"areaId":areaId};
        //url地址
        urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/addRecieverAddress"];
        NSLog(@"urlStr ==inputCode== %@",urlStr);
        
        NSLog(@"parameters====新增====%@",parameters);
        
    }else if (self.flag == 1){
        //编辑收货地址的参数
        parameters = @{@"accesstoken":accesstoken,@"addressId":self.editDic[@"addressId"],@"isDefaultAddress":isDefaultAddress,@"recieverName":_reciverNameField.text,@"detailAddress":_detailAddressTextView.text,@"wholeAddress":wholeAddress,@"contacePhone":_telephoneNumField.text,@"postCode":_postcodeField.text,@"province":_stateLabel.text,@"provinceId":provinceId,@"city":_cityLabel.text,@"cityId":cityId,@"area":_countyLabel.text,@"areaId":areaId};
        //url地址
        urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/updateRecieverAddress"];
        NSLog(@"urlStr ==inputCode== %@",urlStr);
        NSLog(@"parameters====编辑====%@",parameters);
    }
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
    
}


-(void)dismissKeyBoard{
    
    [_reciverNameField resignFirstResponder];
    [_telephoneNumField resignFirstResponder];
    [_postcodeField resignFirstResponder];
    [_detailAddressTextView resignFirstResponder];
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
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

@end
