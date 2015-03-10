//
//  HomeViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-2.
//  Copyright (c) 2014年 nimadave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : JKViewController<UIScrollViewDelegate,JsonRequestDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (nonatomic,strong)IBOutlet UIImageView *navBackImage;
@property (strong, nonatomic) IBOutlet UIScrollView *LongScrollView;
@property (strong, nonatomic) IBOutlet UILabel *bothSexesMoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *ChineseOrWesternChineseOrMedicineMoreLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *pageScrollow;
@property (strong, nonatomic) IBOutlet UIPageControl *threepageControl;

//值得买
@property (strong, nonatomic) IBOutlet UILabel *firstMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *fristassistantLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *fristPic;
@property (strong, nonatomic) IBOutlet UILabel *secondMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondAssistanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *secondPic;
@property (strong, nonatomic) IBOutlet UILabel *thirdMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdAssistanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *thirdPic;

//两性健康
@property (strong, nonatomic) IBOutlet UILabel *FirstSexLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstSexAssistanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *fristSexPic;
@property (strong, nonatomic) IBOutlet UILabel *secondSexLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsexAssistanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *secondSexPic;
@property (strong, nonatomic) IBOutlet UILabel *thirdSexLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdsexAssitanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *thirdSexPic;

//中医西药
@property (strong, nonatomic) IBOutlet UILabel *fristChinaLabel;
@property (strong, nonatomic) IBOutlet UILabel *fristChinaAssitenceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *fristChinaPic;
@property (strong, nonatomic) IBOutlet UILabel *secondChinaLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondChinaAssitanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *secondChinaPic;
@property (strong, nonatomic) IBOutlet UILabel *thirdChinaLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdChinaAssitanceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *thirdChinaPic;


@property (strong,nonatomic)UIScrollView *scrollView1;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;
@end
