//
//  DLViewPCInfo.m
//  DLAccessory
//
//  Created by Mertef on 1/13/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewPCInfo.h"
#import "DLMCConfig.h"
@implementation DLViewPCInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //
        self.backgroundColor = [UIColor whiteColor];
        [self addUIAvatar];
        self.clableName = [[UILabel alloc] init];
        self.clableName.textAlignment = NSTextAlignmentLeft;
        self.clableName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        [self addSubview:self.clableName];
        //sex
        self.clableSex = [[UILabel alloc] init];
        self.clableSex.textAlignment = NSTextAlignmentLeft;
        self.clableSex.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.clableSex];
        
        //age
        self.clableAge = [[UILabel alloc] init];
        self.clableAge.textAlignment = NSTextAlignmentLeft;
        self.clableAge.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.clableAge];
        
        //email
        self.clableEmail = [[UILabel alloc] init];
        self.clableEmail.textAlignment = NSTextAlignmentLeft;
        self.clableEmail.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self addSubview:self.clableEmail];
        
        //signature
        self.ctextviewSignature = [[UITextView alloc] init];
        self.ctextviewSignature.editable = NO;
        self.ctextviewSignature.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ctextviewSignature];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect srectAvatar = CGRectMake(4.0f, 4.0f, 80.0f, 80.0f);
    self.cimageviewAvator.frame = srectAvatar;
    CGRect srectName = CGRectZero;
    srectName = CGRectMake(CGRectGetMaxX(srectAvatar) + 4.0f, 4.0f, CGRectGetWidth(self.bounds) - CGRectGetMaxX(srectAvatar) - 8.0f , 30.0f);
    
    self.clableName.frame = srectName;
    //sex
    CGRect srectSex = CGRectZero;
    srectSex = CGRectMake(CGRectGetMinX(srectName), CGRectGetMaxY(srectName), CGRectGetWidth(srectName) , CGRectGetHeight(srectName));
    
    self.clableSex.frame = srectSex;
    //age
    CGRect srectAge = CGRectZero;
    srectAge = CGRectMake(CGRectGetMinX(srectName), CGRectGetMaxY(srectSex), CGRectGetWidth(srectName) , CGRectGetHeight(srectName));
    
    self.clableAge.frame = srectAge;
    //email
    
    CGRect srectEmail = CGRectZero;
    srectEmail = CGRectMake(CGRectGetMinX(srectAvatar), CGRectGetMaxY(srectAvatar), CGRectGetWidth(self.bounds) , CGRectGetHeight(srectName));
    
    self.clableEmail.frame = srectEmail;
    //signature
    CGRect srectSignature = CGRectZero;
    srectSignature = CGRectMake(CGRectGetMinX(srectAvatar), CGRectGetMaxY(srectEmail), CGRectGetWidth(self.bounds) , CGRectGetHeight(self.bounds) - CGRectGetMaxY(srectEmail));
    
    self.ctextviewSignature.frame = srectSignature;
}
-(void)addUIAvatar{
    self.cimageviewAvator = [[UIImageView alloc] initWithFrame: CGRectMake(4.0f, 4.0f, 80.0f, 80.0f)];
    self.cimageviewAvator.contentMode = UIViewContentModeScaleAspectFill;
    self.cimageviewAvator.image = [UIImage imageNamed:@"1.jpg"];
    self.cimageviewAvator.backgroundColor = [UIColor clearColor];
    CAShapeLayer* cShaperLayer = [CAShapeLayer layer];
    CGMutablePathRef rmutPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(rmutPath, NULL, self.cimageviewAvator.bounds);
    cShaperLayer.path = rmutPath;
    CGPathRelease(rmutPath);rmutPath = NULL;
    self.cimageviewAvator.layer.mask = cShaperLayer;
    [self addSubview:self.cimageviewAvator];
}

-(NSMutableAttributedString*)getTextAttribues:(NSString*)acstrText  name:(NSString*)acstrName{
    NSString* cstrName = [NSString stringWithFormat:@"%@: %@", acstrName, acstrText];
    NSMutableAttributedString* cmuttrStr = [[NSMutableAttributedString alloc] initWithString:cstrName attributes:nil];
    
    NSRange tTrangComma  = [[cmuttrStr string] rangeOfString:@":"];
    if (tTrangComma.location == NSNotFound) {
        return nil;
    }
    //        NSString* cstrLeftStringBeforeComma = [[cmuttrStr string] substringToIndex:tTrangComma.location];
    //        NSString* cstrRightStringBeforeComma = [[cmuttrStr string] substringFromIndex:tTrangComma.location];
    
    [cmuttrStr addAttributes:
     @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:k_color_green, NSUnderlineColorAttributeName:k_colore_blue}
                       range:NSMakeRange(0, tTrangComma.location + tTrangComma.length)];
    
    [cmuttrStr addAttributes:
     @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:k_color_pink, NSUnderlineColorAttributeName:k_colore_blue}
                       range:NSMakeRange(tTrangComma.location + tTrangComma.length, [[cmuttrStr string] length] - tTrangComma.location - 1)];
    return cmuttrStr;
}
-(void)setName:(NSString*)acstrName {
    //@"Name:  JoeMhamMertef
    self.clableName.attributedText = [self getTextAttribues:acstrName name:NSLocalizedString(@"k_pc_name", nil)];
}
-(void)setSex:(NSString*)acstrSex {
    self.clableSex.attributedText = [self getTextAttribues:acstrSex name:NSLocalizedString(@"k_pc_sex", nil)];

}
-(void)setAge:(NSString*)acstrAge {
    self.clableAge.attributedText = [self getTextAttribues:acstrAge name:NSLocalizedString(@"k_pc_age", nil)];

}
-(void)setEmail:(NSString*)acstrEmail {
    self.clableEmail.attributedText = [self getTextAttribues:acstrEmail name:NSLocalizedString(@"k_pc_email", nil)];
}
-(void)setSignature:(NSString*)acstrSignature {
    self.ctextviewSignature.text = acstrSignature;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
