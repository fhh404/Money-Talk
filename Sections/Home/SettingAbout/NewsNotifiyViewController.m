//
//  NewsNotifiyViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "NewsNotifiyViewController.h"
#import "RootTabBarController.h"
#import "NewsNotifyCell.h"
@interface NewsNotifiyViewController ()
{
    UITableView *newsNotifyTable;
}

@end

@implementation NewsNotifiyViewController

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
    
    self.title = @"消息提醒";
    
    newsNotifyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    newsNotifyTable.delegate = self;
    newsNotifyTable.dataSource = self;
    newsNotifyTable.separatorColor = [UIColor colorWithWhite:0.55 alpha:0.7];
    [self.view addSubview:newsNotifyTable];
    
    //注册xib
    [newsNotifyTable registerNib:[UINib nibWithNibName:@"NewsNotifyCell" bundle:nil] forCellReuseIdentifier:@"newsNotifyCell"];
    
}

#pragma mark - newsNotifyTable_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *imageNameArr = @[@"ordershipp",@"buyDrugNotify",@"shopCartDownPrice",@"collectionNews",@"mallsalespromotion",@"serviceFeedBack"];
    NSArray *itemNameArr = @[@"订单发货",@"买药提醒",@"购物车降价",@"收藏降价",@"商城促销",@"客服反馈"];
    NewsNotifyCell *cell = (NewsNotifyCell *)[tableView dequeueReusableCellWithIdentifier:@"newsNotifyCell"];
    cell.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    cell.iconImageview.image = [UIImage imageNamed:imageNameArr[indexPath.row]];
    cell.itemLabel.text = itemNameArr[indexPath.row];
    [cell.switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.switchBtn.tag = 100 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Method
#pragma mark cell复选按钮方法
-(void)switchBtnAction:(UIButton *)btn{
    NewsNotifyCell *cell = (NewsNotifyCell *)[newsNotifyTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-100 inSection:0]];
    cell.switchBtn.selected = !cell.switchBtn.selected;
    if (cell.switchBtn.selected == YES) {
        [cell.switchBtn setImage:[UIImage imageNamed:@"switchStart"] forState:UIControlStateNormal];
    }else if (cell.switchBtn.selected == NO){
        [cell.switchBtn setImage:[UIImage imageNamed:@"switchStop"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
