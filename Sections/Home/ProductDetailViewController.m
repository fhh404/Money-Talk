//
//  ProductDetailViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/30.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "RootTabBarController.h"
#import "FristProductCell.h"
#import "SecondProductCell.h"
#import "ThirdProductCell.h"
#import "FourthProductCell.h"
#import "FifthProductCell.h"
#import "SixProductCell.h"
#import "UserEvaluteViewController.h"
#import "DoctorRecommendationViewController.h"
#import "UserIntroductionViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface ProductDetailViewController ()
{
    UITableView *productDetailTable;
    UIScrollView *headScrollow;
    UIPageControl *pageControl;
    NSMutableArray *scrollowImages;
    NSMutableDictionary *dataDic;
    NSMutableString *productDescription;
    int productNumber;
    NSString *accesstoken;
    NSString *uniquedid;
    int eMark;
    int iShopCart;
    BOOL isJoin;
    UIView *grayBackView;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

@end

@implementation ProductDetailViewController
@synthesize priductCode;

static CGFloat const SCROLL_IMAGE_HEIGHT = 155;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详细页面";
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    [self addRightBarButtonItem:searchBtn];

    productDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
    productDetailTable.delegate = self;
    productDetailTable.dataSource = self;
    productDetailTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    productDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:productDetailTable];
    
    //注册xib
    [productDetailTable registerNib:[UINib nibWithNibName:@"FristProductCell" bundle:nil] forCellReuseIdentifier:@"fristProductCell"];
    [productDetailTable registerNib:[UINib nibWithNibName:@"SecondProductCell" bundle:nil] forCellReuseIdentifier:@"secondProductCell"];
    [productDetailTable registerNib:[UINib nibWithNibName:@"ThirdProductCell" bundle:nil] forCellReuseIdentifier:@"thirdProductCell"];
    [productDetailTable registerNib:[UINib nibWithNibName:@"FourthProductCell" bundle:nil] forCellReuseIdentifier:@"fourthProductCell"];
    [productDetailTable registerNib:[UINib nibWithNibName:@"FifthProductCell" bundle:nil] forCellReuseIdentifier:@"fifthProductcell"];
    [productDetailTable registerNib:[UINib nibWithNibName:@"SixProductCell" bundle:nil] forCellReuseIdentifier:@"sixproductCell"];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    productNumber = 1;
    eMark = 1;
    iShopCart = 1;
    isJoin = NO;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    NSLog(@"self.priductCode====%@",self.priductCode);
    if (self.priductCode != nil) {
        [self requestProductDetailData];
    }else{
        
    }

}

-(void)requestProductDetailData{
    [[Loading shareLoading] beginLoading];
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getProductDetials"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
//    self.priductCode = @"28";
    NSDictionary *parameters = @{@"priductCode":self.priductCode};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}


