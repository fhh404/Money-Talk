//
//  AllOrderViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@end
