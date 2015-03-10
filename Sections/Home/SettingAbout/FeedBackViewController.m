//
//  FeedBackViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "FeedBackViewController.h"
#import "RootTabBarController.h"

//动画时间
#define kAnimationDuration 0.2
@interface FeedBackViewController ()
{
    NSTimer *timer;
    UIView *successView;
    int flag;
}
- (IBAction)submitBtnAction:(UIButton *)sender;
@end

@implementation FeedBackViewController

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
    self.title = @"意见反馈";
    
    _inputContenView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
    _inputContenView.layer.borderWidth = 0.2;
    _telephoneinputVIew.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
    _telephoneinputVIew.layer.borderWidth = 0.2;
    
    _submitBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _tipsLabel.textColor = [UIColor jk_colorWithHexString:@"#ff6a63"];
    _contentTextView.text = @"欢迎您对健客商城提出你的优化建议，让我们能够更好的为客户服务。";
    _contentTextView.textColor = [UIColor lightGrayColor];
    _contentTextView.font = [UIFont fontWithName:@"Arial" size:16];
    _contentTextView.delegate = self;
    //给键盘添加收回按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    

    _contentTextView.inputAccessoryView = topView;
    _telephoneField.inputAccessoryView = topView;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _contentTextView.text = @"";
    _contentTextView.textColor = [UIColor blackColor];
}



#pragma mark - Method
#pragma mark 键盘方法
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有输入框的view的位置
    if ([_telephoneField isFirstResponder]) {
        //设置动画
        [UIView beginAnimations:nil context:nil];
        //定义动画时间
        [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
        [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, -80, 320, [UIScreen mainScreen].bounds.size.height+150)];//keyboardRect.size.height-kViewHeight
        [UIView commitAnimations];
    }
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [(UIScrollView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, 80, 320, [UIScreen mainScreen].bounds.size.height-80)];
    [UIView commitAnimations];
}

-(void)initSuccessUI{
    successView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 220, 100)];
    successView.layer.borderWidth = 0.2;
    successView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1.0].CGColor;
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UIImageView *successIcon = [[UIImageView alloc] initWithFrame:CGRectMake(50, 30, 20, 20)];
    successIcon.image = [UIImage imageNamed:@"successIcon"];
    [successView addSubview:successIcon];
    
    
    UILabel *tipsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 100, 20)];
    tipsTitleLabel.text = @"提交成功!";
    tipsTitleLabel.textAlignment = NSTextAlignmentLeft;
    tipsTitleLabel.font = [UIFont fontWithName:@"Arial" size:18];
    [successView addSubview:tipsTitleLabel];
    
    UILabel *tipsContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 190, 20)];
    tipsContentLabel.text = @"感想您对健客网的支持！";
    tipsContentLabel.textAlignment = NSTextAlignmentCenter;
    tipsContentLabel.textColor = [UIColor lightGrayColor];
    tipsContentLabel.font = [UIFont fontWithName:@"Arial" size:16];
    [successView addSubview:tipsContentLabel];
}



#pragma mark 提交建议按钮方法
- (IBAction)submitBtnAction:(UIButton *)sender {
    BOOL isOk = YES;
    if (isOk == YES) {
        
        flag = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopInit) userInfo:@"1" repeats:YES];
        [timer fire];
    }
}

-(void)stopInit{
    NSLog(@"第%d次",flag);
    if (flag == 1) {
        [timer invalidate];
        [successView removeFromSuperview];
        
    }else if (flag == 0){
        [self initSuccessUI];
    }
    flag++;
}

-(void)dismissKeyBoard{
    [_contentTextView resignFirstResponder];
    [_telephoneField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
