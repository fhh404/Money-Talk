//
//  JKImaveView.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/29.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKWebImageView : UIImageView

@property (nonatomic, assign) UIViewContentMode originalContentMode;

- (void)loadImageFromURL:(NSURL *)url;

- (void)loadImageFromURLString:(NSString *)urlString;

@end
