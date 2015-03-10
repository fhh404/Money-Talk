//
//  StartPageViewController.m
//  jiankemall
//
//  Created by kunge on 15/1/17.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "StartPageViewController.h"
#import "HealthKnowMoreViewController.h"
@interface StartPageViewController ()
{
    UIScrollView *contentScrollow;
    CGFloat contentXHeight;
}
@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    contentScrollow = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    contentScrollow.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height);
    contentScrollow.backgroundColor = [UIColor clearColor];
    contentScrollow.tag = 1000;
    contentScrollow.pagingEnabled = YES;
    contentScrollow.showsVerticalScrollIndicator = NO;
    contentScrollow.showsHorizontalScrollIndicator = NO;
    contentScrollow.contentOffset = CGPointZero;
    [self.view addSubview:contentScrollow];
    contentXHeight = 0;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *pageImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        pageImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"startPage%d",i]];
        pageImage.userInteractionEnabled = YES;
        [pageImage addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)]];
        if (i == 3) {
            UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width-160, 60)];
            alphaView.backgroundColor = [UIColor clearColor];
            [alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toRootTabBar:)]];
            [pageImage addSubview:alphaView];
        }
        [contentScrollow addSubview:pageImage];
    }
}

-(void)swipeAction:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (contentXHeight <= [UIScreen mainScreen].bounds.size.width*3) {
            contentXHeight += [UIScreen mainScreen].bounds.size.width;
        }
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionRight){
        if (contentXHeight >= [UIScreen mainScreen].bounds.size.width) {
            contentXHeight -= [UIScreen mainScreen].bounds.size.width;
        }else{
            contentXHeight = 0;
        }
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        contentScrollow = (UIScrollView *)[self.view viewWithTag:1000];
        CGPoint bottomOffset = CGPointMake(contentXHeight, 0);
        [contentScrollow setContentOffset:bottomOffset animated:NO];
    }];
}

-(void)toRootTabBar:(UITapGestureRecognizer *)gesture{
    NSLog(@"跳转到内容页面！");
    HealthKnowMoreViewController *health = [[HealthKnowMoreViewController alloc] init];
    [self presentViewController:health animated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
