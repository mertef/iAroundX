//
//  DLViewPCInfo.h
//  DLAccessory
//
//  Created by Mertef on 1/13/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLViewPCInfo : UIView
@property(strong, nonatomic) UIImageView* cimageviewAvator;
@property(strong, nonatomic) UILabel* clableName, * clableSex, * clableAge, * clableEmail;
@property(strong, nonatomic) UITextView* ctextviewSignature;
-(void)addUIAvatar;
-(void)setName:(NSString*)acstrName;
-(void)setSex:(NSString*)acstrSex;
-(void)setAge:(NSString*)acstrAge;
-(void)setEmail:(NSString*)acstrEmail;
-(void)setSignature:(NSString*)acstrSignature;
-(NSMutableAttributedString*)getTextAttribues:(NSString*)acstrText  name:(NSString*)acstrName;

@end
