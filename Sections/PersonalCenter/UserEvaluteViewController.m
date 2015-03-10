//
//  UserEvaluteViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "UserEvaluteViewController.h"
#import "RootTabBarController.h"
#import "UserEvaluteCell.h"
@interface UserEvaluteViewController ()
{
    NSString *accesstoken;
    int currentpage;
    int pageRows;
    NSMutableArray *evaluationArr;
    UITableView *userEvaluateTable;

}

@property (nonatomic, strong) JsonRequest *jsonRequest;


@end

@implementation UserEvaluteViewController
@synthesize priductId;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户评论";
    self.showMoreBtn = NO;
    
    _totalBackView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    _totalEvaluters.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    _totalStars.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    
    userEvaluateTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStyleGrouped];
    userEvaluateTable.delegate = self;
    userEvaluateTable.dataSource = self;
    userEvaluateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userEvaluateTable];
    
    
    //注册xib
    [userEvaluateTable registerNib:[UINib nibWithNibName:@"UserEvaluteCell" bundle:nil] forCellReuseIdentifier:@"userEvaluteCell"];
    
}

#pragma mark 用户评价请求
-(void)requestUserEvaluateData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getProductEvaluation"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"priductId":self.priductId,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows]};
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
    currentpage = 1;
    pageRows = 10;
    [self requestUserEvaluateData];
}


#pragma mark - waitForReciveTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return evaluationArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = evaluationArr[indexPath.section][@"evaluationDetials"];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height+65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserEvaluteCell *cell = (UserEvaluteCell *)[tableView dequeueReusableCellWithIdentifier:@"userEvaluteCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    //赋值
    if (evaluationArr.count > 0) {
        cell.numbersLabel.text = [NSString stringWithFormat:@"数量:%@",evaluationArr[indexPath.section][@"number"]];
        cell.evaluteContentLabel.text = evaluationArr[indexPath.section][@"evaluationDetials"];
        cell.phoneNumberLabel.text = evaluationArr[indexPath.section][@"userName"];
        cell.dateLabel.text = evaluationArr[indexPath.section][@"evaluateTime"];
    }
    
    cell.evaluteContentLabel.numberOfLines = 0;
    [cell.evaluteContentLabel sizeToFit];
    UIFont *tfont = [UIFont systemFontOfSize:14];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [cell.evaluteContentLabel.text boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cell.evaluteContentLabel.frame = CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width-40, sizeText.height);

    cell.phoneNumberLabel.frame = CGRectMake(20, 35+sizeText.height, 100, 20);
    cell.dateLabel.frame = CGRectMake(20, 35+sizeText.height, 100, 20);
    
    for (int i = 100; i < 100+[evaluationArr[indexPath.section][@"star"]intValue]; i++) {
        UIImageView *starImage = (UIImageView *)[self.view viewWithTag:i];
        [starImage setImage:[UIImage imageNamed:@"evaluteDegree"]];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    
}


#pragma mark - Method

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
            NSLog(@"%@,self.class=====%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                evaluationArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"EvaluationDetials"]];
                [self changeStar:[object[@"info"][@"totalStar"]intValue] Andevaluaters:object[@"info"][@"totlalEvaluation"]];
                [userEvaluateTable reloadData];
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}

-(void)changeStar:(int)stars Andevaluaters:(NSString *)evaluaters{
    for (int i = 200; i < 200+stars; i++) {
        UIImageView *image = (UIImageView *)[self.view viewWithTag:i];
        [image setImage:[UIImage imageNamed:@"evaluteDegree"]];
    }
    
    _totalEvaluters.text = evaluaters;
    _totalStars.text = [NSString stringWithFormat:@"%d",stars];
}


@end
