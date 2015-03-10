//
//  HealthKnowMoreViewController.m
//  jiankemall
//
//  Created by kunge on 15/1/20.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "HealthKnowMoreViewController.h"
#import "RootTabBarController.h"
@interface HealthKnowMoreViewController ()
{
    NSArray *tipsArr;
    NSTimer *timer;
}
- (IBAction)skipBtnAction:(UIButton *)sender;
@end

@implementation HealthKnowMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    tipsArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips.plist" ofType:nil]];
    _alphaView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    
    int imageNum = arc4random() % 10;
    _backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"healthKnowMore000%d",imageNum]];
    
    int labelNum = arc4random() % 19;
    _tipsLabel.text = tipsArr[labelNum][@"tips"];
    _tipsLabel.numberOfLines = 0;
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(toRootBar) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toRootBar{
    NSLog(@"跳转");
    RootTabBarController *rootTabBar = [[RootTabBarController alloc] init];
    [self presentViewController:rootTabBar animated:YES completion:nil];
    
}

- (IBAction)skipBtnAction:(UIButton *)sender {
    RootTabBarController *rootTabBar = [[RootTabBarController alloc] init];
    [self presentViewController:rootTabBar animated:YES completion:nil];
}
@end
