//
//  AllTypesTwoViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-13.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "AllTypesTwoViewController.h"
#import "RootTabBarController.h"
#import "ItemNameCell.h"
#import "TypesDetailViewController.h"
#import "SearchViewController.h"
@interface AllTypesTwoViewController ()
{
    NSArray *dataArr;
    UITableView *itemNameTable;
    UITableView *diseaseNameTable;
    NSDictionary *diseaseArr;
}

@end

@implementation AllTypesTwoViewController
@synthesize selectIndex;
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
    
    self.title = @"全部分类";
    
    dataArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProductType.plist" ofType:nil]];
    
    
    itemNameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.height-0) style:UITableViewStylePlain];
    itemNameTable.delegate = self;
    itemNameTable.dataSource = self;
    itemNameTable.tag = 200;
    [self.view addSubview:itemNameTable];
    //注册xib
    [itemNameTable registerNib:[UINib nibWithNibName:@"ItemNameCell" bundle:nil] forCellReuseIdentifier:@"itemNameCell"];
    
    diseaseNameTable = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, [UIScreen mainScreen].bounds.size.width*2/3, [UIScreen mainScreen].bounds.size.height-0) style:UITableViewStylePlain];
    diseaseNameTable.delegate = self;
    diseaseNameTable.dataSource = self;
    diseaseNameTable.tag = 201;
    diseaseNameTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:diseaseNameTable];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    diseaseArr = dataArr[self.selectIndex];
    [itemNameTable reloadData];
    [diseaseNameTable reloadData];
}


#pragma mark - Table_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 200:
        {
            return dataArr.count;
        }
            break;
        case 201:
        {
            return [diseaseArr[@"symptomName"] count];
        }
            break;
        default:
            break;
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 200:
        {
            return 80;
        }
            break;
        case 201:
        {
            return 40;
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 200:
        {
            ItemNameCell *itemCell = (ItemNameCell *)[tableView dequeueReusableCellWithIdentifier:@"itemNameCell"];
            if (indexPath.row == self.selectIndex) {
                [itemCell.itemBackImageView setImage:[UIImage imageNamed:@"selected(vercial)"]];
            }
            itemCell.itemNameLabel.text = dataArr[indexPath.row][@"CategoryName"];
            return itemCell;
        }
            break;
        case 201:
        {
            static NSString *identifier = @"namecell";
            UITableViewCell *cell = [diseaseNameTable dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.textLabel.text = diseaseArr[@"symptomName"][indexPath.row][@"itemName"];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            return cell;

        }
            break;
        default:
            break;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中后的灰色
    switch (tableView.tag) {
        case 200:
        {
            ItemNameCell *itemCell = (ItemNameCell *)[itemNameTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            [itemCell.itemBackImageView setImage:[UIImage imageNamed:@"selected(vercial)"]];
            self.selectIndex = indexPath.row;
            diseaseArr = dataArr[indexPath.row];
            [itemNameTable reloadData];
            [diseaseNameTable reloadData];
        }
            break;
        case 201:
        {
            TypesDetailViewController *alltypesDetail = [[TypesDetailViewController alloc] initWithNibName:@"TypesDetailViewController" bundle:nil];
            alltypesDetail.title = diseaseArr[@"symptomName"][indexPath.row][@"itemName"];
            alltypesDetail.diseaseId = diseaseArr[@"symptomName"][indexPath.row][@"itemID"];
            alltypesDetail.requestFlag = 2;
            [self.navigationController pushViewController:alltypesDetail animated:YES];
        }
            break;
        default:
            break;
    }

}
@end
