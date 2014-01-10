//
//  DLProgressView.m
//  DLAccessory
//
//  Created by Mertef on 1/10/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLProgressView.h"

@implementation DLProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.cProgressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [self addSubview:self.cProgressIndicator];
        
        self.cLableProgressInfo = [[UILabel alloc] init];
        self.cLableProgressInfo.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:8.0f];
        self.cLableProgressInfo.backgroundColor = [UIColor clearColor];
        self.cLableProgressInfo.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.cLableProgressInfo];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fHeight = CGRectGetHeight(self.bounds);
    self.cProgressIndicator.frame = CGRectMake(10.0f, 4.0f, CGRectGetWidth(self.bounds) - 20.0f, (fHeight  - 8.0f) * 0.2);
    self.cLableProgressInfo.frame = CGRectMake(10.0f, CGRectGetMaxY(self.cProgressIndicator.frame), CGRectGetWidth(self.cProgressIndicator.frame), (fHeight - 8.0f) * 0.8f);
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
