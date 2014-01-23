//
//  DLViewRegister.m
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewRegister.h"
#import "DLMCConfig.h"
#import <QuartzCore/QuartzCore.h>


@implementation DLViewRegister

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //name
        self.ctextfieldName = [[UITextField alloc] init];
        self.ctextfieldName.borderStyle = UITextBorderStyleLine;
        self.ctextfieldName.layer.borderColor = [k_color_green CGColor];
        self.ctextfieldName.placeholder = NSLocalizedString(@"k_reg_name", nil);
        self.ctextfieldName.layer.borderWidth = 1.0f;
        self.ctextfieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.ctextfieldName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.ctextfieldName];
        
        //sex
        self.cswitchSexuality = [[UISwitch alloc] init];
        [self.cswitchSexuality addTarget:self action:@selector(actionChange:) forControlEvents:UIControlEventValueChanged];

        [self  addSubview:self.cswitchSexuality];
        self.clableSex = [[UILabel alloc] init];
        self.clableSex.text = NSLocalizedString(@"k_reg_sex_man", nil);
        self.clableSex.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.clableSex];
        
        //age
        self.cpickerViewAge = [[UIPickerView alloc] init];
        self.ctextfieldAge = [[UITextField alloc] init];
        self.ctextfieldAge.borderStyle = UITextBorderStyleLine;
        self.ctextfieldAge.layer.borderColor = [k_color_green CGColor];
        self.ctextfieldAge.layer.borderWidth = 1.0f;
        
        self.ctextfieldAge.placeholder = NSLocalizedString(@"k_reg_age", nil);

        self.ctextfieldAge.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.ctextfieldAge.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.ctextfieldAge];

        //email
        self.ctextfieldEmail = [[UITextField alloc] init];
        self.ctextfieldEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.ctextfieldEmail.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.ctextfieldEmail.borderStyle = UITextBorderStyleLine;
        self.ctextfieldEmail.layer.borderColor = [k_color_green CGColor];
        self.ctextfieldEmail.layer.borderWidth = 1.0f;
        self.ctextfieldEmail.placeholder = NSLocalizedString(@"k_reg_email", nil);

        [self addSubview:self.ctextfieldEmail];
        //signature
        self.ctextviewSignature = [[UITextView alloc] init];
        self.ctextviewSignature.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.ctextviewSignature];
        self.ctextviewSignature.layer.borderWidth = 1.0f;
        self.ctextviewSignature.layer.borderColor = [k_color_green CGColor];
        self.ctextviewSignature.text = NSLocalizedString(@"k_reg_sig", nil);
        //avatar
        self.cimageViewAvatar = [[UIImageView alloc] init];
        self.cimageViewAvatar.backgroundColor = [UIColor clearColor];
        self.cimageViewAvatar.backgroundColor = k_color_green;
        CAShapeLayer* cshapeMask = [CAShapeLayer layer];
        cshapeMask.path =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)].CGPath;
        self.cimageViewAvatar.layer.mask = cshapeMask;
        
        [self addSubview:self.cimageViewAvatar];
        
        

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fLeft = 20.0f;
    CGFloat fW = CGRectGetWidth(self.frame) - fLeft * 2.0f;
    CGFloat fH = CGRectGetHeight(self.frame);
    CGFloat fHT = 44.0f;
    self.cimageViewAvatar.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.5f - 30.0f, 4.0f, 60.0f, 60.0f);
    self.ctextfieldName.frame = CGRectMake(fLeft, CGRectGetMaxY(self.cimageViewAvatar.frame) + 4.0f,fW, 44.0f);
    self.cswitchSexuality.frame = CGRectMake(fLeft, CGRectGetMaxY(self.ctextfieldName.frame) + 4.0f, 80.0f, fHT);
    self.clableSex.frame = CGRectMake(CGRectGetMaxX(self.cswitchSexuality.frame) + 4.0f, CGRectGetMinY(self.cswitchSexuality.frame), fW * 0.5f, fHT);

    self.ctextfieldAge.frame = CGRectMake(fLeft, CGRectGetMaxY(self.cswitchSexuality.frame) + 4.0f, fW, fHT);
    self.ctextfieldEmail.frame = CGRectMake(fLeft, CGRectGetMaxY(self.ctextfieldAge.frame) + 4.0f, fW, fHT);
    
    self.cpickerViewAge.frame = CGRectMake(0.0f, 0.0f, fW, fH * 0.4f);
    self.ctextviewSignature.frame = CGRectMake(fLeft, CGRectGetMaxY(self.ctextfieldEmail.frame) + 4.0f, fW, fH - CGRectGetMaxY(self.ctextfieldEmail.frame) - 4.0f - 44.0f);
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)actionChange:(id)aidSender {
    if (self.cswitchSexuality.isOn) {
        self.clableSex.text = NSLocalizedString(@"k_reg_sex_woman", nil);
    }else {
        self.clableSex.text = NSLocalizedString(@"k_reg_sex_man", nil);
    }
}

@end
