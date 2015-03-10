//
//  ProductDetailViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/30.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProductDetailViewController : JKViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,JsonRequestDelegate>

@property (strong,nonatomic)NSString *priductCode;
@end
