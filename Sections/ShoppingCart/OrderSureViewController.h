//
//  OrderSureViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSureViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property(strong,nonatomic)NSMutableArray *carGoodsIds;
@end