#pragma mark - scrollowView_delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.tag == 2000){
        
        CGFloat pagewidth = headScrollow.frame.size.width;
        int page = floor((headScrollow.contentOffset.x - pagewidth/([scrollowImages count]+2))/pagewidth)+1;
        pageControl.currentPage = page;
        NSLog(@"page===%d",page);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 2000:
        {
            CGFloat pagewidth = headScrollow.frame.size.width;
            int currentPage = floor((headScrollow.contentOffset.x - pagewidth/ ([scrollowImages count]+2)) / pagewidth) + 1;
            if (currentPage==0) {
                [headScrollow scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCROLL_IMAGE_HEIGHT)  animated:NO];
            }
            else if (currentPage==([scrollowImages count]+1)) {
                //如果是最后+1,也就是要开始循环的第一个
                [headScrollow scrollRectToVisible:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCROLL_IMAGE_HEIGHT)  animated:NO];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - productDetailTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return [dataDic[@"recommendation"]count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 80;
        }
            break;
        case 1:
        {
            return 270;
        }
            break;

        case 2:
        {
            NSString *str = dataDic[@"productInfo"][@"productEffect"];
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [str boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            return sizeText.height+50;
        }
            break;
        case 3:
        {
            return 40;
        }
            break;
        case 4:
        {
            return 265;
        }
            break;
            
        case 5:
        {
            return 40;
        }
            break;
        case 6:
        {
            return 60;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 40;
    }else if (section == 0){
        return 5;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section== 0) {
        return 1;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            FristProductCell *cell_frist = (FristProductCell *)[tableView dequeueReusableCellWithIdentifier:@"fristProductCell"];
            cell_frist.backgroundColor = [UIColor whiteColor];
            cell_frist.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell_frist.collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell_frist.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_frist.drugNameLabel.text = dataDic[@"productInfo"][@"productName"];
            cell_frist.companyNameLabel.text = dataDic[@"productInfo"][@"Manufacturer"];
            cell_frist.guigeLabel.text = dataDic[@"productInfo"][@"productSize"];
            
            return cell_frist;
        }
            break;
        case 1:
        {
            SecondProductCell *cell_second = (SecondProductCell *)[tableView dequeueReusableCellWithIdentifier:@"secondProductCell"];
            cell_second.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell_second.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_second.couponInfoLabel.text = dataDic[@"productInfo"][@"productSpecialInfo"];
            //@"优惠信息：2盒起【包邮】，5盒以上150元/盒，13盒以上144元/盒，25盒以上143.5元/盒,30盒以上143元/盒.";
            cell_second.couponInfoLabel.numberOfLines = 0;
            [cell_second.couponInfoLabel sizeToFit];
            
            cell_second.ourPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            cell_second.ourPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataDic[@"productInfo"][@"ourPrice"]];
            cell_second.marketPriceLabel.text =[NSString stringWithFormat:@"市场价:￥%@",dataDic[@"productInfo"][@"marketPrice"]];
            cell_second.addNoticeBtn.backgroundColor = [UIColor whiteColor];
            cell_second.addNoticeBtn.layer.cornerRadius = 5;
            [cell_second.addNoticeBtn setImage:[UIImage imageNamed:@"notice"] forState:UIControlStateNormal];
            [cell_second.addNoticeBtn addTarget:self action:@selector(addNoticeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_second.addNoticeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 75);
            cell_second.addNoticeBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 10);
            
            cell_second.useDrugBtn.backgroundColor = [UIColor whiteColor];
            cell_second.useDrugBtn.layer.cornerRadius = 5;
            [cell_second.useDrugBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
            [cell_second.useDrugBtn addTarget:self action:@selector(useDrugBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_second.useDrugBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 75);
            cell_second.useDrugBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 10);
            
            
            [cell_second.addNumberBtn addTarget:self action:@selector(addNumberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell_second.decadeNumberBtn addTarget:self action:@selector(decadeNumberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_second.productNumberLabel.text = [NSString stringWithFormat:@"%d",productNumber];
            if (isJoin == YES) {
                cell_second.hasProductLabel.text = @"【有货】";
            }else if (isJoin == NO) {
                cell_second.hasProductLabel.text = @"【缺货】";
            }
            return cell_second;
        }
            break;
        case 2:
        {
            ThirdProductCell *cell_third = (ThirdProductCell *)[tableView dequeueReusableCellWithIdentifier:@"thirdProductCell"];
            cell_third.backgroundColor = [UIColor whiteColor];
            cell_third.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_third.contentLabel.text = dataDic[@"productInfo"][@"productEffect"];
            //@"辛凉解表，清热解毒。用于流行性感冒引起的头痛、咳嗽、口干、咽喉疼痛。";
            UIFont *tfont = [UIFont systemFontOfSize:16];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize sizeText = [cell_third.contentLabel.text boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            cell_third.contentLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
            cell_third.contentLabel.textColor = [UIColor lightGrayColor];
            cell_third.contentLabel.numberOfLines = 0;
            [cell_third.contentLabel sizeToFit];
            
            return cell_third;
        }
            break;

        case 3:
        {
            FifthProductCell *cell_fifth = (FifthProductCell *)[tableView dequeueReusableCellWithIdentifier:@"fifthProductcell"];
            cell_fifth.backgroundColor = [UIColor whiteColor];
            cell_fifth.typeImage.image = [UIImage imageNamed:@"productIntroduction"];
            cell_fifth.typeLabel.text = @"产品说明书";
            return cell_fifth;
        }
            break;

        case 4:
        {
            FourthProductCell *cell_fourth = (FourthProductCell *)[tableView dequeueReusableCellWithIdentifier:@"fourthProductCell"];
            cell_fourth.backgroundColor = [UIColor whiteColor];
            cell_fourth.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_fourth.lightGrayView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell_fourth.backGrayImage.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
            cell_fourth.backGrayImage.layer.cornerRadius = 3;
            cell_fourth.itemNumberLabel.text = [NSString stringWithFormat:@"方案%d",(int)indexPath.row+1];
            cell_fourth.suitPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            cell_fourth.checkMoreBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#61b1f4"].CGColor;
            cell_fourth.checkMoreBtn.layer.borderWidth = 0.2;
            cell_fourth.checkMoreBtn.tag = 900 +indexPath.row;
            [cell_fourth.checkMoreBtn addTarget:self action:@selector(checkMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_fourth.checkMoreBtn.layer.cornerRadius = 3;
            cell_fourth.buyNowBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            [cell_fourth.buyNowBtn addTarget:self action:@selector(buyNowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_fourth.buyNowBtn.tag = 800+indexPath.row;
            cell_fourth.buyNowBtn.layer.cornerRadius = 3;
            
            //市场价：
            NSUInteger length = [cell_fourth.originalPriceLabel.text length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell_fourth.originalPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(50, 50, 50) range:NSMakeRange(0, length)];
            [cell_fourth.originalPriceLabel setAttributedText:attri];

            //scrollow
            int numbers = (int)[dataDic[@"recommendation"][indexPath.row][@"teamProducts"] count];
            NSArray *productArr = dataDic[@"recommendation"][indexPath.row][@"teamProducts"];
            cell_fourth.productScrollow.contentSize = CGSizeMake(100*numbers, 110);
            for (int i = 0; i < numbers; i++) {
                JKWebImageView *productImage = [[JKWebImageView alloc] initWithFrame:CGRectMake(20+100*i, 12, 60, 70)];
                productImage.tag = 500+i;
                [productImage loadImageFromURL:[NSURL URLWithString:productArr[i][@"productPic"]]];
                [cell_fourth.productScrollow addSubview:productImage];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5+100*i, 85, 90, 20)];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont fontWithName:@"Arial" size:8];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = productArr[i][@"productName"];
                [cell_fourth.productScrollow addSubview:label];
                
                if (i != numbers-1) {
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(90+100*i, 37, 20, 20)];
                    image.image = [UIImage imageNamed:@"bingliejiahao"];
                    [cell_fourth.productScrollow addSubview:image];
                }
            }
            return cell_fourth;
        }
            break;

        case 5:
        {
            FifthProductCell *cell_fifth = (FifthProductCell *)[tableView dequeueReusableCellWithIdentifier:@"fifthProductcell"];
            cell_fifth.backgroundColor = [UIColor whiteColor];
            cell_fifth.typeImage.image = [UIImage imageNamed:@"userComment@2x"];
            cell_fifth.typeLabel.text = @"用户评论";
            return cell_fifth;
        }
            break;
        case 6:
        {
            SixProductCell *cell_six = (SixProductCell *)[tableView dequeueReusableCellWithIdentifier:@"sixproductCell"];
            cell_six.backgroundColor = [UIColor whiteColor];
            cell_six.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_six.buyBtn.layer.cornerRadius = 3;
            cell_six.buyBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
            [cell_six.buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell_six.buyBtn setImage:[UIImage imageNamed:@"yangBtn"] forState:UIControlStateNormal];
            cell_six.buyBtn.titleEdgeInsets = UIEdgeInsetsMake(3,20, 2, 20);
            cell_six.buyBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 70);
            
            cell_six.jionBtn.layer.cornerRadius = 3;
            cell_six.jionBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
            [cell_six.jionBtn addTarget:self action:@selector(jionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell_six.jionBtn setImage:[UIImage imageNamed:@"shopCartBtn(white)"] forState:UIControlStateNormal];
            cell_six.jionBtn.titleEdgeInsets = UIEdgeInsetsMake(3,20, 2, 10);
            cell_six.jionBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 15, 2, 75);
            return cell_six;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 16, 16)];
        image.image = [UIImage imageNamed:@"item"];
        [view addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 120, 20)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"Arial" size:15];
        label.text = @"药师推荐";
        [view addSubview:label];
        
        return view;
    }
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色

    if (indexPath.section == 5) {
        UserEvaluteViewController *userEvalute = [[UserEvaluteViewController alloc] init];
        userEvalute.priductId = dataDic[@"productInfo"][@"productCode"];
        [self.navigationController pushViewController:userEvalute animated:YES];
    }else if (indexPath.section == 3){
        if ([dataDic[@"productInfo"][@"productDescription"] length] > 0) {
            UserIntroductionViewController *userIntroduction = [[UserIntroductionViewController alloc] init];
            userIntroduction.htmlString = dataDic[@"productInfo"][@"productDescription"];
            [self.navigationController pushViewController:userIntroduction animated:YES];
        }else{
            NSLog(@"没有数据");
        }
    }
}



