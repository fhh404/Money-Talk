//
//  HistorySearchDataBase.m
//  jiankemall
//
//  Created by kunge on 15/1/7.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "HistorySearchDataBase.h"
#import <FMDB/FMDB.h>

//搜索历史记录表
#define CREATE_history @"CREATE TABLE if not exists tb_history (id integer PRIMARY KEY AUTOINCREMENT,history text)"
#define SELECT_history @"select * from tb_history"
#define INSERT_history @"insert into tb_history (history) values (?)"
#define DELETE_history @"delete from tb_history"
@implementation HistorySearchDataBase
{
    FMDatabase *fmDataBase;
}



- (id)init
{
    self = [super init];
    if (self) {
        [self createDataBase];
        [self createTable];
    }
    return self;
}

//单例构造方法
+(HistorySearchDataBase *)sharedDatabase{
    
    static HistorySearchDataBase *myDatabase = nil;
    if (myDatabase == nil) {
        myDatabase = [[HistorySearchDataBase alloc] init];
    }
    return myDatabase;
}

//数据库路径
- (NSString *)getDataBase{
    //重新创建db文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"datapath%@",path);
    return [path stringByAppendingPathComponent:@"History.db"];
}



//创建数据库
- (void)createDataBase{
    fmDataBase = [FMDatabase databaseWithPath:[self getDataBase]];
    //打开数据库
    if (![fmDataBase open]) {
        NSLog(@"数据库打开失败");
        return;
    }else{
        NSLog(@"打开数据库成功，文件路径：%@",[self getDataBase]);
    }
}

//创建表单
- (void)createTable{
    BOOL isCreateOK = [fmDataBase executeUpdate:CREATE_history];
    if (!isCreateOK) {
        NSLog(@"创建用户记录表失败");
    }else
        NSLog(@"创建用户记录表成功");
}



//查找搜索历史数据
-(NSArray *)seleteALlHIstoryData{
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [fmDataBase executeQuery:SELECT_history];
    while ([set next]) {
        [array addObject:[set stringForColumn:@"history"]];
    }
    return array;
}

//插入搜索历史表单数据
-(void)insertData:(NSString *)history{
    BOOL isInsert1OK = [fmDataBase executeUpdate:INSERT_history,history];
    if (!isInsert1OK) {
        NSLog(@"插入用户记录数据失败");
    }else
        NSLog(@"插入用户记录数据成功");
}

//清空历史记录表单
-(void)deleteAllHistoryData{
    // 删除记录：
    BOOL delete_record = [fmDataBase executeUpdate:DELETE_history];
    if (!delete_record) {
        NSLog(@"删除用户记录数据失败");
    }else{
        NSLog(@"删除用户记录数据成功");
    }
}


@end
