//
//  AppDelegate.m
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>

//第三方平台的SDK头文件，根据需要的平台导入。
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RennSDK/RennSDK.h>

#define kAppId           @"d4EDlYImQy7c9KoWccesL6"
#define kAppKey          @"Hv7UwT9MqVAgpWKK1LPuKA"
#define kAppSecret       @"NEep3jPt4EAq9wD1d3tHP1"

#import "HealthKnowMoreViewController.h"
#import "StartPageViewController.h"

#import <AlipaySDK/AlipaySDK.h>


@implementation AppDelegate
{
    NSString *accesstoken;
    NSString *_deviceToken;
    BOOL becomeActive;
    StartPageViewController *startPage;
    HealthKnowMoreViewController *health;
}



@synthesize lastPayloadIndex = _lastPaylodIndex;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   NSString *flag = [[MyUserDefaults defaults] readFromUserDefaults:@"uniquedid"];
    if (flag == nil) {
        [self creatUDId];
    }
    

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //分享
    //1.初始化ShareSDK应用,字符串"4a88b2fb067c"换成你申请的ShareSDK应用的Appkey，这个key来源于ShareSDK官网上申请获得
    [ShareSDK registerApp:@"5090938e3386"];
    //2. 初始化社交平台
    [self initializePlat];
    
    //个推
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    [self registerRemoteNotification];
    
    health = [[HealthKnowMoreViewController alloc] init];
    startPage = [[StartPageViewController alloc] init];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"fristLogin"]) {
        self.window.rootViewController = startPage;
    }else{
        self.window.rootViewController = health;
    }
    
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark 生成32位的随机字母
//xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-(void)creatUDId{
    NSString *uniquedid = @"";
    for (int i = 0; i < 32; i++) {
        char data = 'a' + (arc4random_uniform(26));
        char data1 = '0' + (arc4random_uniform(10));
        int number = arc4random() % 2;
        if (number == 0) {
            uniquedid = [NSString stringWithFormat:@"%@%c",uniquedid,data];
        }else if (number == 1){
            uniquedid = [NSString stringWithFormat:@"%@%c",uniquedid,data1];
        }
        if (i == 7 || i == 11 || i == 15 || i == 19) {
            uniquedid = [NSString stringWithFormat:@"%@-",uniquedid];
        }
    }
    [[MyUserDefaults defaults] saveToUserDefaults:uniquedid withKey:@"uniquedid"];
    NSLog(@"uniquedid=====%@",uniquedid);
}

- (void)initializePlat
{
    //初始化新浪，在新浪微博开放平台上申请应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2767646739" appSecret:@"2ccb3953003a3c52e1a470f0f62b0f1b" redirectUri:@"http://www.jianke.com" weiboSDKCls:[WeiboSDK class]];
    //上面的方法会又客户端跳客户端，没客户端条web.
    
    /**---------------------------------------------------------**/
    //初始化腾讯微博，请在腾讯微博开放平台申请
    [ShareSDK connectTencentWeiboWithAppKey:@"801557692"
                                  appSecret:@"871d054ac83a9ac6645f09063fa21505"
                                redirectUri:@"http://www.jianke.com"
                                   wbApiCls:[WeiboApi class]];
    /**---------------------------------------------------------**/
    //初始化人人网，在人人网开放平台上申请
    [ShareSDK connectRenRenWithAppId:@"474617" appKey:@"cc19184f10b24a88ad1d35a7e65dd2df" appSecret:@"d1da67cca04d4ceea33a72109f08cf28" renrenClientClass:[RennClient class]];
    /**---------------------------------------------------------**/
    //如果在分享菜单中想取消微信收藏，可以初始化微信及微信朋友圈，取代上面整体初始化的方法
    //微信好友
    [ShareSDK connectWeChatSessionWithAppId:@"wx38b6ddd430216b5c" appSecret:@"353a79d5964377a2d6893abdc501abdd" wechatCls:[WXApi class]];
    //微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:@"wx38b6ddd430216b5c" appSecret:@"353a79d5964377a2d6893abdc501abdd" wechatCls:[WXApi class]];
    /**---------------------------------------------------------**/
    //初始化QQ,QQ空间，使用同样的key，请在腾讯开放平台上申请，注意导入头文件：
    /**
     #import <TencentOpenAPI/QQApiInterface.h>
     #import <TencentOpenAPI/TencentOAuth.h>
     **/
    
    //连接QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"1103965570"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //连接QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"1103965570"
                           appSecret:@"Ak15hb8w4kB865oV"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //连接短信
    [ShareSDK connectSMS];
}

//添加两个回调方法,return的必须要ShareSDK的方法
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    
    
    
    /************/
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    /***************/
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark 切换到后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self stopSdk];
}

#pragma mark 重新上线
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"\napplicationDidBecomeActive\n");
    becomeActive = YES;
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
}

#pragma mark -

#pragma mark APNS注册失败
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
}

#pragma mark APNS注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *result = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *devicetoken = [[[result stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:devicetoken forKey:@"DeviceToken"];
    NSLog(@"devicetoken====%@",devicetoken);
    
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSLog(@"个推即将注册的deviceToken >> %@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        NSLog(@"向个推服务器注册deviceToken");
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}


#pragma mark 收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"title" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alv show];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    NSLog(@"record====%@",record);
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark 注册APNS
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}


#pragma mark 创建个推实例
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
    }
}

#pragma mark 停止个推
- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
    }
}


#pragma mark - GexinSdkDelegate

#pragma mark 注册个推
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    _sdkStatus = SdkStatusStarted;
    
    _clientId = clientId;
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
    if (accesstoken == nil) {
        
    }else{
        NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadInMainMethod:) object:nil];
        [myThread start];
    }
    
    NSLog(@"\n个推clientId >> %@\n",clientId);
}

#pragma mark 收到个推消息
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:payloadMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [NSDate date], payloadMsg];
    NSLog(@"\n\n收到个推消息 >> %@\n\n",record);
    
    [self DidReceiveData:nil];
}

#pragma mark 发送上行消息结果反馈
- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"个推发送上行消息结果反馈 >> %@",record);
}

#pragma mark 个推错误报告
- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"个推错误报告 >> %@",[error localizedDescription]);
}


#pragma mark - 收到推送消息的后续处理
-(void)DidReceiveData:(NSDictionary *)dict{
    
    BOOL notFrist = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFrist"];
    
    
    NSString *typeString = [NSString stringWithFormat:@"%@",dict[@"type"]];
    
    NSLog(@"dict===%@,typeString====%@",dict,typeString);
    if (becomeActive && notFrist) {
        
        
    }else{
        
        NSLog(@"notBecomActive");
    }
    becomeActive = NO;
    
    
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
        
    }
    [application setApplicationIconBadgeNumber:0];
    
}


#pragma mark -
#pragma mark 个推注册成功之后，发送消息给后台
-(void)threadInMainMethod:(id)sender
{
    [self requestPushData];
}

-(void)requestPushData{

    NSDictionary *parameters = @{@"accessToken":accesstoken,@"clinetId":_clientId,@"type":@"2"};
    NSLog(@"parameters====%@",parameters);
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/addSendMsgInfo"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest requestWithUrlStr:urlStr params:parameters method:GET tag:100];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "C4A.ShareSDKEasyDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShareSDKEasyDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShareSDKEasyDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark 禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            if ([object[@"result"] intValue] == 0) {
                NSLog(@"添加推送成功！");
            }else{
                NSLog(@"%@",object[@"msg"]);
            }
        }
    }
}


@end
