//
//  HttpRequest.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/4.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JsonRequest.h"

@interface JsonRequest()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation JsonRequest

-(void)requestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params method:(RequestMethod)method tag:(int)tag
{
    if (method == POST){
        //发送请求
        [self.manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self responseWithObject:responseObject error:nil tag:tag];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ post error: %@", self.class, error);
            [self responseWithObject:nil error:error tag:tag];
        }];
    } else {
        [self.manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self responseWithObject:responseObject error:nil tag:tag];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ get error: %@", self.class, error);
            [self responseWithObject:nil error:error tag:tag];
        }];
    }
    
}

-(void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params body:(NSDictionary *)body tag:(int)tag {
    
    [self.manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSEnumerator *e = [body keyEnumerator];
        NSString *name;
        while (name = [e nextObject]) {
            [formData appendPartWithFormData:(NSData *)[body valueForKey:name] name:name];
        }
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseWithObject:responseObject error:nil tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ post error: %@", self.class, error);
        [self responseWithObject:nil error:error tag:tag];
    }];
    
}

- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag{
    if (self.delegate){
        [self.delegate responseWithObject:object error:error tag:tag];
    }
}

-(AFHTTPRequestOperationManager *)manager
{
    @synchronized(self){
        if(_manager == nil){
            _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:PreUrl]];
            //申明返回的结果是json类型
            _manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //如果报接受类型不一致请替换一致text/html或别的
            _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        }
    }
    return _manager;
}



@end
