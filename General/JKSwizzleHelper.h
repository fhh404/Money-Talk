//
//  JKSwizzleHelper.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/29.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSwizzleHelper : NSObject

+ (void)swizzle:(Class)clazz originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel;


@end