#pragma mark - Method
#pragma mark pageControlMehod
-(void)pageAction
{
    int page = (int)pageControl.currentPage;
    [headScrollow setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * (page+1), 0)];
    
}

#pragma mark tableHead视图点击手势方法
-(void)imageTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"gesture.view.tag=====%d",(int)gesture.view.tag);
}



#pragma mark 增加商品数量按钮方法
-(void)addNumberBtnAction:(UIButton *)btn{
    SecondProductCell *cell = (SecondProductCell *)[productDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    productNumber++;
    cell.productNumberLabel.text = [NSString stringWithFormat:@"%d",productNumber];
}

#pragma mark 增加商品数量按钮方法
-(void)decadeNumberBtnAction:(UIButton *)btn{
    SecondProductCell *cell = (SecondProductCell *)[productDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    productNumber--;
    if (productNumber >= 1) {
        cell.productNumberLabel.text = [NSString stringWithFormat:@"%d",productNumber];
    }else{
        productNumber = 1;
        cell.productNumberLabel.text = [NSString stringWithFormat:@"%d",productNumber];
    }
}


#pragma mark 立即购买按钮方法
-(void)buyBtnAction:(UIButton *)btn{
    
}


#pragma mark 加入购物车按钮方法
-(void)jionBtnAction:(UIButton *)btn{
    NSLog(@"加入购物车");
    
    if (accesstoken == nil) {
        accesstoken = @"";
    }
    NSLog(@"accesstoken======%@",accesstoken);
    uniquedid = [[MyUserDefaults defaults] readFromUserDefaults:@"uniquedid"];
    if (uniquedid.length > 0 && isJoin == YES) {
        [self requestJionShopCartData];
    }else if (uniquedid.length == 0){
        NSLog(@"设备号获取失败");
    }else if (isJoin == NO){
        NSLog(@"缺货或者已经下架！");
        [self showToast:@"缺货或者已经下架！"];
    }
    
}

#pragma mark 加入购物车请求
-(void)requestJionShopCartData{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/ShoppingCar/addShoppingCar"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    NSLog(@"priductCode====%@",self.priductCode);
    
    NSDictionary *parameters = @{@"ProductID":self.priductCode,@"uniquedid":uniquedid,@"accesstoken":accesstoken,@"number":[NSString stringWithFormat:@"%d",productNumber],@"eMark":[NSString stringWithFormat:@"%d",eMark],@"iShopCart":[NSString stringWithFormat:@"%d",iShopCart]};
    NSLog(@"parameters=======%@",parameters);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:200];
}

#pragma mark 查看更多按钮方法
-(void)checkMoreBtnAction:(UIButton *)btn{
    NSLog(@"btn.tag-900 ===== %d,dataDic====%@",(int)btn.tag-900,dataDic);
    DoctorRecommendationViewController *doctorRecommention = [[DoctorRecommendationViewController alloc] init];
    doctorRecommention.teamId = dataDic[@"recommendation"][(int)btn.tag-900][@"productcode"];
    [self.navigationController pushViewController:doctorRecommention animated:YES];
}

#pragma mark 购买组合按钮方法
-(void)buyNowBtnAction:(UIButton *)btn{
    NSLog(@"btn.tag-800 ===== %d",(int)btn.tag-800);
}

#pragma mark 添加用药提醒按钮方法
-(void)addNoticeBtnAction:(UIButton *)btn{
    NSLog(@"添加用药提醒按钮");
}

#pragma mark 用药咨询按钮方法
-(void)useDrugBtnAction:(UIButton *)btn{
    NSLog(@"用药咨询按钮");
}

#pragma mark 收藏按钮方法
-(void)collectionBtnAction:(UIButton *)btn{
    NSLog(@"收藏按钮");
    
    if (accesstoken.length > 0) {
        [self requestCollectProductData];
    }
}

#pragma mark 收藏按钮请求
-(void)requestCollectProductData{
    
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/addMyCollection"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    NSLog(@"priductCode====%@",self.priductCode);
    NSDictionary *parameters = @{@"ProductID":self.priductCode,@"accesstoken":accesstoken};
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:300];
}



