//
//  MyUserDefaults.h
//  jiankemall
//
//  Created by kunge on 14/12/26.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDefaults : NSObject
+(id)defaults;
-(void)saveToUserDefaults:(NSString *)String withKey:(NSString *)Key;
-(NSString *)readFromUserDefaults:(NSString *)key;
@end
