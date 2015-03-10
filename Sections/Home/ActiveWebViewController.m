//
//  ActiveWebViewController.m
//  jianke
//
//  Created by jianke on 14-10-10.
//
//

#import "ActiveWebViewController.h"
#import "RootTabBarController.h"
@interface ActiveWebViewController ()
{
    UIWebView *webView;
}

@end

@implementation ActiveWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack:(id)sender{
    if (webView.canGoBack) {
        [webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"详情页面";
    
    self.showMoreBtn = NO;
    
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(goBack:)];
    
    //网页控件
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60)];//CGRect bouds = [[UIScreen mainScreen]applicationFrame];全屏
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    
    
    //网页加载

    
    NSURL *urlStr =[NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:urlStr];
    [webView loadRequest:request];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


//自适应关键代码
- (void)webViewDidFinishLoad:(UIWebView *)webview
{
    //修改web页面的meta的值
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"网页加载失败！" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //    [alterview show];
}

@end
