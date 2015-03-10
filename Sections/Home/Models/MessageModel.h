//
//  MessageModel.h
//  jiankemall
//
//  Created by jianke on 14-12-28.
//  Copyright (c) 2014年 kunge. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum {
    kMessageModelTypeOther,
    kMessageModelTypeMe
} MessageModelType;

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) MessageModelType type;
@property (nonatomic, assign) BOOL showTime;

+ (id)messageModelWithDict:(NSDictionary *)dict;

@end
