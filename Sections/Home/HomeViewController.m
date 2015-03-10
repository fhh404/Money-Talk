//
//  HomeViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import "HomeViewController.h"
#import <Foundation/Foundation.h>
#import "RootTabBarController.h"
#import "SearchViewController.h"
#import "AllTypesViewController.h"
#import "SuitTheCaseViewController.h"
#import "WaitForReciveViewController.h"
#import "SettingViewController.h"
#import "NewsBoxViewController.h"
#import "ShakeViewController.h"
#import "ChatViewController.h"
#import "ScanViewController.h"
#import "ChinaAndForeginDrugViewController.h"
#import "AmphotericityViewController.h"
#import "ProductDetailViewController.h"
#import "ActiveWebViewController.h"
#import "VoiceViewController.h"
#import "MJRefresh.h"

@interface HomeViewController ()
{
    SearchViewController *search;
    NSMutableArray *couldHelpIDArr;
    NSMutableArray *titleArr;
    NSMutableArray *contentArr;
    NSMutableArray *adImageUrlArr;
    NSMutableArray *chinaWesternMedicineArr;
    NSMutableArray *couldHelpImagesArr;
    NSMutableArray *drugIDArr;
    NSTimer *timer;
    int flag;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;



- (IBAction)chatBtn:(UIButton *)sender;
- (IBAction)AllTypesBtn:(UIButton *)sender;
- (IBAction)SuitCaseBtn:(UIButton *)sender;
- (IBAction)saomiaoBtn:(UIButton *)sender;
- (IBAction)refrenceBtn:(UIButton *)sender;
- (IBAction)shakeIntegralBtn:(UIButton *)sender;
- (IBAction)MyLOgisticBtn:(UIButton *)sender;

@end

@implementation HomeViewController
@synthesize pageControl,slideImages;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)initXibUI{
    [_fristPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_secondPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_thirdPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_fristSexPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_secondSexPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_thirdSexPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_fristChinaPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_secondChinaPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
    [_thirdChinaPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProductDetail:)]];
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    flag = 1;
    self.showMoreBtn = NO;
    //self.view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiankeLabel"]];
    self.navigationItem.titleView = imageView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sound_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(voiceBtn:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(setUpBtn:)];
    
    //头部视图
    _navBackImage.backgroundColor = [UIColor jk_colorWithHexString:@"#0082f0"];
    _searchImage.userInteractionEnabled = YES;
    [_searchImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTo:)]];
    
   
    
    _LongScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1155);
    
    [self initXibUI];
    
    //更多
    _bothSexesMoreLabel.userInteractionEnabled = YES;
    [_bothSexesMoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bothSexMore:)]];
    
    _ChineseOrWesternChineseOrMedicineMoreLabel.userInteractionEnabled = YES;
    [_ChineseOrWesternChineseOrMedicineMoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChineseOrMedicineMore:)]];
    
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root showTabBar];
    if (flag == 1) {
        [self requestHomeInfoData];
    }

}


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_LongScrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _LongScrollView.headerPullToRefreshText = @"下拉刷新";
    _LongScrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _LongScrollView.headerRefreshingText = @"正在帮你刷新中";
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestHomeInfoData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_LongScrollView headerEndRefreshing];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [timer invalidate];
}

-(void)requestHomeInfoData{
    [[Loading shareLoading]beginLoading];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fristLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *parameters = nil;
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/HomePage/getHomePageLists"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    flag++;
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}




#pragma mark - scrollowView_delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.tag == 1000) {
        CGFloat pagewidth = _scrollView1.frame.size.width;
        int page = floor((_scrollView1.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        pageControl.currentPage = page;
    }else if (sender.tag == 2000){

        CGFloat pagewidth = _pageScrollow.frame.size.width;
        int page = floor((_pageScrollow.contentOffset.x - pagewidth/([couldHelpImagesArr count]/3+2))/pagewidth)+1;
        _threepageControl.currentPage = page;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 1000:
        {
            CGFloat pagewidth = _scrollView1.frame.size.width;
            int currentPage = floor((_scrollView1.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
            if (currentPage==0)
            {
                [_scrollView1 scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width * [slideImages count],0,[UIScreen mainScreen].bounds.size.width,87) animated:NO]; // 序号0 最后1页
            }
            else if (currentPage==([slideImages count]+1))
            {
                [_scrollView1 scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width,87) animated:NO]; // 最后+1,循环第1页
            }

        }
            break;
        case 2000:
        {
            CGFloat pagewidth = _pageScrollow.frame.size.width;
            int currentPage = floor((_pageScrollow.contentOffset.x - pagewidth/ ([couldHelpImagesArr count]/3+2)) / pagewidth) + 1;
            if (currentPage==0) {
                [_pageScrollow scrollRectToVisible:CGRectMake(0, 595, [UIScreen mainScreen].bounds.size.width, 160)  animated:NO];
            }
            else if (currentPage==([couldHelpImagesArr count]/3+1)) {
                //如果是最后+1,也就是要开始循环的第一个
                [_pageScrollow scrollRectToVisible:CGRectMake(0, 595, [UIScreen mainScreen].bounds.size.width, 160)  animated:NO];
            }
        }
            break;
   
        default:
            break;
    }
}

