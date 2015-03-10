//
//  MyDatabase.h
//  jiankemall
//
//  Created by kunge on 14/12/26.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface MyDatabase : NSObject
+(MyDatabase *)sharedDatabase;
-(NSArray *)seleteNameWithParentCode:(NSString *)ID;

//搜索历史记录
-(NSArray *)seleteALlHIstoryData;
-(void)insertData:(NSString *)history;
-(void)deleteAllHistoryData;
@end
