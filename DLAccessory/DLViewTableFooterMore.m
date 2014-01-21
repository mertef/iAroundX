//
//  DLViewTableFooterMore.m
//  DLAccessory
//
//  Created by Mertef on 1/21/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewTableFooterMore.h"
#import "DLMCConfig.h"

@implementation DLViewTableFooterMore

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.cbtnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnMore setTitleColor:k_colore_blue forState:UIControlStateNormal];
        [self.cbtnMore setTitleColor:k_color_green forState:UIControlStateHighlighted];
        [self.cbtnMore setTitle:NSLocalizedString(@"k_load_more_file", nil) forState:UIControlStateNormal];
        [[self contentView] addSubview:self.cbtnMore];

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.cbtnMore.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) * 0.2, CGRectGetHeight(self.contentView.bounds) * 0.1f, CGRectGetWidth(self.contentView.bounds) * 0.6, CGRectGetHeight(self.contentView.bounds) * 0.8f);
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
