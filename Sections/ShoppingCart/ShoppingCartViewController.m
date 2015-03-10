//
//  ShoppingCartViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "RootTabBarController.h"
#import "ShoppingCartCell.h"
#import "HomeViewController.h"
#import "OrderSureViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
@interface ShoppingCartViewController ()
{
    UITableView *shoppingCartTable;
    int number;
    NSString *accesstoken;
    NSString *uniquedid;
    int currentpage;
    int pageRows;
    NSMutableArray *allGoodsLists;
    NSIndexPath *deleteIndexpath;
    NSMutableArray *numberArr;
    NSMutableArray *carGoodsIds;
    int selectedNumber;
    UIView *grayView;
    BOOL isRefresh;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)allCheckBoxBtn:(UIButton *)sender;
- (IBAction)sumBtn:(UIButton *)sender;

@end

@implementation ShoppingCartViewController

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
    self.title = @"购物车";
    
    [self creatKongUI];

    
    
    shoppingCartTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-40-64) style:UITableViewStyleGrouped];
    shoppingCartTable.delegate = self;
    shoppingCartTable.dataSource = self;
    shoppingCartTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:shoppingCartTable];
    
    //注册xib
    [shoppingCartTable registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
    shoppingCartTable.hidden = YES;
    _jiesuanView.hidden = YES;
    
    uniquedid = [[MyUserDefaults defaults] readFromUserDefaults:@"uniquedid"];
    
    // 集成购物车刷新控件
    [self setupshoppingCartRefresh];
    numberArr = [[NSMutableArray alloc] init];
}


- (void)setupshoppingCartRefresh
{
    // 上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [shoppingCartTable addFooterWithTarget:self action:@selector(shopCartFooterRereshing)];
    
    shoppingCartTable.footerPullToRefreshText = @"上拉加载更多";
    shoppingCartTable.footerReleaseToRefreshText = @"松开马上加载更多";
    shoppingCartTable.footerRefreshingText = @"正在帮你加载中.....";
}



#pragma mark 未完成订单请求
-(void)requestShopCartData{

    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/getAllGoods"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);

    //参数
    accesstoken = accesstoken == nil ? @"" : accesstoken;
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"uniquedid":uniquedid};
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
    [allGoodsLists removeAllObjects];
    currentpage = 1;
    pageRows = 10;
    isRefresh = NO;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (uniquedid.length > 0) {
        [self requestShopCartData];
    }
}


#pragma mark 无数据时的视图
-(void)creatKongUI{
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120)];
    grayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:grayView];
    
    UIImageView *shopIconIamge = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-30, 90, 50, 50)];
    shopIconIamge.image = [UIImage imageNamed:@"paycart"];
    [grayView addSubview:shopIconIamge];
    
    UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 170, 200, 20)];
    tips1.text = @"你的购物车还是空的";
    tips1.textAlignment = NSTextAlignmentCenter;
    tips1.textColor = [UIColor darkGrayColor];
    tips1.font = [UIFont fontWithName:@"Arial" size:16];
    [grayView addSubview:tips1];
    
    UILabel *tips2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 190, 200, 20)];
    tips2.text = @"选几件必备的东西吧！";
    tips2.textAlignment = NSTextAlignmentCenter;
    tips2.textColor = [UIColor lightGrayColor];
    tips2.font = [UIFont fontWithName:@"Arial" size:12];
    [grayView addSubview:tips2];
    
    UIButton *gotoBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 230, 140, 30)];
    [gotoBuyBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    gotoBuyBtn.layer.cornerRadius = 3;
    [gotoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gotoBuyBtn addTarget:self action:@selector(gotobuy:) forControlEvents:UIControlEventTouchUpInside];
    gotoBuyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [grayView addSubview:gotoBuyBtn];
    
}


#pragma mark - shoppingCartTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allGoodsLists.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell"];
    //降价标志
    cell.reducebackImage.hidden = YES;
    cell.reduceLabel.hidden = YES;
