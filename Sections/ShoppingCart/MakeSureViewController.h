//
//  MakeSureViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/19.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeSureViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property NSMutableArray *orderNumber;
@end
