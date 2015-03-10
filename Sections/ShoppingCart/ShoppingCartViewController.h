//
//  ShoppingCartViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UILabel *hejiLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *freightFreeLabel;
@property (strong, nonatomic) IBOutlet UIButton *allcheckBtn;
@property (strong, nonatomic) IBOutlet UIView *jiesuanView;

@end
