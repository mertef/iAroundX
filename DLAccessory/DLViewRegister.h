//
//  DLViewRegister.h
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLViewRegister : UIView
@property(strong, nonatomic) UITextField* ctextfieldName,* ctextfieldAge, * ctextfieldEmail;
@property(strong, nonatomic) UITextView* ctextviewSignature;
@property(strong, nonatomic) UIImageView* cimageViewAvatar;
@property(strong, nonatomic) UISwitch* cswitchSexuality;
@property(strong, nonatomic) UIPickerView* cpickerViewAge;
@property(strong, nonatomic) UILabel* clableSex;
@property(strong, nonatomic) UIButton* cbtnCommit;
-(void)actionChange:(id)aidSender;
@end
