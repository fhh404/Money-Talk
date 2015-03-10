//
//  JKViewController.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/28.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKViewController : UIViewController;

@property (nonatomic, assign) BOOL showMoreBtn;

- (void)addRightBarButtonItem:(UIBarButtonItem *)button;
- (void)addLeftBarButtonItem:(UIBarButtonItem *)button;
- (void)showToast:(NSString *)message;

@end
