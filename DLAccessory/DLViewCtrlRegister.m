//
//  DLViewCtrlRegister.m
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewCtrlRegister.h"
#import "DLViewRegister.h"
#import "DLMCConfig.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DLViewCtrlRegister ()
@property(strong,nonatomic) NSMutableArray* cmutAges;
@end

@implementation DLViewCtrlRegister

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cmutAges = [[NSMutableArray alloc] init];
        for (int i = 10; i <= 120; i ++) {
            [self.cmutAges addObject:@(i)];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame) - 20.0f);
	// Do any additional setup after loading the view.
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    self.ccviewRegister = [[DLViewRegister alloc] initWithFrame:self.view.bounds];
    self.ccviewRegister.ctextviewSignature.delegate = self;
    
    UIToolbar* ctoobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f)];
    UIBarButtonItem* cbarBtnDown = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"k_done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(actionDoneSignature:)];
    [ctoobar setItems:@[cbarBtnDown]];
    self.ccviewRegister.ctextviewSignature.inputAccessoryView = ctoobar;
    self.ccviewRegister.cpickerViewAge.dataSource = self;
    self.ccviewRegister.cpickerViewAge.delegate = self;
    self.ccviewRegister.ctextfieldAge.delegate = self;
    [self.ccviewRegister.cbtnCommit addTarget:self action:@selector(actionCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ccviewRegister];
    
    UITapGestureRecognizer* cTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDimissInput:)];
    [self.view addGestureRecognizer:cTap];
    
    self.cactionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"k_select_avatar", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"k_pc_gallery", nil), NSLocalizedString(@"k_pc_camera", nil), nil];
    self.cactionSheet.delegate = self;
    
    UITapGestureRecognizer* cTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionchangeAvatar:)];
    [cTap requireGestureRecognizerToFail:cTapGes];

    [self.ccviewRegister.cimageViewAvatar addGestureRecognizer:cTapGes];
    
    self.title = NSLocalizedString(@"k_register_title", nil);
    
}
-(void)actionchangeAvatar:(id)aidSender {
    [self.cactionSheet showFromRect:CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)  *0.2f) inView:self.view animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"button index %ld", (long)buttonIndex);
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
        default:
            break;
    }
}

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
            cimageEditedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            cdataCaptured = UIImageJPEGRepresentation(cimageEditedImage, 0.5f);
        }
        self.cimageAvator = cimageEditedImage;
        self.ccviewRegister.cimageViewAvatar.image = cimageEditedImage;
    }];
}
     
-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}
-(void)actionDimissInput:(id)aidSender {
    if ([self.ccviewRegister.ctextfieldName isFirstResponder]) {
        [self.ccviewRegister.ctextfieldName resignFirstResponder];
    }else if ([self.ccviewRegister.ctextfieldEmail isFirstResponder]) {
        [self.ccviewRegister.ctextfieldEmail resignFirstResponder];
    }else if ([self.ccviewRegister.ctextviewSignature isFirstResponder]) {
        [self actionDoneSignature:nil];
    }else if(self.ccviewRegister.cpickerViewAge.center.y < CGRectGetHeight(self.view.bounds)) {
        [UIView animateWithDuration:0.5f animations:^(void){
            self.ccviewRegister.cpickerViewAge.center = CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f, CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.ccviewRegister.cpickerViewAge.frame) * 2.5f);
        }];
    }
}
-(void)actionDoneSignature:(id)aidSender {
    self.ccviewRegister.cpickerViewAge.hidden = YES;
    if ([self.ccviewRegister.ctextviewSignature isFirstResponder]) {
        [self.ccviewRegister.ctextviewSignature resignFirstResponder];
        [UIView animateWithDuration:0.5f animations:^(void){
            CGPoint spointCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
            self.ccviewRegister.center = spointCenter;
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textview callback 
- (void)textViewDidEndEditing:(UITextView *)textView {
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.ccviewRegister.cpickerViewAge.hidden = YES;
    if (self.ccviewRegister.center.y == CGRectGetMidY(self.view.bounds)) {
        [UIView animateWithDuration:0.5f animations:^(void){
            CGPoint spointCenter = self.view.center;
            spointCenter.y = spointCenter.y - k_height_keyboard - 70.0f;
            self.ccviewRegister.center = spointCenter;
            if ([self.ccviewRegister.ctextviewSignature.text isEqualToString:NSLocalizedString(@"k_reg_sig", nil)]) {
                self.ccviewRegister.ctextviewSignature.text = @"";
            }
        }];
    }
}
#pragma mark - picker view 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.cmutAges count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(self.view.bounds);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.0f;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.ccviewRegister.ctextfieldAge.text = [[self.cmutAges objectAtIndex: row] stringValue];

    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSNumber* cnumber = [self.cmutAges objectAtIndex:row];
    UILabel* clabelAge = (UILabel*)view;
    if (view) {
        clabelAge.text = [cnumber stringValue];
    }else {

        CGRect srectView = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 36.0f);
        clabelAge = [[UILabel alloc] initWithFrame:srectView];
        clabelAge.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        clabelAge.textAlignment = NSTextAlignmentCenter;
        clabelAge.text = [cnumber stringValue];
    }
    
    return clabelAge;
}

#pragma mark - textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.ccviewRegister.ctextfieldAge]) {
        [self actionDimissInput:nil];
        self.ccviewRegister.cpickerViewAge.hidden = NO;
        [self.ccviewRegister bringSubviewToFront:self.ccviewRegister.cpickerViewAge];
        if (self.ccviewRegister.cpickerViewAge.center.y >= CGRectGetHeight(self.view.bounds)) {
            [self.ccviewRegister bringSubviewToFront:self.ccviewRegister.cpickerViewAge];
            [UIView animateWithDuration:0.5f animations:^(void){
                self.ccviewRegister.cpickerViewAge.center = CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.ccviewRegister.cpickerViewAge.frame) * 0.5f);
            }];
        }
    }
   
    
    return NO;
}


-(void)actionCommit:(id)asender {
    if (!self.ccviewRegister.ctextfieldName && [self.ccviewRegister.ctextfieldName.text isEqualToString:@""]) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_name", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;
    }else if (!self.ccviewRegister.ctextfieldAge && [self.ccviewRegister.ctextfieldAge.text isEqualToString:@""]) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_age", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;

    }else if (!self.ccviewRegister.ctextfieldEmail && [self.ccviewRegister.ctextfieldEmail.text isEqualToString:@""]) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_email", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;

    }else if (!self.ccviewRegister.ctextviewSignature && [self.ccviewRegister.ctextviewSignature.text isEqualToString:@""]) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_signature", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;

    }else if ([self.ccviewRegister.ctextviewSignature.text length] < 10) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_sig_must_10_word", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;

    }else if ([self.ccviewRegister.ctextfieldName.text length] < 4) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_name_must_4_word", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;

    }else if (!self.cimageAvator) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_reg_title", nil) message:NSLocalizedString(@"k_reg_error_avator_required", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        
        [calertMsg show];
        return;
        
    }
    /*
    NSString* cstrName = self.ccviewRegister.ctextfieldName.text;
    NSString* cstrSex = self.ccviewRegister.cswitchSexuality.selected ? @"1":@"0";
    NSString* cstrAge = self.ccviewRegister.ctextfieldAge.text;
    NSString* cstrEmail = self.ccviewRegister.ctextfieldEmail.text;
    NSString* cstrSignatur = self.ccviewRegister.ctextviewSignature.text;
    */
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:k_user_register];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:k_user_login];

    
    [[NSNotificationCenter defaultCenter]  postNotificationName:k_noti_register_success object:nil];

    
}
@end
