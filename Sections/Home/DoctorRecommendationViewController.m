//
//  DoctorRecommendationViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "DoctorRecommendationViewController.h"
#import "RootTabBarController.h"
#import "DoctorRecommentionCell.h"
#import "ChatViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DoctorRecommendationViewController ()
{
    UITableView *doctorRecommentionTable;
    CGFloat widthNumber;
    int numbers;
    NSMutableDictionary *dataDic;
    NSMutableArray *teamProductsArr;
    NSMutableString *doctorStr;
}
@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation DoctorRecommendationViewController
@synthesize teamId;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"药师推荐";
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    [self addRightBarButtonItem:searchBtn];
    
    
    doctorRecommentionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    doctorRecommentionTable.delegate = self;
    doctorRecommentionTable.dataSource = self;
    doctorRecommentionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    doctorRecommentionTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:doctorRecommentionTable];
    
    //注册xib
    [doctorRecommentionTable registerNib:[UINib nibWithNibName:@"DoctorRecommentionCell" bundle:nil] forCellReuseIdentifier:@"doctorRecommentionCell"];
}

-(void)requestProductDetailData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getProductTeamDetials"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    NSDictionary *parameters = @{@"teamId":self.teamId};
    
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
    if (self.teamId.length > 0) {
        [self requestProductDetailData];
    }
}




#pragma mark - doctorRecommentionTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%@",dataDic[@"doctorEvaluation"]];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height+320;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DoctorRecommentionCell *cell_recommention = (DoctorRecommentionCell *)[tableView dequeueReusableCellWithIdentifier:@"doctorRecommentionCell"];
    cell_recommention.selectionStyle = UITableViewCellSelectionStyleNone;
    cell_recommention.grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    //scrollow
    
    widthNumber = 0;
    cell_recommention.productScrollow.contentSize = CGSizeMake(80*teamProductsArr.count, 110);
    for (int i = 0; i < teamProductsArr.count; i++) {
        UIImageView *productImage = [[UIImageView alloc] initWithFrame:CGRectMake(80*i, 12, 50, 70)];
        productImage.tag = 500+i;
        [productImage sd_setImageWithURL:[NSURL URLWithString:teamProductsArr[i][@"productPic"]] placeholderImage:[UIImage imageNamed:@"defaultPic@2x"]];
        [cell_recommention.productScrollow addSubview:productImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80*i, 85, 60, 20)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial" size:8];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = teamProductsArr[i][@"productName"];
        [cell_recommention.productScrollow addSubview:label];
        
        if (i != teamProductsArr.count-1) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(60+80*i, 52, 10, 10)];
            image.image = [UIImage imageNamed:@"bingliejiahao"];
            [cell_recommention.productScrollow addSubview:image];
        }
    }
    
    //
    cell_recommention.ourPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell_recommention.doctorBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#61b1f4"].CGColor;
    cell_recommention.doctorBtn.layer.borderWidth = 0.2;
    cell_recommention.doctorBtn.tag = 900 +indexPath.row;
    [cell_recommention.doctorBtn addTarget:self action:@selector(doctorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell_recommention.doctorBtn.layer.cornerRadius = 3;
    cell_recommention.goumaiBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [cell_recommention.goumaiBtn addTarget:self action:@selector(buyNowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell_recommention.goumaiBtn.tag = 800+indexPath.row;
    cell_recommention.goumaiBtn.layer.cornerRadius = 3;
    
    //赋值
    if (dataDic != nil) {
        cell_recommention.ourPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataDic[@"teamPrice"]];
        cell_recommention.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataDic[@"oldPrice"]];
        cell_recommention.restPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dataDic[@"oldPrice"]floatValue]-[dataDic[@"teamPrice"]floatValue]];
    }
    
    
    //市场价：
    NSUInteger length = [cell_recommention.originalPriceLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell_recommention.originalPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
    [cell_recommention.originalPriceLabel setAttributedText:attri];
    
    
    
    //药师点评
    if (dataDic != nil) {
        cell_recommention.contentLabel.text = doctorStr;
    }
    
    cell_recommention.contentLabel.numberOfLines = 0;
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [cell_recommention.contentLabel.text boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cell_recommention.contentLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
    [cell_recommention.contentLabel sizeToFit];
    
    [cell_recommention.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell_recommention.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell_recommention;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


#pragma mark - Method

#pragma mark 购买组合按钮方法
-(void)buyNowBtnAction:(UIButton *)btn{
    
}

#pragma mark 药师咨询按钮方法
-(void)doctorBtnAction:(UIButton *)btn{
    ChatViewController *chat = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark 向左按钮方法
-(void)leftBtnAction:(UIButton *)btn{
    widthNumber -= 80;
    if (widthNumber <= 0) {
        widthNumber = 0;
        DoctorRecommentionCell *cell = (DoctorRecommentionCell *)[doctorRecommentionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.productScrollow setContentOffset:CGPointMake(0, 0)];
    }else{
        DoctorRecommentionCell *cell = (DoctorRecommentionCell *)[doctorRecommentionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.productScrollow setContentOffset:CGPointMake(widthNumber, 0)];
    }
}

#pragma mark 向右按钮方法
-(void)rightBtnAction:(UIButton *)btn{
    widthNumber += 80;
    if (widthNumber >= (numbers-1)*80) {
        widthNumber = (numbers-1)*80;
        DoctorRecommentionCell *cell = (DoctorRecommentionCell *)[doctorRecommentionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.productScrollow setContentOffset:CGPointMake((numbers-1)*80, 0)];
    }else{
        DoctorRecommentionCell *cell = (DoctorRecommentionCell *)[doctorRecommentionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.productScrollow setContentOffset:CGPointMake(widthNumber, 0)];
    }
}


#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    
}


#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
               
                dataDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                teamProductsArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"teamProducts"]];
                doctorStr = [NSMutableString stringWithFormat:@"%@",dataDic[@"doctorEvaluation"]];
                [self deletePMethod:doctorStr];
                [doctorRecommentionTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
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
