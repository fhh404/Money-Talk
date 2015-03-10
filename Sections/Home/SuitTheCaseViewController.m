//
//  SuitTheCaseViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-13.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "SuitTheCaseViewController.h"
#import "RootTabBarController.h"
#import "SuitCaseCell.h"
#import "DiseaseViewController.h"
#import "SearchViewController.h"
@interface SuitTheCaseViewController ()
{
    UITableView *suitForCaseTable;
    NSArray *menuArr;
    NSMutableArray *_dataArray;
    BOOL isopen;
}

@end

@implementation SuitTheCaseViewController

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
    
    self.title = @"对症找药";
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    [self addRightBarButtonItem:searchBtn];
    
    
    menuArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DiseaseTypes.plist" ofType:nil]];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < menuArr.count; i++) {
        [_dataArray addObject:[NSNumber numberWithBool:NO]];
    }

    
    
    
    suitForCaseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    suitForCaseTable.dataSource = self;
    suitForCaseTable.delegate = self;
    [self.view addSubview:suitForCaseTable];
    //注册xib
    [suitForCaseTable registerNib:[UINib nibWithNibName:@"SuitCaseCell" bundle:nil] forCellReuseIdentifier:@"suitCaseCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}





#pragma mark - suitForCaseTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_dataArray[section] intValue] == 0) {
        return 0;
    }
    return [menuArr[section][@"diseaseName"] count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return menuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuitCaseCell *cell = (SuitCaseCell *)[tableView dequeueReusableCellWithIdentifier:@"suitCaseCell"];
    if (indexPath.row == 0) {
        cell.menuBackIamgeVIew.image = [UIImage imageNamed:@"menuFristBackView"];
    }else{
        cell.menuBackIamgeVIew.image = [UIImage imageNamed:@"menuOtherBackView"];
    }
    
    cell.diseaseNameLabel.text = menuArr[indexPath.section][@"diseaseName"][indexPath.row][@"name"];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *imageNameArr = @[@"heartDisease",@"digestionDisease",@"nervousDisease",@"gynaecologyDisease",@"breatheDisease",@"secretionDisease",@"infectionDisease",@"urogenitalDisease",@"bloodDisease",@"rheumatismDisease",@"tumourDisease",@"metabolicDisease",@"mouthDisease",@"eyeDisease",@"orthopaedicsDisease",@"ENTDisease",@"skinDisease",@"sexDisease",@"maleSexDisease",@"childDisease"];
    NSArray *contentArr = @[@"心绞痛,心肌梗塞,心衰,心律失常",@"胃十二指肠溃疡,胃炎,肝炎",@"失眠,脑梗,脑出血",@"月经不调,痛经,妇科炎症",@"感冒,气管炎,肺炎",@"糖尿病,甲亢",@"感冒,水痘,肝炎",@"肾病,尿路感染",@"白血病,淋巴瘤",@"类风湿,干燥综合症,红斑狼疮",@"肿瘤,胃癌,乳腺癌",@"高脂血症,糖尿病",@"龋齿,牙周炎,口腔溃疡",@"近视,青光眼,白内障",@"颈椎病,肩周炎,骨折",@"中耳炎,鼻窦炎,扁桃体炎",@"皮炎,湿疹,痤疮",@"梅毒,淋病,艾滋病",@"阳痿早泄,不育,前列腺炎",@"新生黄疸,小儿哮喘,流行性腮腺炎"];
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    control.tag = section;
    control.backgroundColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(controlCliked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    iconImage.image = [UIImage imageNamed:imageNameArr[section]];
    [control addSubview:iconImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 30)];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:17];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = menuArr[section][@"typeName"];
    [control addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 20)];
    titleLabel1.font = [UIFont fontWithName:@"Arial" size:12];
    titleLabel1.textAlignment = NSTextAlignmentLeft;
    titleLabel1.textColor = [UIColor darkGrayColor];
    titleLabel1.text = contentArr[section];
    [control addSubview:titleLabel1];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 79, 280, 1)];
    lineImageView.image = [UIImage imageNamed:@"grayLine"];
    lineImageView.alpha = 0.5;
    [control addSubview:lineImageView];
    
    return control;
}


#pragma mark 表格折叠
-(void)controlCliked:(UIControl *)control{
    NSNumber *number = _dataArray[control.tag];
    isopen = [number boolValue];
    isopen = !isopen;
    number = [NSNumber numberWithDouble:isopen];
    _dataArray[control.tag] = number;
    [suitForCaseTable reloadSections:[NSIndexSet indexSetWithIndex:control.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    
//    SuitCaseCell *cell = (SuitCaseCell *)[suitForCaseTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
//    cell.menuBackIamgeVIew.image = [UIImage imageNamed:@"menudidBackView"];
    
    DiseaseViewController *disease = [[DiseaseViewController alloc] init];
    disease.title = menuArr[indexPath.section][@"diseaseName"][indexPath.row][@"name"];
    disease.diseaseId = menuArr[indexPath.section][@"diseaseName"][indexPath.row][@"diseaseID"];
    [self.navigationController pushViewController:disease animated:YES];
}

#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    NSLog(@"点击搜索按钮");
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

@end
