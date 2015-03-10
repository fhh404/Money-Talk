//
//  PostHeadImageViewController.m
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "PostHeadImageViewController.h"
#import "RootTabBarController.h"

@interface PostHeadImageViewController ()
{
    NSString *accesstoken;
}

@property (nonatomic, strong) JsonRequest *jsonRequest;

- (IBAction)selectImageBtn:(UIButton *)sender;
- (IBAction)postBtnAction:(UIButton *)sender;
@end

@implementation PostHeadImageViewController
@synthesize imagePicker,photos,dataArray;
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
    
    self.title = @"头像修改";
    
    _postBtn.backgroundColor = [UIColor jk_colorWithHexString:@"#61b1f4"];
    _postBtn.layer.cornerRadius = 3;
    
    _resultView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootTabBarController *root = (RootTabBarController *)self.tabBarController;
    [root hideTabBar];
    
    accesstoken = [[MyUserDefaults defaults] readFromUserDefaults:@"accesstoken"];
}

#pragma mark - Method

#pragma mark 选择文件按钮方法
- (IBAction)selectImageBtn:(UIButton *)sender {
    NSLog(@"选择相册照片");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:(id)self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"我的相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark 上传按钮方法
- (IBAction)postBtnAction:(UIButton *)sender {
    NSLog(@"上传照片");
}




-(void)requestPostHeadImage:(id)image{
    
    NSDictionary *body = @{@"accesstoken":accesstoken,@"image":image};
    //url地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"/PersonalCenter/changeHeadPic"];
    NSLog(@"urlStr ==inputCode== %@",urlStr);
    
    if (self.jsonRequest == nil){
        self.jsonRequest = [[JsonRequest alloc] init];
        self.jsonRequest.delegate = self;
    }
    
    [self.jsonRequest postWithUrlStr:urlStr params:nil body:body tag:100];
    
}

#pragma mark actionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openCamera];
    }else if(buttonIndex == 1) {
        [self openPics];
    }
}

// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (imagePicker == nil) {
            imagePicker =  [[UIImagePickerController alloc] init];
        }
        imagePicker.delegate = (id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

// 打开相册
- (void)openPics {
    if (imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc] init];
    }
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = (id)self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];
    imagePicker = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
        
        
        [self.dataArray insertObject:theImage atIndex:0];
        //        selectedIamge = [self.dataArray objectAtIndex:0];
        //        _headImageView.image = selectedIamge;
        
        
        UIImage *contentImage = [self drawImage:theImage rect:CGRectMake(0, 0, 20, 20)];
        NSLog(@"contentImage====%@",contentImage);
        
        NSData *picData = UIImageJPEGRepresentation(contentImage, 0);//照片转二进制码
        [self requestPostHeadImage:picData];
    }
}

#pragma mark 图片重绘缩小
-(UIImage *)drawImage:(UIImage *)imag rect:(CGRect)rect{
    UIImage* image = imag;
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JsonRequestDelegate
- (void)responseWithObject:(id)object error:(NSError *)error tag:(int)tag
{
    if (tag == 100) {
        if (error){
            NSLog(@"%@ request error: %@", self.class, error);
        } else {
            NSLog(@"%@,msg===%@", object,object[@"msg"]);
            
            if ([object[@"result"] isEqualToNumber:@0]) {
                [self showToast:@"头像上传成功！"];
            }else{
                [self showToast:object[@"msg"]];
            }
        }
    }
}

@end
