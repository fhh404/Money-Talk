//
//  HttpRequest.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/4.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
    GET,
    POST,
};


@protocol JsonRequestDelegate <NSObject>

- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag;

@end

@interface JsonRequest : NSObject

@property (nonatomic, weak) id<JsonRequestDelegate> delegate;

- (void)requestWithUrlStr:(NSString *) urlStr params:(NSDictionary *) params method:(RequestMethod)method tag:(int)tag;

- (void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *) params body:(NSDictionary *) body tag: (int)tag;

@end
