//
//  AccountModel.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject
@property(strong,nonatomic)NSString *accountNumber;//账号
@property(strong,nonatomic)NSString *password;//账号密码
@property(strong,nonatomic)NSString *picUrl;//头像url地址
@property(strong,nonatomic)NSString *telephoneNumber;//绑定手机号
@end
