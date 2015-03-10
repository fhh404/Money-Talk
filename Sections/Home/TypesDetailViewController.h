//
//  TypesDetailViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-17.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypesDetailViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (strong, nonatomic) IBOutlet UIView *conditionbackView;
@property (strong, nonatomic) IBOutlet UILabel *screenLabel;//筛选条件label

@property(strong, nonatomic) NSString *keyWord;
@property(strong, nonatomic) NSString *diseaseId;
@property int requestFlag;
@end
