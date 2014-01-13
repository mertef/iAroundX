//
//  DLViewCtrlPersonalCenter.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLViewCtrlPersonalCenter.h"
#import "DLScrollViewPersonalGallery.h"
#import "DLMCConfig.h"
#import "DLViewPCInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DLViewCtrlPersonalCenter ()
-(void)addUIGallery;
-(void)addUIPersonalInformation;
@end

@implementation DLViewCtrlPersonalCenter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    NSLog(@"view frame %@", NSStringFromCGRect(self.view.frame));

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.navigationController.navigationBarHidden = YES;
    
    self.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.tabBarController.tabBar.frame.size.height);
    [self addUIGallery];
    [self addUIPersonalInformation];
    
    
}
-(void)addUIGallery{
    // Do any additional setup after loading the view.
    self.ccScrollviewPG = [[DLScrollViewPersonalGallery alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.4f)];
    NSLog(@"--%@", NSStringFromCGRect(self.ccScrollviewPG.frame));
    //IMG_0414
    
    /*
     NSString* cstrUrl0 = @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=342e93312a381f309e198aa99d394c08/91529822720e0cf37dcbeff20846f21fbe09aaff.jpg";
     NSString* cstrUrl1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=66cf64bed358ccbf1bbcb23a2de0bc3e/fd039245d688d43f52855cfe7f1ed21b0ef43b8a.jpg";
     NSString* cstrUrl2 = @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=f7f5d40ba918972ba33a07cad2f57a89/b8014a90f603738d8e94e43db11bb051f919ecd7.jpg";
     
     
     NSArray* carrImagesNetwork = @[cstrUrl0, cstrUrl1, cstrUrl2];
     */
    NSMutableArray* cmutarrImages = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        
        NSDictionary* cdicItem  = nil;
        /*
         if (i <= 2) {
         cdicItem = @{k_image_url:carrImagesNetwork[i], k_image_url_type:@(enum_scroll_view_image_url_network)};
         }else {
         cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};
         
         }*/
        cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};
        [cmutarrImages addObject:cdicItem];
    }
    [self.ccScrollviewPG feedImages:cmutarrImages];
    [self.view addSubview:self.ccScrollviewPG];
    
    NSMutableArray* cmutarrMenus = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        UIButton* cbtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        cbtnItem.frame = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
        cbtnItem.backgroundColor = [UIColor redColor];
        [cmutarrMenus addObject:cbtnItem];
    }
    [self.ccScrollviewPG setContentMenu:cmutarrMenus];
}

-(void)addUIPersonalInformation {
    self.ccViewPcInfo = [[DLViewPCInfo alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.ccScrollviewPG.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.ccScrollviewPG.frame))];
    UITapGestureRecognizer* ctapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionChangeAvator:)];
    self.ccViewPcInfo.cimageviewAvator.userInteractionEnabled = YES;
    [self.ccViewPcInfo.cimageviewAvator addGestureRecognizer:ctapGes];
    
    [self.ccViewPcInfo setName:@"Joe Mham Mertef"];
    [self.ccViewPcInfo setSex:@"Male"];
    [self.ccViewPcInfo setAge:@"31"];
    [self.ccViewPcInfo setEmail:@"mertef@hotmail.com"];
    NSString* cstrSignature = @"星座： Constellation \
    白羊座 Aries: [ 'ɛəri:z ] \
    金牛座 Taurus: [ 'tɔ:rəs ] \
    双子座 Gemini: [ 'dʒeminai ] \
    巨蟹座 Cancer: [ 'kænsə ] \
    狮子座 Leo: [ 'li(:)əu ] \
    处女座 Virgo: [ 'və:gəu ] \
    天秤座 Libra: [ 'librə ] \
    天蝎座 Scorpio: [ 'skɔ:piəu ]  \
    射手座 Sagittarius: [ ,sædʒi'tɛəriəs ]  \
    摩羯座 Capricornus: [ ,kæpri'kɔ:nəs ] \
    水瓶座 Aquarius: [ ə'kweriəs ] \
    双鱼座 Pisces: [ 'pisi:z ]";
    [self.ccViewPcInfo setSignature:cstrSignature];
    
    [self.view addSubview:self.ccViewPcInfo];

    self.cactionSheetChangeAvatar = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"k_pc_change_avatar", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"k_pc_gallery", nil), NSLocalizedString(@"k_pc_camera", nil),nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - actionsheet
-(void)actionChangeAvator:(UITapGestureRecognizer*)acTapGes {
    [self.cactionSheetChangeAvatar showFromTabBar:self.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"action sheet selected %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
                UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_camera", nil) message:NSLocalizedString(@"k_error_camera_not_availale", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
                [cAlertMsg show];
                return;
            }
            
            UIImagePickerController* cImagePickerCtrl = [[UIImagePickerController alloc] init];
            cImagePickerCtrl.mediaTypes = @[((__bridge NSString*)kUTTypeImage)];
            cImagePickerCtrl.delegate = self;
            [self presentViewController:cImagePickerCtrl animated:YES completion:^(void){
                
            }];
        }
            break;
        case 1:
        {
            
            if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ) {
                UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_camera", nil) message:NSLocalizedString(@"k_error_camera_not_availale", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
                [cAlertMsg show];
                return;
            }
            
            UIImagePickerController* cImagePickerCtr = [[UIImagePickerController alloc] init];
            cImagePickerCtr.mediaTypes = @[(__bridge NSString*)kUTTypeImage];
            cImagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
            cImagePickerCtr.allowsEditing = YES;
            cImagePickerCtr.showsCameraControls = YES;
            cImagePickerCtr.delegate = self;
            [self presentViewController:cImagePickerCtr animated:YES completion:^(void){
            }];
 
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];

}

#pragma mark - image picker callback 
#pragma mark - image controller callback
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"%@", [info description]);
        NSData* cdataCaptured = nil;
        /*
         "k_cancel" = "取消";
         "k_ok" = "确定";
         "k_rename_file" = "保存文件名字";
         */
        
        UIImage* cimageEditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (cimageEditedImage) {
            cdataCaptured = UIImageJPEGRepresentation(cimageEditedImage, 0.5f);
        }else {
            UIImage* cimageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
            cdataCaptured = UIImageJPEGRepresentation(cimageOriginal, 0.5f);
        }
        self.ccViewPcInfo.cimageviewAvator.image =  [UIImage imageWithData:cdataCaptured];
       
    }];
    
}

@end
