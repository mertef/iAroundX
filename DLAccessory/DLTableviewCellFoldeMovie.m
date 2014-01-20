//
//  DLTableviewCellFoldeMovie.m
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTableviewCellFolderMovie.h"
#import <AVFoundation/AVFoundation.h>
#import "DLMCConfig.h"
#import "TUTreeConfig.h"
#import "DLCache.h"
#import "FileItem.h"

@implementation DLTableviewCellFolderMovie

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cbtnMovieIndicator = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cbtnMovieIndicator.frame = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        [self.cbtnMovieIndicator setImage:[UIImage imageNamed:@"movie_indicator"] forState:UIControlStateNormal];
        [self.cbtnMovieIndicator setImage:[UIImage imageNamed:@"movie_indicator_h"] forState:UIControlStateHighlighted];
        [self.cimageView addSubview:self.cbtnMovieIndicator];

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.cbtnMovieIndicator setCenter:CGPointMake(self.cimageView.center.x - 2.0f, self.cimageView.center.y - 4.0f)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedInfo:(FileItem*)accFileItem {
    [super feedInfo:accFileItem];
    UIImage* cimageCache = [[DLCache sharedInstance] objectForKey:accFileItem.path];
    if (cimageCache) {
        self.cimageView.image = cimageCache;
    }else {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            @autoreleasepool {
                
                AVAsset* casset = [AVAsset assetWithURL:[NSURL fileURLWithPath:accFileItem.path]];
                AVAssetImageGenerator* cAssetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:casset];
                CMTime tTimeActually;
                NSError* cError = nil;
                CGImageRef rImageFirstFrame = [cAssetImageGenerator copyCGImageAtTime:CMTimeMake(1, 1) actualTime:&tTimeActually error:&cError];
                UIImage* cimageFirstFrame = [UIImage imageWithCGImage:rImageFirstFrame];
                
                //                __weak DLTableViewCellFolder* wccFolderCell = self;
                if (!cError) {
                    self.cimageView.image = cimageFirstFrame;
                    NSString* cstrPath = accFileItem.path;
                    if (cstrPath) {
                        [[DLCache sharedInstance] setObject:cimageFirstFrame forKey:cstrPath];
                    }
                    CGImageRelease(rImageFirstFrame);
                }else {
                    NSLog(@"%@", [cError description]);
                }
            }

//        });
        
    }
    
}
@end
