//
//  JsonUtil.h
//  jiankemall
//
//  Created by kunge on 15/1/12.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKJsonHelper : NSObject

/**
 * 将Json字符串转为Dictionary或者Array对象
 */
+ (id)toJsonObject:(NSString *)string;

/**
 * 将对象转换为Json字符串
 */
+ (NSString *)toJsonString:(id)object;

/**
 * 将对象转换为Json字符串
 */
+ (NSString *)toJsonString:(id)object prettyPrint:(BOOL)pretty;
@end
