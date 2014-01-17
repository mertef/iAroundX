//
//  DLTableviewCellFolderPicture.m
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTableviewCellFolderPicture.h"
#import "DLMCConfig.h"
#import "TUTreeConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "DLCache.h"

@implementation DLTableviewCellFolderPicture

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

-(void)feedInfo:(NSDictionary*)acdicInfo; {
    [super feedInfo:acdicInfo];
    UIImage* cimageCache = [[DLCache sharedInstance] objectForKey:acdicInfo[k_path]];
    if (cimageCache) {
        self.cimageView.image = cimageCache;
    }else {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            @autoreleasepool {
                self.cimageView.image = [UIImage imageWithContentsOfFile:acdicInfo[k_path]];
                NSString* cstrPath = [acdicInfo objectForKey:k_path];
                if (cstrPath) {
                    [[DLCache sharedInstance] setObject:self.cimageView.image forKey:cstrPath];
                }
            }
//        });
    }
    self.clableFileName.text = [self.cdicInfo objectForKey:k_content];

}
@end
