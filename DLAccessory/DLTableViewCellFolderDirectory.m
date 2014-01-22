//
//  DLTableViewCellFolderDirectory.m
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTableViewCellFolderDirectory.h"
#import "DLMCConfig.h"
#import "TUTreeConfig.h"
#import "DLCache.h"
#import "FileItem.h"

@implementation DLTableViewCellFolderDirectory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(void)feedInfo:(FileItem*)accFileItem {
    [super feedInfo:accFileItem];
    self.cimageView.backgroundColor = [UIColor clearColor];
    self.cimageView.image = [UIImage imageNamed:@"folder_dir"];
    self.cbtnSaveToPhone.hidden = YES;
}
@end
