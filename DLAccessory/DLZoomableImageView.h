//
//  DLZoomableImageView.h
//  DLAccessory
//
//  Created by Mertef on 1/10/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLZoomableImageView;
@protocol ProtoZoomableImageView<NSObject>
@optional
-(void)didSwipeLeft:(DLZoomableImageView*)accZoomableImageView;
-(void)didSwipeRight:(DLZoomableImageView*)accZoomableImageView;

@end
@interface DLZoomableImageView : UIScrollView<UIScrollViewDelegate> {
    CGRect _srect_content_fit;
}
@property(strong, nonatomic) UIImageView* cimageViewContent;
@property(strong, nonatomic) UIButton* cbtnSave;
@property(assign, nonatomic) CGRect srectFrom;
@property(assign, nonatomic) id<ProtoZoomableImageView> idProtoZoomableImageView;
@property(strong, nonatomic) UILabel* clablePageNumber;
-(void)actionPinch:(UIPinchGestureRecognizer*)acPinchGes;
-(void)setImage:(UIImage*)acImage;
-(void)appearAnimationFromRect:(CGRect)acRectFrom;
@end
