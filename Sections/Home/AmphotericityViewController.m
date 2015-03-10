//
//  AmphotericityViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/30.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AmphotericityViewController.h"
#import "RootTabBarController.h"
#import "ChinaAndForeginDrugCell.h"
#import "AmphotericityLabelCell.h"
#import "MJRefresh.h"
#import "ProductDetailViewController.h"
@interface AmphotericityViewController ()
{
    UITableView *amphotericityTable;
    NSMutableArray *_dataArray;
    BOOL isopen;
    NSArray *titleArr;
    UIImageView *cursorImage;
    CGFloat widthValue;
    int flag;
    int value;
    int value2;
    int currentpage;
    int pageRows;
    NSMutableArray *productInfoArr;
    NSMutableArray *imagesArr;
    NSMutableArray *leftInfoArr;
    NSMutableArray *rightInfoArr;
    NSString *tempId;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation AmphotericityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"两性健康";
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    amphotericityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    amphotericityTable.delegate = self;
    amphotericityTable.dataSource = self;
    amphotericityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    amphotericityTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:amphotericityTable];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_dataArray addObject:[NSNumber numberWithBool:NO]];

    //注册xib
    [amphotericityTable registerNib:[UINib nibWithNibName:@"ChinaAndForeginDrugCell" bundle:nil] forCellReuseIdentifier:@"chinaAndForegineCell"];
    [amphotericityTable registerNib:[UINib nibWithNibName:@"AmphotericityLabelCell" bundle:nil] forCellReuseIdentifier:@"amphotericityCell"];
    
    // 集成两性健康刷新控件
    [self setuptwoSexRefresh];
    
    titleArr = @[@"性福生活",@"女用器具",@"男用器具",@"情趣用品"];
    widthValue = 10;
    flag = 0;
    value2 = 0;
    value = 0;
}


- (void)setuptwoSexRefresh
{
    // 上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [amphotericityTable addFooterWithTarget:self action:@selector(twoSexFooterRereshing)];
    
    amphotericityTable.footerPullToRefreshText = @"上拉加载更多";
    amphotericityTable.footerReleaseToRefreshText = @"松开马上加载更多";
    amphotericityTable.footerRefreshingText = @"正在帮你加载中.....";
}

#pragma mark 两性健康请求
-(void)requestTwoSexData:(NSString *)classId{
    
    [[Loading shareLoading]beginLoading];
    NSDictionary *parameters = @{@"id":@"1",@"currentpage":[NSString stringWithFormat:@"%d",currentpage],@"pagerows":[NSString stringWithFormat:@"%d",pageRows],@"classId":classId};
    NSLog(@"parameters====%@,self.class====%@",parameters,self.class);
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getMore"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
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
    tempId = @"04";
    [self requestTwoSexData:tempId];
}


#pragma mark - waitForReciveTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([_dataArray[section] intValue] == 0) {
            return 0;
        }else{
            return 1;
        }
    }else if (section == 2){
        return productInfoArr.count/2;
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            AmphotericityLabelCell *cell_typeLabel = (AmphotericityLabelCell *)[tableView dequeueReusableCellWithIdentifier:@"amphotericityCell"];
            [cell_typeLabel.label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeData:)]];
            [cell_typeLabel.label2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeData:)]];
            cell_typeLabel.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell_typeLabel.curisonImageView.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            if (flag == 0) {
                cell_typeLabel.curisonImageView.hidden = YES;
            }else if (flag == 1){
                cell_typeLabel.curisonImageView.hidden = NO;
                cell_typeLabel.curisonImageView.frame = CGRectMake(10+70*value, 23+26*value2, 50, 3);
            }
            cell_typeLabel.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell_typeLabel;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"cellMark";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            UIScrollView *headScrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
            headScrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*(imagesArr.count), 180);
            headScrollow.pagingEnabled = YES;
            headScrollow.tag = 2000;
            headScrollow.delegate = self;
            headScrollow.showsHorizontalScrollIndicator = NO;
            [cell.contentView addSubview:headScrollow];
            
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, 160, 50, 18)];
            pageControl.numberOfPages = imagesArr.count;
            pageControl.currentPage = 0;
            pageControl.tag = 3000;
            pageControl.tintColor = [UIColor blackColor];
            pageControl.currentPageIndicatorTintColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            [pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:pageControl];
            
            
            for (int i = 0; i < imagesArr.count; i++) {
                JKWebImageView *imageView = [[JKWebImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, 180)];
                [imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imagesArr[i][@"head_img"]]]];
                imageView.userInteractionEnabled = YES;
                imageView.tag = 800+i;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
                [headScrollow addSubview:imageView];
            }

            
            return cell;
        }
            break;
        case 2:
        {
            ChinaAndForeginDrugCell *cell_china = (ChinaAndForeginDrugCell *)[tableView dequeueReusableCellWithIdentifier:@"chinaAndForegineCell"];
            cell_china.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            [cell_china.leftCheckBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_china.leftCheckBtn.tag = 500+indexPath.row;
            
            [cell_china.rightCheckBtn addTarget:self action:@selector(checkAction1:) forControlEvents:UIControlEventTouchUpInside];
            cell_china.rightCheckBtn.tag = 600+indexPath.row;
            cell_china.leftOurPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            cell_china.rightOurPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            
            //左边赋值
            if (leftInfoArr.count > 0) {
                cell_china.leftOurPriceLabel.text = [NSString stringWithFormat:@"￥%@",leftInfoArr[indexPath.row][@"productPrice"]];
                cell_china.leftMarketPriceLabel.text = [NSString stringWithFormat:@"市场价:￥%@",leftInfoArr[indexPath.row][@"productMarketPrice"]];
                cell_china.leftnameLabel.text = leftInfoArr[indexPath.row][@"productName"];
                cell_china.leftUselabel.text = leftInfoArr[indexPath.row][@"productEffect"];
                [cell_china.leftImage loadImageFromURL:[NSURL URLWithString:leftInfoArr[indexPath.row][@"productPic"]]];
            }
            //右边赋值
            if (rightInfoArr.count > 0) {
                cell_china.rightOurPriceLabel.text = [NSString stringWithFormat:@"￥%@",rightInfoArr[indexPath.row][@"productPrice"]];
                cell_china.rightMarketPriceLabel.text = [NSString stringWithFormat:@"市场价:￥%@",rightInfoArr[indexPath.row][@"productMarketPrice"]];
                cell_china.rightNameLabel.text = rightInfoArr[indexPath.row][@"productName"];
                cell_china.rightUseLabel.text = rightInfoArr[indexPath.row][@"productEffect"];
                [cell_china.rightImage loadImageFromURL:[NSURL URLWithString:rightInfoArr[indexPath.row][@"productPic"]]];
            }

            
            
            //市场价：
            NSUInteger length = [cell_china.leftMarketPriceLabel.text length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell_china.leftMarketPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
            [cell_china.leftMarketPriceLabel setAttributedText:attri];
            
            
            NSUInteger length1 = [cell_china.rightMarketPriceLabel.text length];
            NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:cell_china.rightMarketPriceLabel.text];
            [attri1 addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length1)];
            [attri1 addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length1)];
            [cell_china.rightMarketPriceLabel setAttributedText:attri1];
            
            
            cell_china.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell_china;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
        for (int i = 0; i < 4; i++) {
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+70*i, 5, 50, 20)];
            typeLabel.textColor = [UIColor blackColor];
            typeLabel.text = titleArr[i];
            typeLabel.userInteractionEnabled = YES;
            typeLabel.tag = 200+i;
            [typeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDataTwo:)]];
            typeLabel.font = [UIFont fontWithName:@"Arial" size:12];
            typeLabel.textAlignment = NSTextAlignmentLeft;
            [view addSubview:typeLabel];
        }
        
        cursorImage = [[UIImageView alloc] initWithFrame:CGRectMake(widthValue, 25, 50, 3)];
        cursorImage.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
        if (flag == 0) {
            cursorImage.hidden = NO;
        }else if (flag == 1){
            cursorImage.hidden = YES;
        }
        
        [view addSubview:cursorImage];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40, 5, 40, 20)];
        [btn setImage:[UIImage imageNamed:@"presentAll"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showType:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
        
    }
    return 0;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    
}

#pragma mark - scrollowView_delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.tag == 2000){
        UIScrollView *headScrollow = (UIScrollView *)[self.view viewWithTag:2000];
        CGFloat pagewidth = headScrollow.frame.size.width;
        int page = floor((headScrollow.contentOffset.x - pagewidth/([imagesArr count]+2))/pagewidth)+1;
        UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:3000];
        pageControl.currentPage = page;
        NSLog(@"page===%d",page);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 2000:
        {
            UIScrollView *headScrollow = (UIScrollView *)[self.view viewWithTag:2000];
            CGFloat pagewidth = headScrollow.frame.size.width;
            int currentPage = floor((headScrollow.contentOffset.x - pagewidth/ ([imagesArr count]+2)) / pagewidth) + 1;
            if (currentPage==0) {
                [headScrollow scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)  animated:NO];
            }
            else if (currentPage==([imagesArr count]+1)) {
                //如果是最后+1,也就是要开始循环的第一个
                [headScrollow scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)  animated:NO];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark - Method
