//
//  DLTableviewCellFolderMusicCell.m
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTableviewCellFolderMusic.h"

@implementation DLTableviewCellFolderMusic

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedInfo:(FileItem*)accFileItem {
    [super feedInfo:accFileItem];
    self.cimageView.backgroundColor = [UIColor clearColor];
    self.cimageView.image = [UIImage imageNamed:@"music"];
     self.cimageView.highlightedImage = [UIImage imageNamed:@"music_h"];
}
@end
