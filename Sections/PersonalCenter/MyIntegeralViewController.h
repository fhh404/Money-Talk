//
//  MyIntegeralViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntegeralViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end
