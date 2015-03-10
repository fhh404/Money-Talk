//
//  ActiveWebViewController.h
//  jianke
//
//  Created by jianke on 14-10-10.
//
//

#import <UIKit/UIKit.h>

@interface ActiveWebViewController : JKViewController<UIWebViewDelegate>

@property(nonatomic,assign)NSString *url;

@end
