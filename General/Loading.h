//
//  Loading.h
//  jiankemall
//
//  Created by kunge on 15/1/17.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loading : NSObject
+(id)shareLoading;
-(void)beginLoading:(NSString *)prompt;
-(void)beginLoading;
-(void)endLoading;
@end