#pragma mark 分享按钮方法
-(void)shareBtnAction:(UIButton *)btn{
    NSLog(@"分享按钮");
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"defaultPic@2x" ofType:@"png"];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.jianke.com/product/%@.html",self.priductCode];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:dataDic[@"productInfo"][@"productEffect"]
                                       defaultContent:@"健康商城"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:dataDic[@"productInfo"][@"productName"]
                                                  url:urlStr
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


#pragma mark 搜索按钮方法
- (void)searchBtn:(UIButton *)sender {
    NSLog(@"点击搜索按钮");
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                dataDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"info"]];
                NSString *productLeft = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[dataDic[@"productInfo"][@"productLeft"]intValue]]];
                if ([productLeft isEqualToString:@"2"]) {
                    isJoin = YES;
                }else{
                    isJoin = NO;
                }
                [self initTableHeadView];
                eMark = [dataDic[@"productInfo"][@"eMark"]intValue];
                iShopCart = [dataDic[@"productInfo"][@"iShopCart"]intValue];
                [productDetailTable reloadData];
                
             }else{
                 [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }
    }else if (tag == 200) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                productNumber = 1;
                NSLog(@"添加成功！");
                [self initShopCartSuceessUI];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }else if (tag == 300) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
            [self showToast:object[@"msg"]];
        } else {
            NSLog(@"%@,self.class===%@", object,self.class);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"添加收藏成功！"];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
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



