//
//  ScanViewController.m
//  ScanTestDemo
//
//  Created by kunge on 15/1/6.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "ScanViewController.h"
#import "RootTabBarController.h"
#import "ZBarSDK.h"
#import "ResultForScanViewController.h"

#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 30.0
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TINTCOLOR_ALPHA 0.2  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度
#define Color [UIColor colorWithWhite:0.35 alpha:0.5]
@interface ScanViewController ()<ZBarReaderViewDelegate>
{
    UIView *_QrCodeline;
    int num;
    BOOL upOrdown;
    NSTimer *_timer;
    int flag;
    
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
}



@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"扫描二维码";
    //初始化扫描界面
    [self setScanView];
    
    _readerView= [[ZBarReaderView alloc]init];
    _readerView.frame =CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _readerView.tracksSymbols=YES;
    _readerView.readerDelegate =self;
    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode =0;
    [self.view addSubview:_readerView];
    
    [_readerView start];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];

    if (flag >= 2) {
        [self creatTimer];
    }
    flag++;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
    }
    [self stopTimer];
    
    [_readerView stop];
    
}



#pragma mark -- ZBarReaderViewDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    //判断是否包含 头'http:'
    NSString *regex =@"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    
    //判断是否包含 头'ssid:'
    NSString *ssid =@"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    if ([predicate evaluateWithObject:symbolStr]) {
        
    }
    else if([ssidPre evaluateWithObject:symbolStr]){
        
        NSArray *arr = [symbolStr componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0]componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1]componentsSeparatedByString:@":"];
        
        
        symbolStr = [NSString stringWithFormat:@"ssid: %@ \n password:%@",
                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
    }
    
    
    
    NSLog(@"symbolStr===%@",symbolStr);
    
    
    if (symbolStr.length > 0) {
        ResultForScanViewController *resultForScan = [[ResultForScanViewController alloc] init];
        resultForScan.barCode = symbolStr;
        [self.navigationController pushViewController:resultForScan animated:YES];
    }

}


//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,VIEW_HEIGHT)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,SCANVIEW_EdgeTop+60)];
//    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = Color;
    [_scanView addSubview:upView];
    
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH-80, 30, 60, 60)];
    btnBackView.backgroundColor = [UIColor clearColor];
    [upView addSubview:btnBackView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0 ,0, 60, 60);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnBackView addSubview:closeBtn];
    
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop+60, SCANVIEW_EdgeLeft-10,VIEW_WIDTH-2*SCANVIEW_EdgeLeft+40)];
    leftView.backgroundColor = Color;
    [_scanView addSubview:leftView];
    
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop+80, VIEW_WIDTH-2*SCANVIEW_EdgeLeft,VIEW_WIDTH-2*SCANVIEW_EdgeLeft)];

    scanCropView.image=[UIImage imageNamed:@"pick_bg"];
    
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH-SCANVIEW_EdgeLeft+10,SCANVIEW_EdgeTop+60, SCANVIEW_EdgeLeft-10,VIEW_WIDTH-2*SCANVIEW_EdgeLeft+40)];
//    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = Color;
    [_scanView addSubview:rightView];
    
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,VIEW_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop+80+20, VIEW_WIDTH,VIEW_HEIGHT-(VIEW_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop+100))];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = Color;
    [_scanView addSubview:downView];
    
    //用于说明的label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(0,25, VIEW_WIDTH,20);
    labIntroudction.numberOfLines = 1;
    labIntroudction.font = [UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码/条形码放入方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-60,VIEW_WIDTH, 60.0)];
    darkView.backgroundColor = [[UIColor clearColor]  colorWithAlphaComponent:DARKCOLOR_ALPHA];
    [downView addSubview:darkView];
    
    //用于开关灯操作的button
    UIButton *openButton=[[UIButton alloc] initWithFrame:CGRectMake(10,10, 300.0, 40.0)];
    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    openButton.backgroundColor=[UIColor lightGrayColor];
    openButton.titleLabel.font=[UIFont systemFontOfSize:22.0];
    [openButton addTarget:self action:@selector(openLight)forControlEvents:UIControlEventTouchUpInside];
    [darkView addSubview:openButton];
    
    //画中间的基准线
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [_scanView addSubview:_line];
    flag = 0;
    [self creatTimer];
    
}




#pragma mark - Method
#pragma mark 关闭扫描按钮
-(void)closeBtnAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 开启闪光灯
- (void)openLight
{
    if (_readerView.torchMode ==0) {
        _readerView.torchMode =1;
    }else
    {
        _readerView.torchMode =0;
    }
}


#pragma mark 绿线扫描动作
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark 创建定时器
-(void)creatTimer{
    [_readerView start];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    flag++;
}


#pragma mark 关闭定时器
- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

#pragma mark 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
