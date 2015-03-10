//
//  SearchViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "SearchViewController.h"
#import "RootTabBarController.h"
#import "SearchTableViewCell.h"
#import "HistorySearchDataBase.h"
#import "TypesDetailViewController.h"
@interface SearchViewController ()
{
    UITextField   *commitText;
    UILabel     *keyboardLabel;
    UIButton    *keyboardBtn,*keyboardBtnAt;
    UITableView *searchResultTable;
    NSMutableArray *historyArr;
    UITableView *tipsTable;
    NSMutableArray *tipsArr;
    UIView *alphaView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)cancelBtn:(UIButton *)sender;
- (IBAction)saoMiaoBtn:(UIButton *)sender;
- (IBAction)searchBtnAction:(UIButton *)sender;

@end

@implementation SearchViewController

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
    
    self.showMoreBtn = NO;
    
    _BackImageView.backgroundColor = [UIColor jk_colorWithHexString:@"#0082f0"];
    
    [_inputField becomeFirstResponder];
    _inputField.clearButtonMode = UITextFieldViewModeUnlessEditing;//UITextFieldViewModeUnlessEditing,UITextFieldViewModeAlways
    _inputField.delegate = self;
    
    
    _cancleBtns.hidden = NO;
    _searchBtn.hidden = YES;
    
    [_inputField addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    

    //搜索结果显示tableview
    searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0,120, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) style:UITableViewStylePlain];
    searchResultTable.delegate = self;
    searchResultTable.dataSource = self;
    searchResultTable.hidden = YES;
    searchResultTable.tag = 1000;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    searchResultTable.tableFooterView = view;
    searchResultTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchResultTable];
    
    NSArray *tempArr = [[HistorySearchDataBase sharedDatabase] seleteALlHIstoryData];

    if (tempArr.count == 0) {
        historyArr = [[NSMutableArray alloc] init];
       [historyArr addObject:@"暂时没有数据"];
    }else{
        historyArr = [[NSMutableArray alloc] initWithArray:tempArr];
    }
    NSLog(@"historyArr ====%@",historyArr);
    
    

    
    //搜索提示tableview
    [self creatTipsTableView];
    
}

-(void)changeValue:(UITextField *)field{
    if (_inputField.text.length > 0) {
        _searchBtn.hidden = NO;
        _cancleBtns.hidden = YES;
    }else{
        alphaView.hidden = YES;
        _searchBtn.hidden = YES;
        _cancleBtns.hidden = NO;
    }
}

-(void)creatTipsTableView{
    alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.7];
    [self.view addSubview:alphaView];
    
    tipsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80) style:UITableViewStylePlain];
    tipsTable.delegate = self;
    tipsTable.dataSource = self;
    tipsTable.tag = 2000;
    [alphaView addSubview:tipsTable];
    
    alphaView.hidden = YES;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    _cancleBtns.hidden = NO;
    _searchBtn.hidden = YES;
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - searchResultTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2000) {
        return tipsArr.count;
    }
    return historyArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1000:
        {
            return 40;
        }
            break;
        case 2000:
        {
            return 40;
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
            return 30;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1000:
        {
            static NSString *identifier = @"cellMark";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = historyArr[indexPath.row];
            return cell;
        }
            break;
        case 2000:
        {
            static NSString *identifier = @"cellMark1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = tipsArr[indexPath.row][@"searchResult"];
            return cell;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1000:
        {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAction:)]];
            
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
            lineImage.image = [UIImage imageNamed:@"grayLine"];
            [view addSubview:lineImage];
            
            
            
            UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 100, 20)];
            clearLabel.text = @"清空历史记录";
            clearLabel.font = [UIFont fontWithName:@"Arial" size:12];
            clearLabel.textColor = [UIColor darkGrayColor];
            clearLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:clearLabel];
            
            return view;

        }
            break;
        case 2000:
        {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAction:)]];
            
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
            lineImage.image = [UIImage imageNamed:@"grayLine"];
            [view addSubview:lineImage];
            return view;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    if (tableView.tag == 1000) {
        _inputField.text = historyArr[indexPath.row];
    }else if (tableView.tag == 2000){
        TypesDetailViewController *typesDetail = [[TypesDetailViewController alloc] init];
        typesDetail.keyWord = tipsArr[indexPath.row][@"searchResult"];
        typesDetail.requestFlag = 1;
        [self.navigationController pushViewController:typesDetail animated:YES];
    }
    _cancleBtns.hidden = YES;
    _searchBtn.hidden = NO;
}


#pragma mark - Method
#pragma mark 清空历史按钮方法
-(void)clearAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"执行清空方法");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认清空输入历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}



#pragma mark inputField_delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1000) {
        _saomiaoView.hidden = YES;
        searchResultTable.hidden = NO;
        searchResultTable.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70);
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1000) {
        _saomiaoView.hidden = NO;
        searchResultTable.hidden = NO;
        searchResultTable.frame = CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120);
        [searchResultTable reloadData];
    }
}



#pragma mark - AlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确定删除输入历史");
        [[HistorySearchDataBase sharedDatabase] deleteAllHistoryData];
        [historyArr removeAllObjects];
        [historyArr addObject:@"暂时没有数据"];
        [searchResultTable reloadData];
    }
}

#pragma mark 取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 扫描按钮
- (IBAction)saoMiaoBtn:(UIButton *)sender {
    NSLog(@"执行扫描方法");
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 搜索按钮方法
- (IBAction)searchBtnAction:(UIButton *)sender {
    if (_inputField.text.length > 0) {
        alphaView.hidden = NO;
        [self requestSearchData];
    }
}

-(void)requestSearchData{
    [[Loading shareLoading] beginLoading];
    NSDictionary *parameters = @{@"searchWord":_inputField.text};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/searchByWordTips"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];

}


-(NSMutableArray *)getDataFromDB{
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[[HistorySearchDataBase sharedDatabase] seleteALlHIstoryData]];
    return tempArr;
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
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                
                if ([historyArr[0] isEqualToString:@"暂时没有数据"]) {
                    [historyArr removeAllObjects];
                }
                [[HistorySearchDataBase sharedDatabase] insertData:_inputField.text];
                historyArr = [self getDataFromDB];
                [searchResultTable reloadData];
                
                [tipsArr removeAllObjects];
                tipsArr = [[NSMutableArray alloc] initWithArray:object[@"info"]];
                NSLog(@"tipsArr====%@",tipsArr);
                [tipsTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


@end
