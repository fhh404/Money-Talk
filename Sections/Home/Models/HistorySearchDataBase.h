//
//  HistorySearchDataBase.h
//  jiankemall
//
//  Created by kunge on 15/1/7.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistorySearchDataBase : NSObject
+(HistorySearchDataBase *)sharedDatabase;
-(NSArray *)seleteALlHIstoryData;
-(void)insertData:(NSString *)history;
-(void)deleteAllHistoryData;
@end
