//
//  EditAddressViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (strong, nonatomic) IBOutlet UITextField *reciverNameField;
@property (strong, nonatomic) IBOutlet UITextField *telephoneNumField;
@property (strong, nonatomic) IBOutlet UITextField *postcodeField;
@property (strong, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (strong, nonatomic) IBOutlet UIButton *stateBtn;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong, nonatomic) IBOutlet UIButton *countryBtn;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *countyLabel;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollow;

@property (strong, nonatomic) IBOutlet UIView *postCodeView;
@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) IBOutlet UIButton *isdefaultBtn;


@property int flag;
@property (strong, nonatomic) NSString *forNavTitle;
@property (strong,nonatomic)NSString *addressId;
@property (strong,nonatomic)NSDictionary *editDic;
@end