//    if (indexPath.row == 0) {
//        cell.reduceLabel.hidden = NO;
//        cell.reducebackImage.hidden = NO;
//    }
    cell.imageBackView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    cell.imageBackView.layer.borderWidth = 0.3;
    cell.iconMoneyLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    cell.productPrice.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    [cell.checkBoxBtn addTarget:self action:@selector(checkBoxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkBoxBtn.tag = indexPath.row + 100;
    [cell.reduceBtn addTarget:self action:@selector(reduceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.reduceBtn.tag = indexPath.row + 200;
    [cell.plusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.plusBtn.tag = indexPath.row + 300;
    number = [allGoodsLists[indexPath.row][@"productNum"]intValue];
    cell.productNumLabel.text = [NSString stringWithFormat:@"%d",[numberArr[indexPath.row]intValue]];
    
    //赋值
    cell.productName.text = allGoodsLists[indexPath.row][@"productName"];
    cell.productIntroductionLabel.text = allGoodsLists[indexPath.row][@"productSize"];
    cell.productPrice.text = allGoodsLists[indexPath.row][@"productPrice"];
    cell.productMarket.text = [NSString stringWithFormat:@"￥%@",allGoodsLists[indexPath.row][@"productMarketPrice"]];
    [cell.productPic loadImageFromURL:[NSURL URLWithString:allGoodsLists[indexPath.row][@"productPic"]]];
    
    //市场价加删除线
    NSUInteger length = [cell.productMarket.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.productMarket.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
    [cell.productMarket setAttributedText:attri];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *headview = [[UIView alloc] init];
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 20)];
        headLabel.text = [NSString stringWithFormat:@"所有商品(%d)",(int)allGoodsLists.count];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.textColor = [UIColor darkTextColor];
        headLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [headview addSubview:headLabel];
        
        UIButton *pulldownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pulldownBtn setImage:[UIImage imageNamed:@"pull-down"] forState:UIControlStateNormal];
        pulldownBtn.frame = CGRectMake(190, 5, 30, 30);
        [pulldownBtn addTarget:self action:@selector(pulldownBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:pulldownBtn];
        return headview;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色

}

#pragma mark 左滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"indexPath.row===%ld",(long)indexPath.row);
        [self requestDeleteData:indexPath];
        
    }
}

#pragma mark - Method

#pragma mark 去逛逛按钮方法
-(void)gotobuy:(UIButton *)btn{
    NSLog(@"去逛逛");
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root selectAtIndex:10];
}


#pragma mark 删除cell请求
-(void)requestDeleteData:(NSIndexPath *)indexpath{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/deleteGoodsProductNum"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    deleteIndexpath = indexpath;
    
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"eMark":allGoodsLists[indexpath.row][@"eMark"],@"ProductID":allGoodsLists[indexpath.row][@"productId"],@"uniquedid":uniquedid,@"iShopCart":allGoodsLists[indexpath.row][@"iShopCart"]};
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}




#pragma mark 下拉按钮方法
-(void)pulldownBtnAction:(UIButton *)btn{
    NSLog(@"点击下拉按钮");
    CGPoint point = CGPointMake(160, 104);
    NSArray *titles = @[@"全部商品", @"降价商品"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        if (index == 0) {
            NSLog(@"全部商品");
        }else if (index == 1){
            NSLog(@"降价商品");
        }
    };
    [pop show];

}


#pragma mark 复选按钮方法
-(void)checkBoxBtnAction:(UIButton *)btn{
    ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-100 inSection:0]];
    cell.checkBoxBtn.selected = !cell.checkBoxBtn.selected;
    if (cell.checkBoxBtn.selected == YES) {
        [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
    }else if (cell.checkBoxBtn.selected == NO){
        [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
    }
    
    [self amountPrice];
}


#pragma mark 减号按钮方法
-(void)reduceBtnAction:(UIButton *)btn{
    number = [numberArr[btn.tag-200]intValue];
    ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-200 inSection:0]];
    number--;
    if (number >= 1) {
        cell.productNumLabel.text = [NSString stringWithFormat:@"%d",number];
    }else{
        number = 1;
        cell.productNumLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    [numberArr replaceObjectAtIndex:btn.tag-200 withObject:[NSString stringWithFormat:@"%d",number]];
    [self requestChangeProductNumber:(int)btn.tag-200 productNum:numberArr[btn.tag-200]];
    [self amountPrice];
}

#pragma mark 加号按钮方法
-(void)plusBtnAction:(UIButton *)btn{
    number = [numberArr[btn.tag-300]intValue];
    ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-300 inSection:0]];
    number++;
    cell.productNumLabel.text = [NSString stringWithFormat:@"%d",number];
    [numberArr replaceObjectAtIndex:btn.tag-300 withObject:[NSString stringWithFormat:@"%d",number]];
    [self requestChangeProductNumber:(int)btn.tag-300 productNum:numberArr[btn.tag-300]];
    [self amountPrice];
}

