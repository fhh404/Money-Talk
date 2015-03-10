//
//  DiseaseViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/29.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "DiseaseViewController.h"
#import "RootTabBarController.h"
#import "ProtoclCell.h"
#import "DiseaseCell.h"
#import "ProductDetailViewController.h"
#import "ActiveWebViewController.h"
@interface DiseaseViewController ()
{
    UITableView *diseaseTable;
    NSMutableArray *_dataArray;
    NSArray *menuArr;
    BOOL isopen;
    UIView *grayBackView;
    NSMutableDictionary *diseaseArr;
    NSMutableString *methodTitle;
    NSMutableString *introduction;
    NSMutableArray *medicineArr;
    NSMutableArray *questionArr;
}
@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation DiseaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    [self addRightBarButtonItem:searchBtn];
    
    diseaseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-0) style:UITableViewStyleGrouped];
    diseaseTable.delegate = self;
    diseaseTable.dataSource = self;
    [self.view addSubview:diseaseTable];
    
    //注册xib
    [diseaseTable registerNib:[UINib nibWithNibName:@"DiseaseCell" bundle:nil] forCellReuseIdentifier:@"diseaseCell"];
    
    menuArr = @[@"疾病简介",@"治疗方案",@"治疗药物",@"相关问题"];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < menuArr.count; i++) {
        [_dataArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    
}



-(void)requestDiseaseData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/searchByDisease"];
    NSLog(@"urlStr ===== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"id":self.diseaseId};
    NSLog(@"parameters===%@",parameters);
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
    [self requestDiseaseData];
}


#pragma mark - suitForCaseTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_dataArray[section] intValue] == 0) {
        return 0;
    }else{
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
            case 1:
            {
                return 1;
            }
                break;

            case 2:
            {
                return medicineArr.count;
            }
                break;

            case 3:
            {
                return questionArr.count;
            }
                break;

            default:
                break;
        }
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return menuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {

            UIFont *tfont = [UIFont systemFontOfSize:15];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [introduction boundingRectWithSize:CGSizeMake(300, 1800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            return sizeText.height+10;

        }
            break;
        case 1:
        {

            UIFont *tfont = [UIFont systemFontOfSize:14];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [methodTitle boundingRectWithSize:CGSizeMake(300, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            NSLog(@"sizeText.height====%f",sizeText.height);
            if (sizeText.height > 3000) {
                return sizeText.height - 150;
            }
            return sizeText.height+10;
            
        }
            break;
        case 2:
        {
            return 120;
        }
            break;
        case 3:
        {
            NSString *str = questionArr[indexPath.row][@"title"];
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [str boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            return sizeText.height+10;
        }
            break;
        default:
            break;
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        switch (indexPath.section) {
        case 0:
        {
            static NSString *identifer = @"cellMark";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.contentLabel.text =introduction;
            UIFont *tfont = [UIFont systemFontOfSize:15];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(300, 1800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            cell.contentLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
            cell.contentLabel.numberOfLines = 0;
            [cell.contentLabel sizeToFit];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identifer = @"cellMark1";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.contentLabel.text = methodTitle;
            UIFont *tfont = [UIFont systemFontOfSize:14];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(300, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            cell.contentLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
            cell.contentLabel.numberOfLines = 0;
            [cell.contentLabel sizeToFit];
            return cell;
        }
            break;
        case 2:
        {
            DiseaseCell *cell_disease = (DiseaseCell *)[tableView dequeueReusableCellWithIdentifier:@"diseaseCell"];
            [cell_disease.shopCartBtn addTarget:self action:@selector(shopCartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_disease.shopCartBtn.tag = 100 + indexPath.row;
            //市场价：
            cell_disease.marketPriceLabel.text = medicineArr[indexPath.row][@"marketPrice"];
            NSUInteger length = [cell_disease.marketPriceLabel.text length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell_disease.marketPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
            [cell_disease.marketPriceLabel setAttributedText:attri];
            //我们的价格
            cell_disease.ourPriceLabel.text = medicineArr[indexPath.row][@"ourPrice"];
            cell_disease.ourPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            
            cell_disease.drugNameLabel.text = medicineArr[indexPath.row][@"productName"];
            cell_disease.drugActionLabel.text = medicineArr[indexPath.row][@"introduction"];
            [cell_disease.drugImage loadImageFromURL:[NSURL URLWithString:medicineArr[indexPath.row][@"productPic"]]];
            
            return cell_disease;
        }
            break;
        case 3:
        {
            static NSString *identifer = @"cellMark1";
            ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.contentLabel.text = questionArr[indexPath.row][@"title"];
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            cell.contentLabel.frame = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
            cell.contentLabel.numberOfLines = 0;
            [cell.contentLabel sizeToFit];
            return cell;

        }
            break;
        default:
            break;
    }
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        control.tag = section;
        control.backgroundColor = [UIColor whiteColor];
        [control addTarget:self action:@selector(controlCliked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 10, 20, 20)];
        NSNumber *number = _dataArray[section];
        if ([number boolValue]) {
            iconImage.image = [UIImage imageNamed:@"upArrow"];
        }else{
            iconImage.image = [UIImage imageNamed:@"presentAll"];
        }
        
        iconImage.tag = 200 + section;
        [control addSubview:iconImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 20)];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = menuArr[section];
        [control addSubview:titleLabel];
        
        
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, [UIScreen mainScreen].bounds.size.width, 1)];
        lineImageView.image = [UIImage imageNamed:@"grayLine"];
        lineImageView.alpha = 0.5;
        [control addSubview:lineImageView];
        
        return control;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    if (indexPath.section == 3) {
        ActiveWebViewController *activeWeb = [[ActiveWebViewController alloc] init];
        activeWeb.url = questionArr[indexPath.row][@"url"];
        [self.navigationController pushViewController:activeWeb animated:YES];
    }else if (indexPath.section == 2){
        ProductDetailViewController *productionDetail = [[ProductDetailViewController alloc] init];
        productionDetail.priductCode = medicineArr[indexPath.row][@"productCode"];
        [self.navigationController pushViewController:productionDetail animated:YES];
    }
    
}


#pragma mark 表格折叠
-(void)controlCliked:(UIControl *)control{
    NSNumber *number = _dataArray[control.tag];
    isopen = [number boolValue];
    isopen = !isopen;
    number = [NSNumber numberWithDouble:isopen];
    _dataArray[control.tag] = number;
    
    
    [diseaseTable reloadSections:[NSIndexSet indexSetWithIndex:control.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


#pragma mark - Method

#pragma mark 购物车按钮方法
-(void)shopCartBtnAction:(UIButton *)btn{
    NSLog(@"btn.tag-100==indexpath.row==%d",(int)btn.tag-100);
    [self initShopCartSuceessUI];
}


-(void)initShopCartSuceessUI{
    grayBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayBackView.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.25];
    [self.view addSubview:grayBackView];
    
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-160-64, [UIScreen mainScreen].bounds.size.width, 160)];
    whiteview.backgroundColor = [UIColor whiteColor];
    [grayBackView addSubview:whiteview];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 160, 20)];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = [UIColor blackColor];
    successLabel.text = @"成功加入购物车！";
    [whiteview addSubview:successLabel];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30+i*135, 80, 105, 40)];
        btn.tag = 200+i;
        if (i == 0) {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"继续购物" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0.2;
            btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
        }else{
            btn.backgroundColor = [UIColor jk_colorWithHexString:@"61b1f4"];
            [btn setTitle:@"进入购物车" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        btn.layer.cornerRadius = 3;
        [btn addTarget:self action:@selector(shopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteview addSubview:btn];
    }
    
}

-(void)shopBtnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 200:
        {
            //继续购物
            [grayBackView removeFromSuperview];
        }
            break;
        case 201:
        {
            [grayBackView removeFromSuperview];
            //进入购物车
            RootTabBarController *root = (RootTabBarController *)self.tabBarController;
            [root selectAtIndex:13];
        }
            break;
        default:
            break;
    }
}



#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    NSLog(@"点击搜索按钮");
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
            if ([object[@"result"] isEqualToNumber:@0]) {
                diseaseArr = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                
                methodTitle = [NSMutableString stringWithFormat:@"%@",diseaseArr[@"treated"]];
                introduction = [NSMutableString stringWithFormat:@"%@",diseaseArr[@"summarize"]];
                [self deletePMethod:methodTitle];
                [self deletePMethod:introduction];
                
                medicineArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"treatMedecines"]];
                questionArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"relateArticle"]];
                NSLog(@"medicineArr==%@",medicineArr);
                [diseaseTable reloadData];
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

#pragma mark 去除<p>的方法
-(NSMutableString *)deletePMethod:(NSMutableString *)string{
    NSRange range = [string rangeOfString:@"<"];
    while (range.length) {
        NSRange range1 = [string rangeOfString:@">"];
        if (range1.location >= range.location) {
            NSRange currentRange = NSMakeRange(range.location, range1.location - range.location + 1);
            [string deleteCharactersInRange:currentRange];
            range = [string rangeOfString:@"<"];
        }
    }
    return string;
}

@end
