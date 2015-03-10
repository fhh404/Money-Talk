//
//  HeadForOrderCell.h
//  jiankemall
//
//  Created by kunge on 14/12/19.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadForOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciverLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *onlinePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciverPayBtn;
@property (weak, nonatomic) IBOutlet UITextField *invoiceField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIView *whiteBackView;
@property (strong, nonatomic) IBOutlet UIButton *isNeedInvoiceBtn;
@property (strong, nonatomic) IBOutlet UIView *invoiceView;
@property (strong, nonatomic) IBOutlet UILabel *invoiceLabel;

@end
