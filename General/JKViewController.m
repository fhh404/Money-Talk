//
//  JKViewController.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/28.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JKViewController.h"
#import "RootTabBarController.h"
#import "JKArrayHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface JKViewController ()

@property (nonatomic, strong) UIBarButtonItem *moreBtn;

@end

@implementation JKViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _showMoreBtn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor jk_backgroundColor];
    
    if (self.showMoreBtn){
        self.navigationItem.rightBarButtonItem = self.moreBtn;
    }
}


#pragma mark - extension methods

/**
 *  添加NavigationBar右侧按钮
 */
- (void)addRightBarButtonItem:(UIBarButtonItem *)button{
    
    self.navigationItem.rightBarButtonItems =
    [JKArrayHelper addObject:button
                     toArray:self.navigationItem.rightBarButtonItems];
}

/**
 * 添加NavigationBar左侧按钮
 */
- (void)addLeftBarButtonItem:(UIBarButtonItem *)button{
    self.navigationItem.leftBarButtonItems =
    [JKArrayHelper addObject:button
                     toArray:self.navigationItem.leftBarButtonItems];
}

/**
 * 显示快捷提示
 */
- (void)showToast:(NSString *)message{
    if (message != nil){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.yOffset = 50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}

#pragma mark - Action methods.
#pragma mark 更多按钮方法
- (void)moreAction:(UIButton *)sender {
    NSLog(@"点击更多按钮");
    CGPoint point = CGPointMake(275, 64);
    NSArray *titles = @[@"首页", @"用药提醒", @"个人中心",@"购物车"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        
        RootTabBarController *root = (RootTabBarController *)self.tabBarController;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        if (index == 0) {
            NSLog(@"首页");
            [root selectAtIndex:10];
        }else if (index == 1){
            NSLog(@"用药提醒");
            [root selectAtIndex:11];
        }else if (index == 2){
            NSLog(@"个人中心");
            [root selectAtIndex:12];
        }else if (index == 3){
            NSLog(@"购物车");
            [root selectAtIndex:13];
        }
    };
    [pop show];
}

- (UIBarButtonItem *)moreBtn{
    if (_moreBtn == nil){
        _moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    }
    return _moreBtn;
}

#pragma mark - setters & getters

- (void)setShowMoreBtn:(BOOL)showMoreBtn{
    if (showMoreBtn){
        self.navigationItem.rightBarButtonItem = self.moreBtn;
    }else{
        self.navigationItem.rightBarButtonItems =
        [JKArrayHelper removeObject:self.moreBtn
                          fromArray:self.navigationItem.rightBarButtonItems];
    }
}



@end
