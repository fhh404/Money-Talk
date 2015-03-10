//
//  JsonUtil.m
//  jiankemall
//
//  Created by kunge on 15/1/12.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JKJsonHelper.h"

@implementation JKJsonHelper
+(id)toJsonObject:(NSString *)string
{
    if(string == nil) return nil;
    
    id result = nil;
    NSError *error = nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    result = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if(error == nil)
        return result;
    else
        return nil;
}

+(NSString *)toJsonString:(id)object
{
    if(object == nil) return nil;
    
    NSString *result = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if( error == nil && [jsonData length] > 0 ){
        result = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

+(NSString *)toJsonString:(id)object prettyPrint:(BOOL)pretty
{
    if(object == nil) return nil;
    
    NSString *result = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if( error == nil && [jsonData length] > 0 ){
        result = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        if(!pretty){
            result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    
    return result;
}

@end
