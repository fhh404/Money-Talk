//
//  UserIntroductionViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserIntroductionViewController : JKViewController

@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;

@property(strong,nonatomic)NSString *htmlString;
@end
