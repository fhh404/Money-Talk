//
//  RootTabBarController.m
//  jiankemall
//
//  Created by Dave on 14-12-1.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import "RootTabBarController.h"
#import "UIImage+MostColor.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController{
    
    UIImageView *tabBarBackgroundView;
    
    UIButton *homeBtn;
    UIButton *remindBtn;
    UIButton *centerBtn;
    UIButton *shoppingBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ctrl0 = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	UINavigationController* navCtrl0 = [[UINavigationController alloc] initWithRootViewController:self.ctrl0];
//    navCtrl0.navigationBar.hidden=YES;
    
    self.ctrl1 = [[RemindViewController alloc] initWithNibName:@"RemindViewController" bundle:nil] ;
	UINavigationController* navCtrl1 = [[UINavigationController alloc] initWithRootViewController:self.ctrl1];
//    navCtrl1.navigationBar.hidden=YES;
    
    
    self.ctrl2 = [[PersonalCenterViewController alloc] initWithNibName:@"PersonalCenterViewController" bundle:nil];
	UINavigationController* navCtrl2 = [[UINavigationController alloc] initWithRootViewController:self.ctrl2];
//    navCtrl2.navigationBar.hidden=YES;
    
    self.ctrl3 = [[ShoppingCartViewController alloc] initWithNibName:@"ShoppingCartViewController" bundle:nil] ;
	UINavigationController* navCtrl3 = [[UINavigationController alloc] initWithRootViewController:self.ctrl3];
//    navCtrl3.navigationBar.hidden=YES;
    
    
    self.viewControllers = [NSArray arrayWithObjects:navCtrl0,navCtrl1,navCtrl2,navCtrl3,nil];
    [self createCustomTabBar];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createCustomTabBar
{
    
    self.tabBar.hidden = YES;
    
    CGFloat x;
    
    
    UIImage *image = [UIImage imageNamed:@"shouye_active"];
    
    tabBarBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    tabBarBackgroundView.backgroundColor = [image mostColor];
    tabBarBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:tabBarBackgroundView];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setImage:[UIImage imageNamed:@"shouye_active"] forState:UIControlStateSelected];
    [homeBtn setImage:[UIImage imageNamed:@"shouye_inactive"] forState:UIControlStateNormal];
    homeBtn.frame = CGRectMake(TABBAR_MARGINS, 0, 39, 49);
    homeBtn.tag = 10;
    [homeBtn addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarBackgroundView addSubview:homeBtn];
    homeBtn.selected = YES;
    
    x = [self xValueWithFrame:homeBtn.frame];
    remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [remindBtn setImage:[UIImage imageNamed:@"yongyaotixing_active"] forState:UIControlStateSelected];
    [remindBtn setImage:[UIImage imageNamed:@"yongyaotixing_inactive"] forState:UIControlStateNormal];
    remindBtn.tag = 11;
    [remindBtn addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    remindBtn.frame = CGRectMake(x, 0, 39, 49);
    [tabBarBackgroundView addSubview:remindBtn];
    
    x = [self xValueWithFrame:remindBtn.frame];
    centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setImage:[UIImage imageNamed:@"gerenzhongxin_active"] forState:UIControlStateSelected];
    [centerBtn setImage:[UIImage imageNamed:@"gerenzhongxin_inactive"] forState:UIControlStateNormal];
    centerBtn.tag = 12;
    [centerBtn addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    centerBtn.frame = CGRectMake(x, 0, 39, 49);
    [tabBarBackgroundView addSubview:centerBtn];
    
    x = [self xValueWithFrame:centerBtn.frame];
    shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoppingBtn setImage:[UIImage imageNamed:@"gouwuche_active"] forState:UIControlStateSelected];
    [shoppingBtn setImage:[UIImage imageNamed:@"gouwuche_inactive"] forState:UIControlStateNormal];
    shoppingBtn.tag = 13;
    [shoppingBtn addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    shoppingBtn.frame = CGRectMake(x, 0, 39, 49);
    [tabBarBackgroundView addSubview:shoppingBtn];
}

-(void)tabBarAction:(UIButton *)button{
    
    [self cancellAllSelected:button];

}

-(void)cancellAllSelected:(UIButton *)button{
    
    homeBtn.selected = NO;
    remindBtn.selected = NO;
    centerBtn.selected = NO;
    shoppingBtn.selected = NO;
    
    button.selected = YES;
    
    self.selectedIndex = button.tag-10;
}

-(CGFloat)xValueWithFrame:(CGRect)frame{
    
    CGFloat space = (SCREEN_WIDTH - TABBAR_MARGINS * 2 - 39 * 4) / 3;

    return frame.origin.x+frame.size.width+space;
}

-(void)showTabBar
{
    self.hidesBottomBarWhenPushed = YES;
    self.tabBar.hidden = YES;
	[tabBarBackgroundView setHidden:NO];
}

-(void)hideTabBar
{
	[tabBarBackgroundView setHidden:YES];
}

-(void)selectAtIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[tabBarBackgroundView viewWithTag:index];
    [self cancellAllSelected:button];
}



@end
