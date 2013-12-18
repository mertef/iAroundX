//
//  DLTableCellPopoutView.m
//  DLAccessory
//
//  Created by Mertef on 12/10/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLTableCellPopoutView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DLTableCellPopoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* cimageBg = [UIImage imageNamed:@"bg_pop_out"];
        cimageBg = [cimageBg resizableImageWithCapInsets:UIEdgeInsetsMake(8.0f, 2.0f, 2.0f, 70.0f) resizingMode:UIImageResizingModeStretch];
        _cimageviewBg = [[UIImageView alloc] initWithImage:cimageBg];
//        _cimageviewBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_cimageviewBg];

        [self setAnchorPoint:CGPointMake(0.5f, 0.0f) forView:self];
        self.backgroundColor = [UIColor clearColor];
        
        _cbtnGallery = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cbtnGallery setImage:[UIImage imageNamed:@"gallery"] forState:UIControlStateNormal];
        [self addSubview:_cbtnGallery];
        
        _cbtnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cbtnCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self addSubview:_cbtnCamera];

        _cbtnChat = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cbtnChat setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [self addSubview:_cbtnChat];


    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _cimageviewBg.frame = self.bounds;

    CGFloat fWidth = (CGRectGetWidth(self.frame) - 20.0f) / 3.0f;
    CGFloat fHeight = CGRectGetHeight(self.frame) - 18.0f;
    _cbtnGallery.frame = CGRectMake(10.0f, 14.0f, fWidth, fHeight);
    _cbtnCamera.frame = CGRectMake(CGRectGetMaxX(_cbtnGallery.frame), 14.0f, fWidth, fHeight);
    _cbtnChat.frame = CGRectMake(CGRectGetMaxX(_cbtnCamera.frame), 14.0f, fWidth, fHeight);


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}
@end
