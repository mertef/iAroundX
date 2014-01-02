//
//  DLViewMore.m
//  DLAccessory
//
//  Created by Mertef on 12/27/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLViewMore.h"
#import "DLMCConfig.h"
@implementation DLViewMore

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        /*
         more_camera@2x.png
         more_gallery@x.png
         more_location@2x.png
         more_video@2x.png
         */
        _cbtnGallery = [[UIButton alloc] initWithFrame:CGRectZero];
//        _cbtnGallery.backgroundColor = [UIColor blueColor];
        UIImage* cimageGallery = [UIImage imageNamed:@"more_gallery"];
        [_cbtnGallery setImage:cimageGallery forState:UIControlStateNormal];
        [self addSubview:_cbtnGallery];
        
        _cbtnCamera = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cbtnCamera setImage:[UIImage imageNamed:@"more_camera"] forState:UIControlStateNormal];
        [self addSubview:_cbtnCamera];
        
        _cbtnVideo = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cbtnVideo setImage:[UIImage imageNamed:@"more_video"] forState:UIControlStateNormal];
        [self addSubview:_cbtnVideo];
        
        _cbtnLocation = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cbtnLocation setImage:[UIImage imageNamed:@"more_location"] forState:UIControlStateNormal];
        [self addSubview:_cbtnLocation];
        
        
        _cbtnFile = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cbtnFile setImage:[UIImage imageNamed:@"more_folder"] forState:UIControlStateNormal];
        [self addSubview:_cbtnFile];
        
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fWidth = CGRectGetWidth(self.frame) - 60.0f;
//    CGFloat fHeight = CGRectGetHeight(self.frame) - 20.0f;
    CGFloat fHOffset = fWidth / 3.0f;
    CGFloat fImageWidth = 64.0f ;//[_cbtnGallery imageForState:UIControlStateNormal].size.width;
    _cbtnGallery.frame = CGRectMake(20.0f + (fHOffset - fImageWidth) * 0.5f, 20.0f, fImageWidth, fImageWidth);
    _cbtnCamera.frame = CGRectMake(CGRectGetMaxX(_cbtnGallery.frame) + 20.0f +(fHOffset - fImageWidth) * 0.5f, 20.0f, fImageWidth, fImageWidth);
    _cbtnVideo.frame =  CGRectMake(CGRectGetMaxX(_cbtnCamera.frame) + 20.0f +(fHOffset - fImageWidth) * 0.5f, 20.0f, fImageWidth, fImageWidth);
    _cbtnLocation.frame =CGRectMake(20.0f + (fHOffset - fImageWidth) * 0.5f, CGRectGetMaxY(_cbtnGallery.frame) + 20.0f, fImageWidth, fImageWidth);
    _cbtnFile.frame = CGRectMake(CGRectGetMaxX(_cbtnLocation.frame) + 30.0f, CGRectGetMaxY(_cbtnGallery.frame) + 20.0f, fImageWidth, fImageWidth);
    
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
