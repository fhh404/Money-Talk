//
//  CellFrameModel.h
//  jiankemall
//
//  Created by jianke on 14-12-28.
//  Copyright (c) 2014年 kunge. All rights reserved.
//
#import <Foundation/Foundation.h>
@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel *message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;

@end
