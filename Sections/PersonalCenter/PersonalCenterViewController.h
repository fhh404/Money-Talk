//
//  PersonalCenterViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIView *personInfoView;
@property (strong, nonatomic) IBOutlet JKWebImageView *headPro;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UIView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *integerView;
@property (strong, nonatomic) IBOutlet UIView *couponView;
@property (strong, nonatomic) IBOutlet UILabel *collectionNumber;
@property (strong, nonatomic) IBOutlet UILabel *integrateNumber;
@property (strong, nonatomic) IBOutlet UILabel *couponNumber;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@end
