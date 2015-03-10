//
//  Loading.m
//  jiankemall
//
//  Created by kunge on 15/1/17.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "Loading.h"

@implementation Loading
{
    UILabel *promptLabel;
    UIImageView *animationImg;
    UIView *alphaView;
}
+(id)shareLoading{
    static Loading *shareInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareInstance = [[Loading alloc] init];
    });
    
    return shareInstance;
}

-(id)init{
    
    self = [super init];
    if (self != nil) {
        
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:alphaView];
        alphaView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        alphaView.hidden = YES;
        
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        animationImg = [[UIImageView alloc] initWithFrame:CGRectMake((width - 50) / 2, (height - 45) / 2, 50, 45)];
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            NSString *imgName = [NSString stringWithFormat:@"loading000%d",i];
            [images addObject:[UIImage imageNamed:imgName]];
        }
        animationImg.animationImages = images;
        animationImg.animationDuration = .25;
        [alphaView addSubview:animationImg];
        
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 30)];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont systemFontOfSize:13];
        promptLabel.textColor = [UIColor whiteColor];
        [alphaView addSubview:promptLabel];
    }
    return self;
}

-(void)beginLoading{
    alphaView.hidden = NO;
    [animationImg startAnimating];
}

-(void)beginLoading:(NSString *)prompt{
    promptLabel.text = prompt;
    [animationImg startAnimating];
    alphaView.hidden = NO;
}

-(void)endLoading{
    [animationImg stopAnimating];
    alphaView.hidden = YES;
}

@end