#pragma mark 未完成订单请求
-(void)requestChangeProductNumber:(int)tagFlag productNum:(NSString *)productNum{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/changeGoodsProductNum"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //参数
    NSDictionary *parameters = @{@"accesstoken":accesstoken,@"eMark":allGoodsLists[tagFlag][@"eMark"],@"ProductID":allGoodsLists[tagFlag][@"productId"],@"uniquedid":uniquedid,@"productNum":productNum,@"iShopCart":allGoodsLists[tagFlag][@"iShopCart"]};
    NSLog(@"parameters===%@",parameters);
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}


#pragma mark 全选按钮方法
- (IBAction)allCheckBoxBtn:(UIButton *)sender {
    NSLog(@"点击全选按钮");
    _allcheckBtn.selected = !_allcheckBtn.selected;
    if (_allcheckBtn.selected == YES) {
        [_allcheckBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        for (int i = 0; i < 4; i++) {
            ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.checkBoxBtn.selected = YES;
            [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox（did）"] forState:UIControlStateNormal];
        }
    }else if (_allcheckBtn.selected == NO){
        [_allcheckBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        for (int i = 0; i < 4; i++) {
            ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.checkBoxBtn.selected = NO;
            [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
        }
    }
    
    [self amountPrice];
}

-(void)amountPrice{
    float amount = 0;
    for (int i = 0; i < 4; i++) {
        ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.checkBoxBtn.selected == YES) {
            amount += [cell.productPrice.text floatValue]*[cell.productNumLabel.text floatValue];
        }
    }
    _amountPriceLabel.text = [NSString stringWithFormat:@"%.2f",amount];
}


-(void)amountIds{
    selectedNumber = 0;
    NSDictionary *contentdic;
    carGoodsIds = [[NSMutableArray alloc] init];
    for (int i = 0; i < allGoodsLists.count; i++) {
        ShoppingCartCell *cell = (ShoppingCartCell *)[shoppingCartTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.checkBoxBtn.selected == YES) {
            contentdic = @{@"pCode":allGoodsLists[i][@"productId"],@"mark":allGoodsLists[i][@"eMark"],@"Number":numberArr[i],@"ShopCartType":allGoodsLists[i][@"iShopCart"]};
            NSLog(@"contentdic");
            [carGoodsIds addObject:contentdic];
            selectedNumber++;
        }
    }
}



#pragma mark 结算按钮方法
- (IBAction)sumBtn:(UIButton *)sender {
    NSLog(@"点击结算按钮");
    [self amountIds];
    if (selectedNumber > 0) {
        if (accesstoken.length > 0 && carGoodsIds.count > 0) {
            OrderSureViewController *orderSure = [[OrderSureViewController alloc] init];
            orderSure.carGoodsIds = carGoodsIds;
            [self.navigationController pushViewController:orderSure animated:YES];
        }else if (accesstoken.length == 0){
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }else if (carGoodsIds.count == 0){
            NSLog(@"请勾选要结算的订单！");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)judgeKong{
    if (allGoodsLists.count == 0) {
        grayView.hidden = NO;
        shoppingCartTable.hidden = YES;
        _jiesuanView.hidden = YES;
    }else{
        grayView.hidden = YES;
        shoppingCartTable.hidden = NO;
        _jiesuanView.hidden = NO;
        [shoppingCartTable reloadData];
    }
}

#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [[Loading shareLoading] endLoading];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                if (allGoodsLists == nil) {
                    allGoodsLists = [NSMutableArray arrayWithArray:object[@"info"][@"allGoodsLists"]];
                }else{
                    if ([object[@"info"][@"allGoodsLists"]count] > 0) {
                        [allGoodsLists addObjectsFromArray:object[@"info"][@"allGoodsLists"]];
                    }else{
                        if (isRefresh == YES) {
                            [self showToast:@"没有更多的数据可以加载"];
                        }
                    }
                }
                
                [self judgeKong];
                [numberArr removeAllObjects];
                for (int i = 0; i < allGoodsLists.count; i++) {
                    [numberArr addObject:allGoodsLists[i][@"productNum"]];
                }
                [shoppingCartTable reloadData];
                currentpage++;
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                
                [allGoodsLists removeObjectAtIndex:deleteIndexpath.row];  //删除数组里的数据
                [shoppingCartTable deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:deleteIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                [self showToast:@"删除成功！"];
                [self judgeKong];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"修改成功！"];
            }else{
               [self showToast:object[@"msg"]];
            }
        }
    }
}


-(void)shopCartFooterRereshing{
    isRefresh = YES;
    [self requestShopCartData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [shoppingCartTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [shoppingCartTable footerEndRefreshing];
    });
}

@end
