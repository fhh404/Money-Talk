//
//  AboutUsViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AboutUsViewController.h"
#import "RootTabBarController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    
    UIScrollView *scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollow.contentSize = CGSizeMake(320, 620);
    scrollow.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollow];
    
    
    
    UILabel *contentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, -30, 280, 620)];
    NSString *labelText1 = @"       健客网于2006年成立,由广东健客医药有限公司负责运营,2009年获得国家食品药品监督管理局颁发的《互联网药品交易资格证书》,成为广东省第一家(B2C)互联网药品合法经营企业,是全国最大规模的网上药店之一,主要经营药品、保健品、减肥护肤品、母婴用品、成人安全用品等数万种产品。\n\n       目前，健客网已同国内500多家大型药品生产厂商建立了战略合作伙伴关系，并签署了药品直供协议，在保证药品质量的同时缩减中间环节，让客户享受到最优惠的价格。健客网本着客户至上的原则，为了更好的服务于客户，高薪聘请了国内数十名医学界著名专家和学者，打造了健客网医学专家顾问团，为健客网定期进行培训、指导，并为所有客户免费提供与专家进行一对一健康咨询及用药指导的服务。\n\n       健客网以服务社会、回馈社会为己任，与国内数家医学教学及科研机构合作，建立了大学生就业实践基地，积极参与各类社会慈善活动。目前，健客网正处于高速发展之中，销售额每年以200%的速度增长，健客网这支年轻化、专业化的运作团队正在不断壮大，并朝着打造最值得信赖的健康服务平台的目标迈进！";

    contentLabel1.numberOfLines = 0;
    contentLabel1.textColor = [UIColor darkGrayColor];
    contentLabel1.text = labelText1;
    contentLabel1.font = [UIFont fontWithName:@"Arial" size:16];
    [scrollow addSubview:contentLabel1];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

@end