-(void)initTableHeadView{
    [headScrollow removeFromSuperview];
    [pageControl removeFromSuperview];
    
    scrollowImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dataDic[@"imgList"]count]; i++) {
        [scrollowImages addObject:dataDic[@"imgList"][i]];
    }
    
    
    headScrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCROLL_IMAGE_HEIGHT)];
    headScrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*(scrollowImages.count), SCROLL_IMAGE_HEIGHT);
    headScrollow.pagingEnabled = YES;
    headScrollow.tag = 2000;
    headScrollow.delegate = self;
    headScrollow.showsHorizontalScrollIndicator = NO;
    productDetailTable.tableHeaderView = headScrollow;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, 135, 50, 18)];
    pageControl.numberOfPages = scrollowImages.count;
    pageControl.currentPage = 0;
    pageControl.tintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    [productDetailTable addSubview:pageControl];
    
    
    for (int i = 0; i < scrollowImages.count; i++) {
        JKWebImageView *imageView = [[JKWebImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, SCROLL_IMAGE_HEIGHT)];
        [imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",scrollowImages[i]]]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200+i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
        [headScrollow addSubview:imageView];
        
        
        UIImageView *OTCImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*(1+i)-45, 15, 30, 15)];
        OTCImage.image = [UIImage imageNamed:@"OTC"];
        [imageView addSubview:OTCImage];
    }
}


@end
