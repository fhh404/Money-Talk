//
//  RootTabBarController.h
//  jiankemall
//
//  Created by Dave on 14-12-1.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "RemindViewController.h"
#import "PersonalCenterViewController.h"
#import "ShoppingCartViewController.h"

@interface RootTabBarController : UITabBarController


@property(nonatomic,retain)HomeViewController *ctrl0;
@property(nonatomic,retain)RemindViewController *ctrl1;
@property(nonatomic,retain)PersonalCenterViewController *ctrl2;
@property(nonatomic,retain)ShoppingCartViewController *ctrl3;

/**
 *  显示某一项
 *
 *  @param index 显示这一项
 */
-(void)selectAtIndex:(NSInteger)index;

/**
 *  显示TabBar
 */
-(void)showTabBar;

/**
 *  隐藏tabBar
 */
-(void)hideTabBar;
@end
