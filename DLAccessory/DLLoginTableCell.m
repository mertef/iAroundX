//
//  DLLoginTableCell.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLLoginTableCell.h"
#import "DLMCConfig.h"

@implementation DLLoginTableCell
@synthesize cdicInfo = _cdic_info;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.ctextfieldInput = [[UITextField alloc] init];
        self.ctextfieldInput.textAlignment = NSTextAlignmentLeft;
        self.ctextfieldInput.borderStyle = UITextBorderStyleNone;
        self.ctextfieldInput.leftViewMode = UITextFieldViewModeAlways;
        self.ctextfieldInput.delegate = self;
        [self.contentView addSubview:self.ctextfieldInput];
        
        self.cimageviewLeft = [[UIImageView alloc] init];
        self.cimageviewLeft.contentMode = UIViewContentModeScaleAspectFit;
        self.cimageviewLeft.backgroundColor = [UIColor clearColor];
        self.ctextfieldInput.leftView = self.cimageviewLeft;

    }
    return self;
}

- (void)dealloc
{
    _cdic_info = nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedInfo:(NSDictionary*)acdicInfo {
    _cdic_info = nil;
    _cdic_info = acdicInfo;
    NSString* cstrLeftImage = acdicInfo[k_login_left_icon];
    NSString* cstrLeftPlaceholder = acdicInfo[k_login_place_holder];
    self.ctextfieldInput.placeholder = cstrLeftPlaceholder;
    self.cimageviewLeft.image = [UIImage imageNamed:cstrLeftImage];
    if ([acdicInfo[k_login_name] isEqualToString:k_pwd]) {
        [self.ctextfieldInput setSecureTextEntry:YES];
    }else {
        [self.ctextfieldInput setSecureTextEntry:NO];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect srectInput = CGRectInset(self.contentView.bounds, 4.0f, 4.0f);
    srectInput.origin = CGPointMake(2.0f, 2.0f);
    self.ctextfieldInput.frame = srectInput;
    UIImageView* cimageViewLeft = (UIImageView*)[self.ctextfieldInput leftView];
   cimageViewLeft.frame = CGRectMake(0.0f, 0.0f, cimageViewLeft.image.size.width, cimageViewLeft.image.size.height);

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [(NSMutableDictionary*)self.cdicInfo setObject:textField.text forKey:k_login_value];
}

@end
