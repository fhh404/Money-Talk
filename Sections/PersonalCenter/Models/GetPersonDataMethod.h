//
//  GetPersonDataMethod.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GetPersonDataMethod : NSObject
+(void *)requestLoginData:(NSString *)accountTxt password:(NSString *)passwordTxt;
@end
