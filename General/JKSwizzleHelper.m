//
//  JKSwizzleHelper.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/29.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JKSwizzleHelper.h"

#import <objc/runtime.h>

@implementation JKSwizzleHelper

+ (void)swizzle:(Class)cls originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    
    class_addMethod(cls,
                    originalSel,
                    class_getMethodImplementation(cls, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(cls,
                    swizzledSel,
                    class_getMethodImplementation(cls, swizzledSel),
                    method_getTypeEncoding(swizzledMethod));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