#pragma mark - Method
#pragma mark 消息按钮方法
-(void)voiceBtn:(UIButton *)btn{
    NewsBoxViewController *news = [[NewsBoxViewController alloc] init];
    [self.navigationController pushViewController:news animated:YES];
}

#pragma mark 设置按钮方法
-(void)setUpBtn:(UIButton *)btn{
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)goToProductDetail:(UITapGestureRecognizer *)gesture{
    NSLog(@"%d",(int)gesture.view.tag);
    if ([drugIDArr[(int)gesture.view.tag-700]length] > 0) {
        ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
        productDetail.priductCode = drugIDArr[(int)gesture.view.tag-700];
        [self.navigationController pushViewController:productDetail animated:YES];
    }
}



-(void)tapImageAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"gesture.tag === %d",(int)gesture.view.tag);
    if ([couldHelpIDArr[(int)gesture.view.tag-300]length] > 0) {
        ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
        productDetail.priductCode = couldHelpIDArr[(int)gesture.view.tag-300];
        [self.navigationController pushViewController:productDetail animated:YES];
    }
}



-(void)pageAction
{
    int page = (int)_threepageControl.currentPage;
    [_pageScrollow setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * (page+1), 0)];
}




// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    [_scrollView1 scrollRectToVisible:CGRectMake(320*(page+1),0,320,100) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    page++;
    page = page > 3 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}


#pragma mark 循环图片点击方法
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"pageControl.currentPage===%d",(int)pageControl.currentPage);
    if ([adImageUrlArr[(int)pageControl.currentPage]length] > 0) {
        ActiveWebViewController *activeWeb = [[ActiveWebViewController alloc] init];
        activeWeb.url = adImageUrlArr[(int)pageControl.currentPage];
        [self.navigationController pushViewController:activeWeb animated:YES];
    }
}

#pragma mark 两性健康更多点击方法
-(void)bothSexMore:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击两性健康更多");
    AmphotericityViewController *amphotericity = [[AmphotericityViewController alloc] init];
    [self.navigationController pushViewController:amphotericity animated:YES];
}

#pragma mark 中医西药更多点击方法
-(void)ChineseOrMedicineMore:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击中医西药更多");
    ChinaAndForeginDrugViewController *china = [[ChinaAndForeginDrugViewController alloc] init];
    [self.navigationController pushViewController:china animated:YES];
}


#pragma mark 搜索跳转
-(void)searchTo:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到搜索页面。");
    search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}



#pragma mark 语音按钮
- (IBAction)chatBtn:(UIButton *)sender {
    NSLog(@"语音按钮");
    VoiceViewController *voice = [[VoiceViewController alloc] init];
    [self.navigationController pushViewController:voice animated:YES];
}


#pragma mark 全部分类按钮方法
- (IBAction)AllTypesBtn:(UIButton *)sender {
    NSLog(@"跳转到全部分类");
    AllTypesViewController *allTypes = [[AllTypesViewController alloc] init];
    [self.navigationController pushViewController:allTypes animated:YES];
}

#pragma mark 对症找药按钮方法
- (IBAction)SuitCaseBtn:(UIButton *)sender {
    NSLog(@"跳转到对症找药");
    SuitTheCaseViewController *suitForCase = [[SuitTheCaseViewController alloc] init];
    [self.navigationController pushViewController:suitForCase animated:YES];
}

#pragma mark 扫描找药按钮方法
- (IBAction)saomiaoBtn:(UIButton *)sender {
    ScanViewController * scan = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
}

#pragma mark 用药咨询按钮方法
- (IBAction)refrenceBtn:(UIButton *)sender {
    NSLog(@"跳转到用药咨询");
    ChatViewController *useDrugconsult = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:useDrugconsult animated:YES];
}

#pragma mark 摇积分按钮方法
- (IBAction)shakeIntegralBtn:(UIButton *)sender {
    NSLog(@"跳转到摇积分");
    ShakeViewController *shake = [[ShakeViewController alloc] init];
    [self.navigationController pushViewController:shake animated:YES];
}

