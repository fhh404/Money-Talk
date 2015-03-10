//
//  SearchViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *BackImageView;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIView *saomiaoView;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtns;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@end
