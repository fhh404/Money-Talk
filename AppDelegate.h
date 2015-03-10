//
//  AppDelegate.h
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "GexinSdk.h"
#import "GXSdkError.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GexinSdkDelegate,JsonRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



//个推
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (nonatomic, strong) JsonRequest *jsonRequest;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