#pragma mark 我的物流按钮方法
- (IBAction)MyLOgisticBtn:(UIButton *)sender {
    NSLog(@"跳转到我的物流");
    WaitForReciveViewController *waitForRecive = [[WaitForReciveViewController alloc] init];
    waitForRecive.titleTxt = @"我的物流";
    [self.navigationController pushViewController:waitForRecive animated:YES];
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
                //循环广告
                slideImages = [[NSMutableArray alloc] init];
                adImageUrlArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < [object[@"info"][@"advertiseList"] count]; i++) {
                    [slideImages addObject:object[@"info"][@"advertiseList"][i][@"head_img"]];
                    [adImageUrlArr addObject:object[@"info"][@"advertiseList"][i][@"url"]];
                }
                [self dataForADScrollowUI:slideImages];
                
                [self dataForDrugUI:object];
                
                [self dataForCouldHelpScrollowUI:object];
                
                drugIDArr = [[NSMutableArray alloc] init];
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < 3; i++) {
                    if (i == 0) {
                        tempArr = object[@"info"][@"worthBuyList"];
                    }else if (i == 1){
                        tempArr = object[@"info"][@"sexualHealthList"];
                    }else if (i == 2){
                        tempArr = object[@"info"][@"chinaWesternMedicineList"];
                    }
                    
                    for (int j = 0; j < tempArr.count; j++) {
                        [drugIDArr addObject:tempArr[j][@"productId"]];
                    }
                }
            }else{
                [self showToast:object[@"msg"]];
            }
            [[Loading shareLoading] endLoading];
        }        
    }
}

#pragma mark 循环广告图片
-(void)dataForADScrollowUI:(NSMutableArray *)images{
    [timer invalidate];
    [_scrollView1 removeFromSuperview];
    [pageControl removeFromSuperview];
    // 定时器 循环
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [timer fire];
    // 初始化 scrollview1
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 87)];
    _scrollView1.bounces = YES;
    _scrollView1.pagingEnabled = YES;
    _scrollView1.delegate = self;
    _scrollView1.userInteractionEnabled = YES;
    _scrollView1.tag = 1000;
    _scrollView1.showsHorizontalScrollIndicator = NO;
    [_LongScrollView addSubview:_scrollView1];
    
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(140,67,50,18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.numberOfPages = [images count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [_LongScrollView addSubview:pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[images count];i++)
    {
        JKWebImageView *imageView = [[JKWebImageView alloc] init];
        // 异步加载及缓存图片一步到位
        [imageView loadImageFromURL:[NSURL URLWithString:[images objectAtIndex:i]]];
        imageView.frame = CGRectMake((1+i)*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 87);
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        [_scrollView1 addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    // 取数组最后一张图片 放在第0页
    JKWebImageView *imageView = [[JKWebImageView alloc] initWithImage:[UIImage imageNamed:[images objectAtIndex:([images count]-1)]]];
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 87); // 添加最后1页在首页 循环
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_scrollView1 addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[JKWebImageView alloc] initWithImage:[UIImage imageNamed:[images objectAtIndex:0]]];
    imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width * ([images count] + 1)) , 0, [UIScreen mainScreen].bounds.size.width, 87); // 添加第1页在最后 循环
    [_scrollView1 addSubview:imageView];
    
    [_scrollView1 setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * ([images count] + 2), 87)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView1 setContentOffset:CGPointMake(0, 0)];
    [_scrollView1 scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width,87) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页

}

