//
//  DLViewCtrlRegister.h
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLViewRegister;
@interface DLViewCtrlRegister : DLRootViewCtrl<UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property(strong, nonatomic) DLViewRegister* ccviewRegister;
@property(strong, nonatomic) UIImage* cimageAvator;
@property(strong, nonatomic) UIActionSheet* cactionSheet;
@end
