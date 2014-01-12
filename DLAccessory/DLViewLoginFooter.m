//
//  DLViewLoginFooter.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLViewLoginFooter.h"
#import "DLMCConfig.h"

@implementation DLViewLoginFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cbtnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cbtnRegister.layer.borderColor = k_color_gray0.CGColor;

        [self.cbtnRegister setTitleColor:k_color_gray1 forState:UIControlStateNormal];
        [self.cbtnRegister setTitleColor:k_color_green forState:UIControlStateHighlighted];
        [self.cbtnRegister setTitleColor:k_color_white forState:UIControlStateSelected];
        [self.cbtnRegister setBackgroundImage:[UIImage imageNamed:@"blue0"] forState:UIControlStateHighlighted];
        [self.cbtnRegister setBackgroundImage:[UIImage imageNamed:@"blue0_hl"] forState:UIControlStateHighlighted];
        self.cbtnRegister.layer.borderWidth = 1.0f;
        
        [self.cbtnRegister setTitle:NSLocalizedString(@"k_register", nil) forState:UIControlStateNormal];
        
        [self addSubview:_cbtnRegister];
        
        self.cbtnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnLogin setTitle:NSLocalizedString(@"k_login", nil) forState:UIControlStateNormal];
        [self.cbtnLogin setTitleColor:k_color_gray1 forState:UIControlStateNormal];
        [self.cbtnLogin setTitleColor:k_color_green forState:UIControlStateHighlighted];
        [self.cbtnLogin setTitleColor:k_color_white forState:UIControlStateSelected];
        [self.cbtnLogin setBackgroundImage:[UIImage imageNamed:@"blue0"] forState:UIControlStateHighlighted];
        [self.cbtnLogin setBackgroundImage:[UIImage imageNamed:@"blue0_hl"] forState:UIControlStateHighlighted];
        self.cbtnLogin.highlighted = YES;
        
        self.cbtnLogin.layer.borderColor = self.cbtnRegister.layer.borderColor;
        self.cbtnLogin.layer.borderWidth = 1.0f;
        [self addSubview:_cbtnLogin];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.cbtnRegister.frame = CGRectMake(10.0f, (CGRectGetHeight(self.bounds) - 36.0f) * 0.5f, (CGRectGetWidth(self.bounds) - 40.0f) * 0.5f , 36.0f);
    self.cbtnLogin.frame = CGRectMake(CGRectGetMaxX(self.cbtnRegister.frame) + 20.0f, (CGRectGetHeight(self.bounds) - 36.0f) * 0.5f, (CGRectGetWidth(self.bounds) - 40.0f) * 0.5f , 36.0f);

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
