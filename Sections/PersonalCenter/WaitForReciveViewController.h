//
//  WaitForReciveViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitForReciveViewController : JKViewController<UITableViewDelegate,UITableViewDataSource,JsonRequestDelegate>
@property (strong, nonatomic) NSString *titleTxt;

@end
