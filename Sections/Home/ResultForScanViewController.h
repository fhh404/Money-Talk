//
//  ResultForScanViewController.h
//  jiankemall
//
//  Created by kunge on 15/1/6.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultForScanViewController : JKViewController<JsonRequestDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *barCode;
@end
