//
//  UserProtoclViewController.m
//  jiankemall
//
//  Created by kunge on 14/12/25.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "UserProtoclViewController.h"
#import "RootTabBarController.h"
#import "ProtoclCell.h"
@interface UserProtoclViewController ()
{
    NSArray *titleHeadArr;
    NSArray *contentArr;
}

@end

@implementation UserProtoclViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"使用条款";
    
    _protoclTable.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    _protoclTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _protoclTable.dataSource = self;
    _protoclTable.delegate = self;
    
    titleHeadArr = @[@"一、健客网服务条款的确认和接纳",@"二、服务简介",@"三、服务条款的修改和服务修订",@"四、会员隐私制度",@"五、会员的帐号，密码和安全性",@"六、对会员信息的存储和限制",@"七、会员管理",@"八、法律"];
    contentArr = @[@"健客网提供的服务将完全按照其发布的章程、服务条款和操作规则严格执行。会员必须完全同意所有服务条款并完成注册程序，才能成为健客网的正式会员。",@"健客网运用自己的操作系统通过国际互联网络为会员提供网络服务。同时，会员必须:\n(1)提供详尽、准确的个人资料。\n(2)不断更新注册资料，符合及时、详尽、准确的要求。\n健客网对会员不公开会员的姓名、地址、电子邮箱和联系方式， 除以下情况外：\n(1)会员授权健客网透露这些信息。\n(2)相应的法律及程序要求健客网提供会员的个人资料。 如果会员提供的资料包含有不正确的信息，健客网保留结束会员使用网络服务资格的权利。",@"健客网有权在必要时修改服务条款，健客网服务条款一旦发生变动，将会在重要页面上提示修改内容。如果不同意所改动的内容，会员可以主动取消获得的网络服务。如果会员继续享用网络服务，则视为接受服务条款的变动。健客网保留随时修改或中断服务而不需知照会员的权利。健客网行使修改或中断服务的权利，不需对会员或第三方负责。",@"尊重会员个人隐私是健客网的一项基本政策。所以，作为对以上第二点会员注册资料分析的补充，健客网一定不会在未经合法会员授权时公开、编辑或透露其注册资料及保存在健客网中的非公开内容，除非有法律许可要求或健客网在诚信的基础上认为透露这些信件在以下四种情况是必要的：\n(1)遵守有关法律规定，遵从健客网合法服务程序。\n(2)保持维护健客网的商标所有权。\n(3)在紧急情况下竭力维护会员个人和社会大众的隐私安全。\n(4)符合其他相关的要求。",@"会员一旦注册成功，成为健客网的合法会员，将得到一个密码和会员名。会员将对会员名和密码安全负全部责任。另外，每个会员都要对以其会员名进行的所有活动和事件负全责。会员若发现任何非法使用会员帐号或存在安全漏洞的情况，请立即告知健客网。",@"健客网不对会员所发布信息的删除或储存失败负责。健客网有判定会员的行为是否符合健客网服务条款的要求和精神的保留权利，如果会员违背了服务条款的规定，健客网有中断对其提供网络服务的权利。",@"会员单独承担发布内容的责任。会员对服务的使用是根据所有适用于健客网的国家法律、地方法律和国际法律标准的。 会员必须遵循：\n(1)从中国境内向外传输技术性资料时必须符合中国有关法规。\n(2)使用网络服务不作非法用途。\n(3)不干扰或混乱网络服务。\n(4)遵守所有使用网络服务的网络协议、规定、程序和惯例。\n会员须承诺不传输任何非法的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的，淫秽等信息资料。另外，会员也不能传输任何教唆他人构成犯罪行为的资料；不能传输助长国内不利条件和涉及国家安全的资料；不能传输任何不符合当地法规、国家法律和国际法律的资料。未经许可而非法进入其它电脑系统是禁止的。若会员的行为不符合以上提到的服务条款，健客网将作出独立判断立即取消会员服务帐号。会员需对自己在网上的行为承担法律责任。会员若在健客网上散布和传播反动、色情或其他违反国家法律的信息，健客网的系统记录有可能作为会员违反法律的证据。",@"如发生健客网服务条款与中华人民共和国法律相抵触时，则这些条款将完全按法律规定重新解释，而其它条款则依旧保持对会员产生法律效力和影响。"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
}

#pragma mark - _protoclTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = contentArr[indexPath.section];
    UIFont *tfont = [UIFont systemFontOfSize:15];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(300, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    NSLog(@"%f",sizeText.height);
    return sizeText.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    return 20;
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20)];
    titleLabel.text = titleHeadArr[section];
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
