//
//  JKImaveView.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/1/29.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import "JKWebImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation JKWebImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self){
        [self setupDefaultImage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setupDefaultImage];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupDefaultImage];
    }
    return self;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
}

- (void)setImage:(UIImage *)image
{
    if (image != nil){
        self.contentMode = _originalContentMode;
        [super setImage:image];
    }
}

- (void)setupDefaultImage{
    if (self.image == nil){
        self.originalContentMode = self.contentMode;
        self.backgroundColor = [UIColor jk_colorWithHexString:@"#eeeeee"];
        self.image = [UIImage imageNamed:@"image_placeholder"];
        self.contentMode = UIViewContentModeCenter;
    }
    
}

/**
 * 从URL加载图片
 */
- (void)loadImageFromURL:(NSURL *)url{
    [self sd_setImageWithURL:url];
}


/**
 * 从URL加载图片
 */
- (void)loadImageFromURLString:(NSString *)urlString
{
    [self loadImageFromURL:[NSURL URLWithString:urlString]];
}



@end
