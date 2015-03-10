//
//  MessageModel.m
//  jiankemall
//
//  Created by jianke on 14-12-28.
//  Copyright (c) 2014年 kunge. All rights reserved.
//
#import "MessageModel.h"

@implementation MessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel *message = [[self alloc] init];
    message.text = dict[@"text"];
    message.time = dict[@"time"];
    message.type = [dict[@"type"] intValue];
    
    return message;
}

@end
