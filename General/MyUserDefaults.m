//
//  MyUserDefaults.m
//  jiankemall
//
//  Created by kunge on 14/12/26.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "MyUserDefaults.h"

@implementation MyUserDefaults
+(id)defaults{
    static MyUserDefaults *defaults = nil;
    if (defaults == nil) {
        defaults = [[MyUserDefaults alloc] init];
    }
    return defaults;
}

-(void)saveToUserDefaults:(NSString *)String withKey:(NSString *)Key{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        [defaults setObject:String forKey:Key];
        [defaults synchronize];
    }
}

-(NSString *)readFromUserDefaults:(NSString *)key{
    
    NSString *defaultStr = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        defaultStr = [defaults objectForKey:key];
    }
    return defaultStr;
}

@end
