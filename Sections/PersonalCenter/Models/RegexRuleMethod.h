//
//  RegexRuleMethod.h
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexRuleMethod : NSObject
+(id)regexRule;
- (BOOL)isEmail:(NSString*)candidate;
- (BOOL)isTelephone:(NSString*)candidate;@end
