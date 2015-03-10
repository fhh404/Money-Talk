//
//  CouponUseRuleViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/25.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "CouponUseRuleViewController.h"
#import "RootTabBarController.h"
#import "ProtoclCell.h"
@interface CouponUseRuleViewController ()
{
    NSArray *headTitleArr;
    NSArray *contentArr;
}
@end

@implementation CouponUseRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"优惠券使用规则";
    
    _couponRuleTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    _couponRuleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _couponRuleTable.dataSource = self;
    _couponRuleTable.delegate = self;
    
    headTitleArr = @[@"1、代金优惠券只能通过积分兑换（在“我的客”-“积分”中根据帐户积分可以兑换相应面额的代金优惠券）",@"2、活动优惠券可参加网站各类活动获得"];
    contentArr = @[@"代金优惠券使用规则：\n代金优惠券为全场通用礼券，每个订单限使用一张优惠券； 在提交订单时系统会自动识别您的优惠券信息，按照您目前的订单情况自行匹配，如选择使用，在最终结算数额中会减掉相应金额。\n满200元可使用5元优惠券，满300元可使用10元优惠券，满500元可使用20元优惠券，满1200元可使用50元优惠券（不可叠加使用）；\n请注意代金优惠券使用期限，逾期作废。\n代金优惠券不能用于页面提示的特例产品",@"参加各类免费领取优惠券活动（活动信息可持续关注网站各网站广告词、活动专题页面、社区各大版块）等按一定的活动规则即有机会 获得优惠券。\n活动优惠券使用规则：\n活动优惠券为指定活动专场优惠券，限活动期间购买指定产品使用，每个订单限使用一张优惠券；（活动优惠券与代金优惠券只能使 用一张）在提交订单，在线支付时系统会自动识别您的优惠券信息，按照您目前的订单情况自行匹配，如选择使用，在最终结算数额 中会减掉相应金额。\n活动优惠券面额、使用限制及有效期请关注相关活动页面。\n请注意优惠券使用期限，逾期作废。"];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - _couponRuleTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = contentArr[indexPath.section];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (section == 1) {
        return 20;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cellMark";
    ProtoclCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[ProtoclCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    cell.contentLabel.text = contentArr[indexPath.section];
    cell.contentLabel.numberOfLines = 0;
    [cell.contentLabel sizeToFit];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cell.contentLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, sizeText.height);
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 40)];
    if (section == 1) {
        titleLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20);
    }
    titleLabel.text = headTitleArr[section];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    return view;
}

#pragma mark - Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
