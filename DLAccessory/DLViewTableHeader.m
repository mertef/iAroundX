//
//  DLViewTableHeader.m
//  DLAccessory
//
//  Created by Mertef on 1/21/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewTableHeader.h"
#import "DLMCConfig.h"

@implementation DLViewTableHeader

/*
 "k_new_foler"= "New Folder";
 "k_order_folder"="Order";
 "k_rescan" = "Scan";
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        self.cbtnCreateFolder = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnCreateFolder setImage:[UIImage imageNamed:@"create_folder"] forState:UIControlStateNormal];
        [self.cbtnCreateFolder setImage:[UIImage imageNamed:@"create_folder_h"] forState:UIControlStateHighlighted];

        [[self contentView] addSubview:self.cbtnCreateFolder];
        //
        self.cbtnEditOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnEditOrder setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
        [self.cbtnEditOrder setImage:[UIImage imageNamed:@"order_h"] forState:UIControlStateHighlighted];
        [self.cbtnEditOrder setImage:[UIImage imageNamed:@"order_s"] forState:UIControlStateSelected];


        [[self contentView] addSubview:self.cbtnEditOrder];
        //
        self.cbtnReScan = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnReScan setImage:[UIImage imageNamed:@"folder_refresh"] forState:UIControlStateNormal];
        [self.cbtnReScan setImage:[UIImage imageNamed:@"folder_refresh_h"] forState:UIControlStateHighlighted];

        [[self contentView] addSubview:self.cbtnReScan];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fW = CGRectGetWidth(self.contentView.bounds) - 20.0f - 60.0f;
    CGFloat fH = CGRectGetHeight(self.contentView.bounds) - 8.0f;
    CGRect srectFolder = CGRectMake(10.0f, 4.0f, fW / 3.0f, fH);
    self.cbtnCreateFolder.frame = srectFolder;
    srectFolder.origin.x += (srectFolder.size.width + 30.0f);
    self.cbtnEditOrder.frame = srectFolder;
    srectFolder.origin.x += (srectFolder.size.width + 30.0f);
    self.cbtnReScan.frame = srectFolder;
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