#pragma mark pageControlMehod
-(void)pageAction
{
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:3000];
    int page = (int)pageControl.currentPage;
    UIScrollView *scrollow = (UIScrollView *)[self.view viewWithTag:2000];
    [scrollow setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * (page+1), 0)];
}

#pragma mark tableHead视图点击手势方法
-(void)imageTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"gesture.view.tag=====%d",(int)gesture.view.tag);
}

#pragma mark 查看详情按钮方法
-(void)checkAction:(UIButton *)btn{
    NSLog(@"btn.tag-500==indexpath.row=%d",(int)btn.tag-500);
    ProductDetailViewController *product = [[ProductDetailViewController alloc] init];
    product.priductCode = leftInfoArr[btn.tag-500][@"productId"];
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark 查看详情按钮方法
-(void)checkAction1:(UIButton *)btn{
    NSLog(@"btn.tag-600=indexpath.row==%d",(int)btn.tag-600);
    ProductDetailViewController *product = [[ProductDetailViewController alloc] init];
    product.priductCode = rightInfoArr[btn.tag-600][@"productId"];
    [self.navigationController pushViewController:product animated:YES];
}


#pragma mark 显示类型
-(void)showType:(UIButton *)btn{
    NSNumber *number = _dataArray[0];
    isopen = [number boolValue];
    isopen = !isopen;
    number = [NSNumber numberWithDouble:isopen];
    _dataArray[0] = number;
    
    
    [amphotericityTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark 类型切换手势方法
-(void)changeDataTwo:(UITapGestureRecognizer *)gesture{
    flag = 0;
    cursorImage.hidden = NO;
    widthValue = 10+70*(gesture.view.tag-200);
    currentpage = 1;
    [productInfoArr removeAllObjects];
    [amphotericityTable reloadData];

    switch (gesture.view.tag) {
        case 200:
        {
            tempId = @"04";
        }
            break;
        case 201:
        {
            tempId = @"0401";
        }
            break;
        case 202:
        {
            tempId = @"0402";
        }
            break;
        case 203:
        {
            tempId = @"0403";
        }
            break;
        default:
            break;
    }
    NSLog(@"tempId==11111==%@,self.class===%@",tempId,self.class);
    [self requestTwoSexData:tempId];
}


#pragma mark 类型切换手势方法
-(void)changeData:(UITapGestureRecognizer *)gesture{
    value = (gesture.view.tag-301)%4;
    value2 = (int)(gesture.view.tag-301)/4;
    NSLog(@"value ==== %d,value2===%d",value,(int)gesture.view.tag);
    flag = 1;
    currentpage = 1;
    [productInfoArr removeAllObjects];
    [amphotericityTable reloadData];
    
    switch (gesture.view.tag) {
        case 301:
        {
            tempId = @"0404";
        }
            break;
        case 302:
        {
            tempId = @"0405";
        }
            break;
        default:
            break;
    }
    NSLog(@"tempId==22222==%@,self.class===%@",tempId,self.class);
    [self requestTwoSexData:tempId];
    
    
}

#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    NSLog(@"点击搜索按钮");
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
                leftInfoArr = [[NSMutableArray alloc] init];
                rightInfoArr = [[NSMutableArray alloc] init];
                if (productInfoArr == nil) {
                    productInfoArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"productResults"]];
                }else{
                    if ([object[@"info"][@"productResults"]count] > 0) {
                        [productInfoArr addObjectsFromArray:object[@"info"][@"productResults"]];
                    }else{
                        [self showToast:@"没有更多的数据可以加载"];
                    }
                }
                
                [leftInfoArr removeAllObjects];
                [rightInfoArr removeAllObjects];
                for (int i = 0; i < productInfoArr.count; i++) {
                    if (i%2 == 0) {
                        [leftInfoArr addObject:productInfoArr[i]];
                    }else{
                        [rightInfoArr addObject:productInfoArr[i]];
                    }
                }
                NSLog(@"leftInfoArr====%@,rightInfoArr===%@",leftInfoArr,rightInfoArr);
                imagesArr = [[NSMutableArray alloc] initWithArray:object[@"info"][@"imgList"]];
                [amphotericityTable reloadData];
                currentpage++;
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }
}


-(void)twoSexFooterRereshing{
    [self requestTwoSexData:tempId];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [amphotericityTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [amphotericityTable footerEndRefreshing];
    });
}


@end
