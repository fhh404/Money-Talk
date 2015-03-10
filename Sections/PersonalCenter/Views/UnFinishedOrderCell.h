//
//  UnFinishedOrderCell.h
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnFinishedOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;//订单号
@property (strong, nonatomic) IBOutlet UILabel *orderPrice;//订单金额
@property (strong, nonatomic) IBOutlet UILabel *orderState;//订单状态
@property (strong, nonatomic) IBOutlet UILabel *orderAmount;//商品数量
@property (strong, nonatomic) IBOutlet UILabel *orderTime;//下单时间
@property (strong, nonatomic) IBOutlet JKWebImageView *productImage;//商品图片
@property (strong, nonatomic) IBOutlet UIButton *orderLeftBtn;//靠左的按钮
@property (strong, nonatomic) IBOutlet UIButton *orderRightBtn;//靠右的按钮
@property (strong, nonatomic) IBOutlet UIImageView *bottomLine;//第二根分割线

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IBOutlet UIButton *arrowBtn;
@end
