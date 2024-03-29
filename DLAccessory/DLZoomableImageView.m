//
//  DLZoomableImageView.m
//  DLAccessory
//
//  Created by Mertef on 1/10/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLZoomableImageView.h"
@implementation DLZoomableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        _cimageViewContent = [[UIImageView alloc] init];
        _cimageViewContent.contentMode = UIViewContentModeScaleAspectFit;
        _cimageViewContent.backgroundColor = [UIColor clearColor];
        self.contentInset = UIEdgeInsetsZero;
        [self addSubview:_cimageViewContent];
        self.delegate = self;
        self.cbtnSave = [[UIButton alloc] init];
        [self addSubview:self.cbtnSave];
//        UIPinchGestureRecognizer* cpincGesRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionPinch:)];
//        [self addGestureRecognizer:cpincGesRec];
        
        UITapGestureRecognizer* cTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapExit:)];
        [self addGestureRecognizer:cTapGes];
        UISwipeGestureRecognizer* cSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe:)];
        [self addGestureRecognizer:cSwipeGes];
        UISwipeGestureRecognizer* cSwipeGesLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe:)];
        cSwipeGesLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:cSwipeGesLeft];

        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 5.0f;
        
        self.clablePageNumber = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 100.0f) * 0.5f , CGRectGetHeight(self.bounds) - 30.0f, 100.0f, 30.0f)];
        self.clablePageNumber.textAlignment = NSTextAlignmentCenter;
        self.clablePageNumber.backgroundColor = [UIColor colorWithRed:161.0f/255.0f green:204.0/255.0f blue:58.0f/255.0f alpha:1.0f];
        self.clablePageNumber.textColor = [UIColor whiteColor];
        self.clablePageNumber.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.clablePageNumber.hidden = YES;
        [self addSubview:self.clablePageNumber];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect srectPage = self.clablePageNumber.frame;
    CGPoint spointOffset = self.contentOffset;
    self.clablePageNumber.frame = CGRectMake((CGRectGetWidth(self.bounds) - 100.0f) * 0.5f + spointOffset.x,  CGRectGetHeight(self.bounds) - 30.0f + spointOffset.y, srectPage.size.width , srectPage.size.height);
}
-(void)actionPinch:(UIPinchGestureRecognizer*)acPinchGes {
}
-(void)actionTapExit:(UITapGestureRecognizer*)acTapGes {
//    UIWindow* cWindow = [[UIApplication sharedApplication] keyWindow];
    self.zoomScale = 1.0f;
    [UIView animateWithDuration:.5f animations:^(void){
        self.alpha = 0.0f;
        self.cimageViewContent.frame = self.srectFrom;
    }completion:^(BOOL abFinished){
        self.cimageViewContent.hidden = YES;
        [self removeFromSuperview];
    }];
}
-(void)actionSwipe:(UISwipeGestureRecognizer*)acSwipeGes {
    if (acSwipeGes.state == UIGestureRecognizerStateEnded) {
        if (acSwipeGes.direction == UISwipeGestureRecognizerDirectionLeft) {
            if ([self.idProtoZoomableImageView respondsToSelector:@selector(didSwipeLeft:)]) {
                [self.idProtoZoomableImageView didSwipeLeft:self];
            }
        }else if(acSwipeGes.direction == UISwipeGestureRecognizerDirectionRight) {
            if ([self.idProtoZoomableImageView respondsToSelector:@selector(didSwipeRight:)]) {
                [self.idProtoZoomableImageView didSwipeRight:self];
            }
        }
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"scrollViewDidEndDragging frame %@", NSStringFromCGRect(self.cimageViewContent.frame));
//    NSLog(@"scrollViewDidEndDragging bounds %@", NSStringFromCGRect(self.cimageViewContent.bounds));
//    NSLog(@"scrollViewDidEndDragging center %@", NSStringFromCGPoint(self.cimageViewContent.center));
//
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//  //recenter the image
//    NSLog(@"scrollViewDidEndZooming frame %@", NSStringFromCGRect(self.cimageViewContent.frame));
//    NSLog(@"scrollViewDidEndZooming bounds %@", NSStringFromCGRect(self.cimageViewContent.bounds));
//    NSLog(@"scrollViewDidEndDragging center %@", NSStringFromCGPoint(self.cimageViewContent.center));
//
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"frame %@", NSStringFromCGRect(self.cimageViewContent.frame));
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _cimageViewContent;
}

-(void)setImage:(UIImage*)acImage {
    self.cimageViewContent.image = acImage;
}
-(CGRect)getScalingRectAtZoomScale:(CGFloat)afScaleFactor {
    CGRect srectZoom = CGRectZero;
    CGSize sSizeImage = self.cimageViewContent.image.size;
    CGFloat fScaleRatio = sSizeImage.width / sSizeImage.height;
    
    sSizeImage.width *= afScaleFactor;
    sSizeImage.height *= afScaleFactor;
    
    if (sSizeImage.width >= CGRectGetWidth(self.frame)) {
        sSizeImage.width = CGRectGetWidth(self.frame);
        sSizeImage.height = sSizeImage.width / fScaleRatio;
    }
    
    srectZoom.origin = CGPointMake((CGRectGetWidth(self.frame) - sSizeImage.width) * 0.5f, (CGRectGetHeight(self.frame) - sSizeImage.height) * 0.5f);
    srectZoom.size = sSizeImage;
   
    return srectZoom;
}
-(void)appearAnimationFromRect:(CGRect)acRectFrom {
    self.srectFrom = acRectFrom;
    self.cimageViewContent.frame = acRectFrom;
    self.alpha = 0.2f;
    [UIView animateWithDuration:.5f animations:^(void){
        self.cimageViewContent.frame = [self getScalingRectAtZoomScale:1.0f];
        _srect_content_fit = self.cimageViewContent.frame;
        self.alpha = 1.0f;
    }completion:^(BOOL abFinished){
        
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect srectFrame = self.cimageViewContent.frame;
    CGFloat fYOffset = CGRectGetHeight(self.frame) - CGRectGetMaxY(self.cimageViewContent.frame);
    CGFloat fYOffsetHeight = CGRectGetHeight(self.frame) - CGRectGetHeight(self.cimageViewContent.frame);

//    NSLog(@"offste --- %f", fYOffset);
    if (fYOffset > 0) {
        srectFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.cimageViewContent.frame)) * 0.5f;
    }else if(fYOffsetHeight > 0){
        srectFrame.origin.y = 0.0f;
    }
    self.cimageViewContent.frame = srectFrame;

//    NSLog(@"%@ %@" , NSStringFromCGRect(self.cimageViewContent.frame), NSStringFromCGSize(scrollView.contentSize));
    
 

}
@end
