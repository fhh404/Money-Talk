//
//  JKArrayHelper.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/29.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JKArrayHelper.h"

@implementation JKArrayHelper

+ (NSArray *)addObject:(id)object toArray:(NSArray *) array {
    if(object == nil)
        return array;
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    if (array){
        [result addObjectsFromArray:array];
    }
    
    [result addObject:object];
    
    return result;
}

+ (NSArray *)removeObject:(id)object fromArray:(NSArray *)array {
    if(object == nil || array == nil)
        return array;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:array];

    [result removeObject:object];
    
    return result;
}

@end
