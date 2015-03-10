//
//  ShakeViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/22.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UIButton *summaryBtn;

@end