-(void)dataForDrugUI:(id)object{
    //值得买
    [_fristPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"worthBuyList"][0][@"productPic"]]];
    _firstMainLabel.text = object[@"info"][@"worthBuyList"][0][@"productName"];
    _fristassistantLabel.text = object[@"info"][@"worthBuyList"][0][@"productEffect"];
    
    [_secondPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"worthBuyList"][1][@"productPic"]]];
    _secondMainLabel.text = object[@"info"][@"worthBuyList"][1][@"productName"];
    _secondAssistanceLabel.text = object[@"info"][@"worthBuyList"][1][@"productEffect"];

    [_thirdPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"worthBuyList"][2][@"productPic"]]];
    _thirdMainLabel.text = object[@"info"][@"worthBuyList"][2][@"productName"];
    _thirdAssistanceLabel.text = object[@"info"][@"worthBuyList"][2][@"productEffect"];
    
    //两性健康
    [_fristSexPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"sexualHealthList"][0][@"productPic"]]];
    _FirstSexLabel.text = object[@"info"][@"sexualHealthList"][0][@"productName"];
    _firstSexAssistanceLabel.text = object[@"info"][@"sexualHealthList"][0][@"productEffect"];
    
    [_secondSexPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"sexualHealthList"][1][@"productPic"]]];
    _secondSexLabel.text = object[@"info"][@"sexualHealthList"][1][@"productName"];
    _secondsexAssistanceLabel.text = object[@"info"][@"sexualHealthList"][1][@"productEffect"];
    
    [_thirdSexPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"sexualHealthList"][2][@"productPic"]]];
    _thirdSexLabel.text = object[@"info"][@"sexualHealthList"][2][@"productName"];
    _thirdsexAssitanceLabel.text = object[@"info"][@"sexualHealthList"][2][@"productEffect"];
    
    //中医西药
    [_fristChinaPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"chinaWesternMedicineList"][0][@"productPic"]]];
    _fristChinaLabel.text = object[@"info"][@"chinaWesternMedicineList"][0][@"productName"];
    _fristChinaAssitenceLabel.text = object[@"info"][@"chinaWesternMedicineList"][0][@"productEffect"];
    
    [_secondChinaPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"chinaWesternMedicineList"][1][@"productPic"]]];
    _secondChinaLabel.text = object[@"info"][@"chinaWesternMedicineList"][1][@"productName"];
    _secondChinaAssitanceLabel.text = object[@"info"][@"chinaWesternMedicineList"][1][@"productEffect"];
    
    [_thirdChinaPic loadImageFromURL:[NSURL URLWithString:object[@"info"][@"chinaWesternMedicineList"][2][@"productPic"]]];
    _thirdChinaLabel.text = object[@"info"][@"chinaWesternMedicineList"][2][@"productName"];
    _thirdChinaAssitanceLabel.text = object[@"info"][@"chinaWesternMedicineList"][2][@"productEffect"];

    
}

-(void)dataForCouldHelpScrollowUI:(id)object{
//    [_pageScrollow removeFromSuperview];
//    [_threepageControl removeFromSuperview];
    //可能帮到您
    _pageScrollow.pagingEnabled = YES;
    _pageScrollow.delegate = self;
    _pageScrollow.showsHorizontalScrollIndicator = NO;
    _pageScrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, 160);
    
    _threepageControl.currentPage = 0;
    _threepageControl.tintColor = [UIColor lightGrayColor];
    _threepageControl.currentPageIndicatorTintColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    [_threepageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    couldHelpImagesArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    contentArr = [[NSMutableArray alloc] init];
    couldHelpIDArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [object[@"info"][@"couldHelpYouList"]count]; i++) {
        [couldHelpImagesArr addObject:object[@"info"][@"couldHelpYouList"][i][@"productPic"]];
        [titleArr addObject:object[@"info"][@"couldHelpYouList"][i][@"productName"]];
        [contentArr addObject:object[@"info"][@"couldHelpYouList"][i][@"productEffect"]];
        [couldHelpIDArr addObject:object[@"info"][@"couldHelpYouList"][i][@"productId"]];
    }
    
    
    for (int i = 0; i < couldHelpImagesArr.count; i++) {
        JKWebImageView *productImage = [[JKWebImageView alloc] initWithFrame:CGRectMake(10+[UIScreen mainScreen].bounds.size.width/3*i, 20, 80, 70)];
        [productImage loadImageFromURL:[NSURL URLWithString:couldHelpImagesArr[i]]];
        productImage.tag = 300 + i;
        productImage.userInteractionEnabled = YES;
        [productImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)]];
        [_pageScrollow addSubview:productImage];
        
        
        UILabel *typeName = [[UILabel alloc] initWithFrame:CGRectMake(10+[UIScreen mainScreen].bounds.size.width/3*i, 100, 80, 25)];
        typeName.text = titleArr[i];
        typeName.textAlignment = NSTextAlignmentCenter;
        typeName.textColor = [UIColor blackColor];
        typeName.font = [UIFont fontWithName:@"Arial" size:14];
        [_pageScrollow addSubview:typeName];
        
        
        
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(10+[UIScreen mainScreen].bounds.size.width/3*i, 120, 80, 25)];
        productName.text = contentArr[i];
        productName.textAlignment = NSTextAlignmentCenter;
        productName.textColor = [UIColor darkGrayColor];
        productName.font = [UIFont fontWithName:@"Arial" size:10];
        [_pageScrollow addSubview:productName];
        
        if (i > 0) {
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i/3, 0, 1, 160)];
            lineImageView.image = [UIImage imageNamed:@"grayLine（vertical ）"];
            lineImageView.alpha = 0.5;
            [_pageScrollow addSubview:lineImageView];
        }
    }
}


@end
