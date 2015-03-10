//
//  GetPersonDataMethod.m
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "GetPersonDataMethod.h"

@implementation GetPersonDataMethod


+(void) requestLoginData:(NSString *)accountTxt password:(NSString *)passwordTxt {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    NSDictionary *parameters = @{@"loginName":accountTxt,@"passWord":passwordTxt};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/userLogin"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    //发送请求
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@,%@", responseObject,responseObject[@"msg"]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



@end
