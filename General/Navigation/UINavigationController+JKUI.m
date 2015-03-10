//
//  UINavigationController+Ext.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/27.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "UINavigationController+JKUI.h"

//#import <objc/runtime.h>
#import "JKSwizzleHelper.h"


@implementation UINavigationController(JKUI)



+ (void)load {
    [self swizzlePushViewController];
    [self setupAppearance];
}

+ (void)swizzlePushViewController {
    SEL originalSelector = @selector(pushViewController:animated:);
    SEL swizzledSelector = @selector(swizzlePushViewController:animated:);
    [JKSwizzleHelper swizzle:self.class originalSel:originalSelector swizzledSel:swizzledSelector];
}

+ (void)setupAppearance {
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes =
    [[NSDictionary alloc] initWithObjects:@[[UIColor whiteColor], [UIFont boldSystemFontOfSize:18.0]]
                                  forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    
    // get background image
    UIImage *barBgImage = [UIImage new];
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    [[UIColor jk_colorWithHexString:@"#0082f0"] setFill];
    UIRectFill(CGRectMake(0, 0, 20, 20));
    barBgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:barBgImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    // remove default shadow image.
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
}

- (void)swizzlePushViewController:(UIViewController *)viewController animated:(BOOL)animated {
   
    if([self.viewControllers count]){
        UIImage *btnImage = [UIImage imageNamed:@"back_btn"];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:btnImage style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtnClick:)];
        viewController.navigationItem.leftBarButtonItem = backBtn;
    }
    

    
    [self swizzlePushViewController:viewController animated:YES];
}

- (void)onBackBtnClick:(id)sender{
    [self popViewControllerAnimated:YES];
}

@end
