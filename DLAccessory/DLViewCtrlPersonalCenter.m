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


typedef NS_ENUM (NSUInteger, T_ENUM_ACTION_SHEET_MODE){
    enum_mode_change_avatar,
    enum_mode_add_picture_to_gallery,
    enum_mode_change_gallery_picture
};
@interface DLViewCtrlPersonalCenter () {
    T_ENUM_ACTION_SHEET_MODE _t_enum_action_sheet_mode;
    CGRect _s_rect_pc_gallery_init;
    CGRect _s_rect_pc_info_int;
    UIDynamicAnimator* _c_dy_animator;
}
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

//    NSLog(@"view frame %@", NSStringFromCGRect(self.view.frame));

}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    
    _c_dy_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
}
-(void)addUIGallery{
    // Do any additional setup after loading the view.
    _s_rect_pc_gallery_init = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.4f);
    self.ccScrollviewPG = [[DLScrollViewPersonalGallery alloc] initWithFrame:_s_rect_pc_gallery_init];
//    NSLog(@"--%@", NSStringFromCGRect(self.ccScrollviewPG.frame));
    //IMG_0414
    
    /*
     NSString* cstrUrl0 = @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=342e93312a381f309e198aa99d394c08/91529822720e0cf37dcbeff20846f21fbe09aaff.jpg";
     NSString* cstrUrl1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=66cf64bed358ccbf1bbcb23a2de0bc3e/fd039245d688d43f52855cfe7f1ed21b0ef43b8a.jpg";
     NSString* cstrUrl2 = @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=f7f5d40ba918972ba33a07cad2f57a89/b8014a90f603738d8e94e43db11bb051f919ecd7.jpg";
     
     
     NSArray* carrImagesNetwork = @[cstrUrl0, cstrUrl1, cstrUrl2];
     */
    self.cmutarrContentMenu = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        
        NSDictionary* cdicItem  = nil;
        /*
         if (i <= 2) {
         cdicItem = @{k_image_url:carrImagesNetwork[i], k_image_url_type:@(enum_scroll_view_image_url_network)};
         }else {
         cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};
         
         }*/
        cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};
        [self.cmutarrContentMenu addObject:cdicItem];
    }
    [self.ccScrollviewPG feedImages:self.cmutarrContentMenu];
    [self.view addSubview:self.ccScrollviewPG];
    
    /*
     "add_picture"
     "change_signature"
     "delete_picture"
     */
   NSMutableArray* cmutarrContentMenus = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        UIButton* cbtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        switch (i) {
            case 0:
                [cbtnItem setImage:[UIImage imageNamed:@"add_picture"] forState:UIControlStateNormal];
                [cbtnItem setImage:[UIImage imageNamed:@"add_picture_h"] forState:UIControlStateHighlighted];
                [cbtnItem addTarget:self action:@selector(actionAddPicture:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [cbtnItem setImage:[UIImage imageNamed:@"change_signature"] forState:UIControlStateNormal];
                [cbtnItem setImage:[UIImage imageNamed:@"change_signature_h"] forState:UIControlStateHighlighted];
                [cbtnItem addTarget:self action:@selector(actionEditPicture:) forControlEvents:UIControlEventTouchUpInside];

                break;
            case 2:
                [cbtnItem setImage:[UIImage imageNamed:@"delete_picture"] forState:UIControlStateNormal];
                [cbtnItem setImage:[UIImage imageNamed:@"delete_picture_h"] forState:UIControlStateHighlighted];
                [cbtnItem addTarget:self action:@selector(actionDeletePicture:) forControlEvents:UIControlEventTouchUpInside];

                break;
            case 3:
                [cbtnItem setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
                [cbtnItem setImage:[UIImage imageNamed:@"edit-h"] forState:UIControlStateHighlighted];
                [cbtnItem addTarget:self action:@selector(actionChangeSignature:) forControlEvents:UIControlEventTouchUpInside];

                break;
  
            default:
                break;
        }
         cbtnItem.tag = i + 1;
        cbtnItem.frame = CGRectMake(0.0f, 0.0f, 36.0f, 36.0f);
        cbtnItem.backgroundColor = [UIColor clearColor];
        [cmutarrContentMenus addObject:cbtnItem];
//        [cbtnItem setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
    }
    [self.ccScrollviewPG setContentMenu:cmutarrContentMenus];
}
-(void)actionAddPicture:(id)aidSender {
    _t_enum_action_sheet_mode = enum_mode_add_picture_to_gallery;
    self.cactionSheetChangeAvatar.title = NSLocalizedString(@"k_pc_add_picture", nil);
    [self.cactionSheetChangeAvatar showFromTabBar:self.tabBarController.tabBar];
}


-(void)actionDeletePicture:(id)aidSender {
    UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_delete_picture", nil) message:NSLocalizedString(@"k_msg_delete_picture", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
    [cAlertMsg show];
}
-(void)actionChangeSignature:(id)aidSender {
    CATransform3D tTransform3dPerspective = CATransform3DIdentity;
    tTransform3dPerspective.m34 = 1.0/ -500;
    CGRect srectFrame = self.ccScrollviewPG.frame;
    self.ccScrollviewPG.layer.anchorPoint = CGPointMake(0.5f,1.0f);
    self.ccScrollviewPG.frame = srectFrame;
    CATransform3D tTransform3dRotateAroundX = CATransform3DRotate(tTransform3dPerspective, M_PI_2, 1.0f, 0.0f, 0.0f);
    CGRect srectInfoFrame = self.ccViewPcInfo.frame;
    srectInfoFrame.origin = CGPointMake(0.0f, 20.0f);

    [self addUpBehavior];
    
    [UIView animateWithDuration:.8f animations:^(void){
        self.ccScrollviewPG.layer.transform = tTransform3dRotateAroundX;
//        self.ccViewPcInfo.frame = srectInfoFrame;
        self.view.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    } completion:^(BOOL abFinished){
        [self.ccViewPcInfo.ctextviewSignature setEditable:YES];
       
        [self.ccViewPcInfo.ctextviewSignature becomeFirstResponder];
    }];
    
   

}

-(void)addUpBehavior {
    [_c_dy_animator removeAllBehaviors];
    
    UIGravityBehavior* cGravityBe = [[UIGravityBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    cGravityBe.gravityDirection = CGVectorMake(0, -1.0f);
    
    //    UIAttachmentBehavior* cAttachBe = [[UIAttachmentBehavior alloc] initWithItem:self.ccViewPcInfo attachedToAnchor:CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f, 20.0f)];
    //    cAttachBe.length = 50.0f;
    //    cAttachBe.damping = 0.8f;
    //    cAttachBe.frequency = 20.0f;
    
    UICollisionBehavior* cCollisonBe = [[UICollisionBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    cCollisonBe.translatesReferenceBoundsIntoBoundary = YES;
    [cCollisonBe addBoundaryWithIdentifier:@"topBellowStatusBarSeperator" fromPoint:CGPointMake(0.0f, 20.0f) toPoint:CGPointMake(CGRectGetWidth(self.view.bounds), 20.0f)];
    
    UIDynamicItemBehavior* cdynItemBe = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    cdynItemBe.elasticity = 0.4f;
    
    cCollisonBe.collisionMode = UICollisionBehaviorModeBoundaries;
    [_c_dy_animator addBehavior:cGravityBe];
    [_c_dy_animator addBehavior:cCollisonBe];
    [_c_dy_animator addBehavior:cdynItemBe];
    //    [_c_dy_animator addBehavior:cAttachBe];
}
-(void)addDownBehavior {
    [_c_dy_animator removeAllBehaviors];
    UIGravityBehavior* cGravityBe = [[UIGravityBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    
    //    UIAttachmentBehavior* cAttachBe = [[UIAttachmentBehavior alloc] initWithItem:self.ccViewPcInfo attachedToAnchor:CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f, 20.0f)];
    //    cAttachBe.length = 50.0f;
    //    cAttachBe.damping = 0.8f;
    //    cAttachBe.frequency = 20.0f;
    
    UICollisionBehavior* cCollisonBe = [[UICollisionBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    cCollisonBe.translatesReferenceBoundsIntoBoundary = YES;
    [cCollisonBe addBoundaryWithIdentifier:@"topBellowStatusBarSeperator" fromPoint:CGPointMake(0.0f, CGRectGetMaxY(_s_rect_pc_info_int)) toPoint:CGPointMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(_s_rect_pc_info_int))];
    
    UIDynamicItemBehavior* cdynItemBe = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ccViewPcInfo]];
    cdynItemBe.elasticity = 0.4f;
    
    cCollisonBe.collisionMode = UICollisionBehaviorModeBoundaries;
    [_c_dy_animator addBehavior:cGravityBe];
    [_c_dy_animator addBehavior:cCollisonBe];
    [_c_dy_animator addBehavior:cdynItemBe];
}

-(void)actionEndEdit:(id)aidSender {
    [_c_dy_animator removeAllBehaviors];
    [self addDownBehavior];
    [UIView animateWithDuration:.8f animations:^(void){
        self.view.backgroundColor = [UIColor whiteColor];
        [self.ccViewPcInfo.ctextviewSignature resignFirstResponder];
        [self.ccViewPcInfo.ctextviewSignature setEditable:NO];
//        self.ccViewPcInfo.frame = _s_rect_pc_info_int;
        self.ccScrollviewPG.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL abFinished){
        [self.ccViewPcInfo.ctextviewSignature setEditable:YES];

    }];
}
-(void)actionEditPicture:(id)aidSender {
    self.cactionSheetChangeAvatar.title = NSLocalizedString(@"k_pc_edit_picture", nil);
    _t_enum_action_sheet_mode = enum_mode_change_gallery_picture;
    [self.cactionSheetChangeAvatar showFromTabBar:self.tabBarController.tabBar];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"delete picture!");
        if ([self.cmutarrContentMenu count] > 0) {
            [self.cmutarrContentMenu removeObjectAtIndex:self.ccScrollviewPG.cpageControl.currentPage];
            [self.ccScrollviewPG feedImages:self.cmutarrContentMenu];            
        }
    }
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)addUIPersonalInformation {
    _s_rect_pc_info_int = CGRectMake(0.0f, CGRectGetMaxY(self.ccScrollviewPG.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.ccScrollviewPG.frame));
    self.ccViewPcInfo = [[DLViewPCInfo alloc] initWithFrame:_s_rect_pc_info_int];
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
    
    UIToolbar* cToobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 40.0f)];
    UIBarButtonItem* cBarItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionEndEdit:)];
    [cToobar setItems:@[cBarItemDone]];
    self.ccViewPcInfo.ctextviewSignature.inputAccessoryView = cToobar;
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - actionsheet
-(void)actionChangeAvator:(UITapGestureRecognizer*)acTapGes {
    _t_enum_action_sheet_mode = enum_mode_change_avatar;
    self.cactionSheetChangeAvatar.title = NSLocalizedString(@"k_pc_change_avatar", nil);
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
        switch (_t_enum_action_sheet_mode) {
            case enum_mode_change_avatar:
                self.ccViewPcInfo.cimageviewAvator.image =  [UIImage imageWithData:cdataCaptured];
                break;
            case enum_mode_change_gallery_picture: {
                NSTimeInterval iTime = [[NSDate date] timeIntervalSince1970];
                NSString* cstrUserName = [[NSUserDefaults standardUserDefaults] objectForKey:k_peer_user_name];
                NSString* cstrImageUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@-%f.jpg", cstrUserName, iTime];
                BOOL bFlag = [cdataCaptured writeToFile:cstrImageUrl atomically:YES];
                if (bFlag) {

                    NSDictionary* cdicItem = @{k_image_url:cstrImageUrl, k_image_url_type:@(enum_scroll_view_image_url_file)};
                    [self.cmutarrContentMenu replaceObjectAtIndex:self.ccScrollviewPG.cpageControl.currentPage withObject:cdicItem];
                    [self.ccScrollviewPG feedImages:self.cmutarrContentMenu];
                }
            }
                break;
            case enum_mode_add_picture_to_gallery:
            {
                NSTimeInterval iTime = [[NSDate date] timeIntervalSince1970];
                NSString* cstrUserName = [[NSUserDefaults standardUserDefaults] objectForKey:k_peer_user_name];
                NSString* cstrImageUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@-%f.jpg", cstrUserName, iTime];
                BOOL bFlag = [cdataCaptured writeToFile:cstrImageUrl atomically:YES];
                if (bFlag) {
                    NSDictionary* cdicItem = @{k_image_url:cstrImageUrl, k_image_url_type:@(enum_scroll_view_image_url_file)};
                    [self.cmutarrContentMenu addObject:cdicItem];
                    [self.ccScrollviewPG feedImages:self.cmutarrContentMenu];
                }
                
            }
                break;
            default:
                break;
        }
       
    }];
    
}

@end
