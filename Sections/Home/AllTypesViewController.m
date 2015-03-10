//
//  AllTypesViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-12.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AllTypesViewController.h"
#import "RootTabBarController.h"
#import "AllTypesTwoViewController.h"

@implementation AllTypesViewController

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
    
    self.title = @"全部分类";
    
    _contentScrollow.contentSize = CGSizeMake(320, 640);
    
    //添加点击手势
    [_usualView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_maleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_heartView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_femaleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_childView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_liverAndGallView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_skinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [_urinayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}


#pragma mark - Method
#pragma mark 手势点击方法
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    
    
    NSLog(@"gesture.view.tag===%ld",gesture.view.tag);
    switch (gesture.view.tag) {
        case 100:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 0;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 200:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 1;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 300:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 2;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 400:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 3;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 500:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 4;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 600:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 5;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 700:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 6;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
        case 800:
        {
            AllTypesTwoViewController *allTypesTwo = [[AllTypesTwoViewController alloc] init];
            allTypesTwo.selectIndex = 7;
            [self.navigationController pushViewController:allTypesTwo animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

@end
