//
//  AddNewNotifiyViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AddNewNotifiyViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,JsonRequestDelegate>


@property(nonatomic,strong)NSDictionary *dataDic;
@property int flag;
@end
