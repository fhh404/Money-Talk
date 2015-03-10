//
//  DiseaseViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/29.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property(strong,nonatomic)NSString *diseaseId;
@end
