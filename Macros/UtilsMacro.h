//
//  UtilsMacro.h
//  jiankemall
//
//  Created by Dave on 14-12-1.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#ifndef jiankemall_UtilsMacro_h
#define jiankemall_UtilsMacro_h


//#warning 方便经常使用的宏定义，如：


#define UIColorFromRGB(r,g,b) [UIColor \
colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 alpha:1]

#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif
