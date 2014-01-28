//
//  DLScrollViewPersonalGallery.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLScrollViewPersonalGallery.h"
#import "DLMCConfig.h"
#import "DLZoomableImageView.h"
#import "DLCache.h"
#import "DLViewPCInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "DLCircle.h"
#import "CSAnimation.h"

@interface DLScrollViewPersonalGallery() {
    dispatch_queue_t _dispatch_queue_image;
    NSMutableArray* _c_mut_arr_content_menus;
}
-(void)actionZoom:(UITapGestureRecognizer*)acTapGes;
-(void)showContentMenu;
-(void)hideContentMenu;
@end
@implementation DLScrollViewPersonalGallery

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cmutarrImages = [[NSMutableArray alloc] init];
        self.cimageviewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_bg@2x.jpg"]];
        self.cimageviewBg.contentMode = UIViewContentModeScaleAspectFill;
        self.cimageviewBg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cimageviewBg];
        
        CGRect srerctScroll  = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

        self.cscrollviewImage = [[UIScrollView alloc] initWithFrame:srerctScroll];
        self.cscrollviewImage.backgroundColor = [UIColor clearColor];
        self.cscrollviewImage.showsVerticalScrollIndicator = NO;
        self.cscrollviewImage.pagingEnabled = YES;
        self.cscrollviewImage.delegate = self;
        [self addSubview:self.cscrollviewImage];
        _dispatch_queue_image = dispatch_queue_create("image",  DISPATCH_QUEUE_CONCURRENT);
        self.cpageControl = [[UIPageControl alloc] init];
        self.cpageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self.cscrollviewImage addSubview:self.cpageControl];
    
        self.cbtnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.cbtnEdit.backgroundColor = [UIColor clearColor];
        [self.cbtnEdit setImage:[UIImage imageNamed:@"option_menu"] forState:UIControlStateNormal];
        [self.cbtnEdit setImage:[UIImage imageNamed:@"option_menu_h"] forState:UIControlStateHighlighted];

        self.cbtnEdit.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40.0f, CGRectGetHeight(self.bounds) - 36.0f, 36.0f, 36.0f);
        [self addSubview:self.cbtnEdit];
        [self.cbtnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
    //    NSLog(@"%@", NSStringFromCGRect(self.cscrollviewImage.frame));
        
//        DLCircle* ccCircle = [[DLCircle alloc] initWithFrame:self.bounds];
//        [self addSubview:ccCircle];
        self.cmutarrImageViews = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
//    self.cbtnEdit.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60.0f + self.cscrollviewImage.contentOffset.x, CGRectGetHeight(self.bounds) - 60.0f, 60.0f, 60.0f);
    [self.cscrollviewImage bringSubviewToFront:self.cbtnEdit];

}
- (void)dealloc
{
}
-(void)feedImages:(NSMutableArray*)acmutArrImages {

    for (UIImageView* cimageviewItem in self.cmutarrImageViews) {
        [cimageviewItem removeFromSuperview];
    }
    [self.cmutarrImageViews removeAllObjects];
    
    [self.cmutarrImages removeAllObjects];
    
    [self.cmutarrImages addObjectsFromArray:acmutArrImages];
    [self.cpageControl setNumberOfPages:[self.cmutarrImages count]];
    self.cpageControl.pageIndicatorTintColor = k_color_green;

//    NSLog(@"--- feed image%@", NSStringFromCGRect(self.cscrollviewImage.frame));

    CGSize sSizePage = [self.cpageControl sizeForNumberOfPages:[self.cmutarrImages count]];
    CGRect srect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds),CGRectGetHeight(self.cscrollviewImage.frame));
//    NSLog(@"--- feed image%@", NSStringFromCGRect(srect));

    self.cpageControl.frame = CGRectMake((CGRectGetWidth(srect) - sSizePage.width) * 0.5f, CGRectGetMaxY(srect) - sSizePage.height * 1.0f, sSizePage.width, sSizePage.height);
    self.cscrollviewImage.contentSize = CGSizeMake(CGRectGetWidth(self.cscrollviewImage.frame) * [self.cmutarrImages count], CGRectGetHeight(self.cscrollviewImage.frame));
    

    for (NSDictionary* cdicItem in self.cmutarrImages) {
        UIImageView* cimageView = [[UIImageView alloc] init];
        cimageView.image = [UIImage imageNamed:@"place_holder.jpg"];
        cimageView.clipsToBounds  = YES;
        cimageView.backgroundColor = [UIColor clearColor];
        cimageView.frame = srect;
        cimageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString* cstrUrl = [cdicItem objectForKey:k_image_url];
        NSNumber* cnumberUrlType = [cdicItem objectForKey:k_image_url_type];
        if ([cnumberUrlType intValue] == enum_scroll_view_image_url_app) {
            cimageView.image = [UIImage imageNamed:cstrUrl];
        }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_file) {
            cimageView.image = [UIImage imageWithContentsOfFile:cstrUrl];

        }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_network) {
            dispatch_async(_dispatch_queue_image, ^(void){
                UIImage* cimage = [[DLCache sharedInstance] objectForKey:cstrUrl];
                if (!cimage) {
                    cimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cstrUrl]]];
                    [[DLCache sharedInstance] setObject:cimage forKey:cstrUrl];
                }
                cimageView.image = cimage;
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    [cimageView setNeedsLayout];
                    
                });
            });
        }
        UITapGestureRecognizer* cTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionZoom:)];
        [cimageView addGestureRecognizer:cTapGes];
        cimageView.userInteractionEnabled = YES;
        [self.cmutarrImageViews addObject:cimageView];
        [self.cscrollviewImage addSubview:cimageView];
        srect.origin.x += srect.size.width;
    }
    [self.cscrollviewImage bringSubviewToFront:self.cpageControl];
  
}
-(void)actionZoom:(UITapGestureRecognizer*)acTapGes {
    UIView* cViewTapped = [acTapGes view];
    __weak UIImageView* cimageViewTapped = (UIImageView*)cViewTapped;
    UIWindow* cWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect srectFrom = [self.cscrollviewImage convertRect:cViewTapped.frame toView:cWindow];
    DLZoomableImageView* ccZoomableImageView = [[DLZoomableImageView alloc] initWithFrame:cWindow.bounds];
    ccZoomableImageView.cimageViewContent.contentMode = UIViewContentModeScaleAspectFill;
    ccZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.cpageControl.currentPage + 1, (unsigned long)self.cpageControl.numberOfPages];
    ccZoomableImageView.idProtoZoomableImageView = self;
    [cWindow addSubview:ccZoomableImageView];
    [ccZoomableImageView setImage:cimageViewTapped.image];
    [ccZoomableImageView appearAnimationFromRect:srectFrom];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.cscrollviewImage]) {
        CGFloat fPage = [scrollView contentOffset].x / CGRectGetWidth(self.bounds);
        self.cpageControl.currentPage = fPage;
        CGRect srectPage = self.cpageControl.frame;
        srectPage.origin.x = fPage * CGRectGetWidth(self.bounds) + (CGRectGetWidth(self.bounds) - srectPage.size.width) * 0.5f;
        self.cpageControl.frame = srectPage;
    }
}

-(void)didSwipeLeft:(DLZoomableImageView*)accZoomableImageView {
//    NSLog(@"swipte left");
    
    NSUInteger iCurrentPage = [self.cpageControl currentPage];
//    NSLog(@"current page is %lu", iCurrentPage);
    NSInteger iTempPage = ++iCurrentPage;
    if (iTempPage >= [self.cmutarrImages count]) {
        return;
    }
    [self.cpageControl setCurrentPage:iTempPage];
    //scroll to page
    [self.cscrollviewImage scrollRectToVisible:CGRectMake(CGRectGetWidth(self.bounds) * iTempPage, 0.0f, CGRectGetWidth(self.cscrollviewImage.frame), CGRectGetHeight(self.cscrollviewImage.frame)) animated:NO];
    NSDictionary* cdicItem = [self.cmutarrImages objectAtIndex:iTempPage];
    NSString* cstrUrl = [cdicItem objectForKey:k_image_url];
    NSNumber* cnumberUrlType = [cdicItem objectForKey:k_image_url_type];
     __weak UIImageView* cimageView = accZoomableImageView.cimageViewContent;
    if ([cnumberUrlType intValue] == enum_scroll_view_image_url_app) {
        cimageView.image = [UIImage imageNamed:cstrUrl];
    }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_file) {
        cimageView.image = [UIImage imageWithContentsOfFile:cstrUrl];
        
    }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_network) {
        dispatch_async(_dispatch_queue_image, ^(void){
            UIImage* cimage = [[DLCache sharedInstance] objectForKey:cstrUrl];
            if (!cimage) {
                cimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cstrUrl]]];
                [[DLCache sharedInstance] setObject:cimage forKey:cstrUrl];
            }
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                [cimageView setNeedsLayout];
                
            });
        });
    }
    accZoomableImageView.clablePageNumber.hidden = NO;
    accZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long) self.cpageControl.currentPage + 1, (unsigned long)self.cpageControl.numberOfPages];

}
-(void)didSwipeRight:(DLZoomableImageView*)accZoomableImageView {
   

//    NSLog(@"swipte right");
    NSUInteger iCurrentPage = [self.cpageControl currentPage];
    NSInteger iTempPage = -- iCurrentPage;
    if (iTempPage < 0 ) {
        return;
    }
    [self.cpageControl setCurrentPage:iTempPage];
    //scroll to page
    [self.cscrollviewImage scrollRectToVisible:CGRectMake(CGRectGetWidth(self.bounds) * iTempPage, 0.0f, CGRectGetWidth(self.cscrollviewImage.frame), CGRectGetHeight(self.cscrollviewImage.frame)) animated:NO];
    NSDictionary* cdicItem = [self.cmutarrImages objectAtIndex:iTempPage];
    NSString* cstrUrl = [cdicItem objectForKey:k_image_url];
    NSNumber* cnumberUrlType = [cdicItem objectForKey:k_image_url_type];
    __weak UIImageView* cimageView = accZoomableImageView.cimageViewContent;
    if ([cnumberUrlType intValue] == enum_scroll_view_image_url_app) {
        cimageView.image = [UIImage imageNamed:cstrUrl];
    }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_file) {
        cimageView.image = [UIImage imageWithContentsOfFile:cstrUrl];
        
    }else if ([cnumberUrlType intValue] == enum_scroll_view_image_url_network) {
        dispatch_async(_dispatch_queue_image, ^(void){        
            UIImage* cimage = [[DLCache sharedInstance] objectForKey:cstrUrl];
            if (!cimage) {
                cimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cstrUrl]]];
                [[DLCache sharedInstance] setObject:cimage forKey:cstrUrl];
            }
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                [cimageView setNeedsLayout];
                
            });
        });
    }
    accZoomableImageView.clablePageNumber.hidden = NO;
    accZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long) self.cpageControl.currentPage + 1, (unsigned long)self.cpageControl.numberOfPages];

}
-(void)actionEdit:(id)aidSender {
    UIButton* cbtn = (UIButton*)aidSender;
    cbtn.selected = !cbtn.selected;
    if (cbtn.selected) {
        [self showContentMenu];
    }else {
        [self hideContentMenu];
    }
}

-(void)setContentMenu:(NSMutableArray*)acMutarrMenus {
    [_c_mut_arr_content_menus removeAllObjects];
    _c_mut_arr_content_menus = nil;
    _c_mut_arr_content_menus = acMutarrMenus;
    for (UIView* cviewItem in _c_mut_arr_content_menus) {
        [self addSubview:cviewItem];
        cviewItem.hidden = YES;
        cviewItem.center = self.cbtnEdit.center;
    }
    [self bringSubviewToFront:self.cbtnEdit];
    
    if (!self.cDyAni) {
        self.cDyAni = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }

}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSValue* cvalue = [anim valueForKey:@"position_destination"];
    NSString* cstrAniName = [anim valueForKey:@"ani_name"];

    if (cvalue) {
        NSValue* cvalueObj = [anim valueForKey:@"obj"];
//        CGPoint spointPostion = [cvalue CGPointValue];

        UIView* cviewObj = (UIView*)[cvalueObj pointerValue];

        if ([cstrAniName  isEqualToString:@"ani_move_along_a_path"]) {


           
            
            UIAttachmentBehavior* cattachementBe = [[UIAttachmentBehavior alloc] initWithItem:cviewObj offsetFromCenter:UIOffsetMake(0.0f, 0.0f) attachedToAnchor:cviewObj.center];
            [cattachementBe setLength:12];
            [cattachementBe setFrequency:6];
            [cattachementBe setDamping:5];
            
            [self.cDyAni addBehavior:cattachementBe];
            
            
            UIDynamicItemBehavior* cdyItemBe = [[UIDynamicItemBehavior alloc] initWithItems:@[cviewObj]];
            cdyItemBe.elasticity = 0.8f;
            [self.cDyAni addBehavior:cdyItemBe];
            
           
            if (!self.cCollisionBe) {
                UIGravityBehavior* cgravityBe = [[UIGravityBehavior alloc] initWithItems:_c_mut_arr_content_menus];
                [self.cDyAni addBehavior:cgravityBe];
                self.cCollisionBe = [[UICollisionBehavior alloc] initWithItems:_c_mut_arr_content_menus];
                self.cCollisionBe.collisionMode =  UICollisionBehaviorModeBoundaries;
                [  self.cCollisionBe addBoundaryWithIdentifier:@"collision_boundary" fromPoint:CGPointMake(0.0f, CGRectGetHeight(self.bounds)) toPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
                self.cCollisionBe.translatesReferenceBoundsIntoBoundary = YES;
                [self.cDyAni addBehavior:  self.cCollisionBe];
            }


        }
    }
}

-(void)showContentMenu{
   
//    NSLog(@"show contnet menu  %@", NSStringFromCGRect(self.bounds));

    
    CFIndex iMenuCount = [_c_mut_arr_content_menus count];
    CGPoint sPointCenter = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, self.cbtnEdit.center.y);
    CGFloat fAngleOffset =  0.0f;
    CGFloat fRadius = CGRectGetWidth(self.bounds) * 0.5f  - (CGRectGetWidth(self.bounds) - CGRectGetMinX(self.cbtnEdit.frame));
   
    for (int i = 0 ; i < iMenuCount  ; i ++) {
        
        fAngleOffset =  -(M_PI / (CGFloat)iMenuCount) * (i + 1);
        UIView* cviewItem = [_c_mut_arr_content_menus objectAtIndex:i];
        cviewItem.hidden = NO;
//        CGPoint sPointTemp = CGPointMake(sPointCenter.x + fRadius * cosf(fAngleOffset) , sPointCenter.y - fRadius * sinf(fAngleOffset));
        
        CAKeyframeAnimation* ckeyframeAnimation = (CAKeyframeAnimation*)[cviewItem.layer animationForKey:@"ani_move_along_a_path"];
        if (!ckeyframeAnimation) {
            CGMutablePathRef rmutPath = CGPathCreateMutable();
            CGAffineTransform sAffineTrans = self.transform;

            CGPathMoveToPoint(rmutPath, &sAffineTrans, self.cbtnEdit.center.x, self.cbtnEdit.center.y);
            CGPathAddArc(rmutPath, &sAffineTrans, sPointCenter.x, sPointCenter.y, fRadius, 0, fAngleOffset, true);
            cviewItem.layer.position = CGPathGetCurrentPoint(rmutPath);
            ckeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            ckeyframeAnimation.path = rmutPath;
            ckeyframeAnimation.duration = 0.2f + i * 0.1f ;
            ckeyframeAnimation.autoreverses = NO;
            ckeyframeAnimation.removedOnCompletion = YES;
            [ckeyframeAnimation setValue:[NSValue valueWithPointer:(void*)cviewItem] forKey:@"obj"];
            [ckeyframeAnimation setValue:[NSValue valueWithCGPoint:CGPathGetCurrentPoint(rmutPath)] forKey:@"position_destination"];
            
            [ckeyframeAnimation setValue:@"ani_move_along_a_path" forKey:@"ani_name"];
            ckeyframeAnimation.delegate =self;
            
            CGPathRelease(rmutPath); rmutPath = NULL;

        }
        [cviewItem.layer addAnimation:ckeyframeAnimation forKey:@"ani_move_along_a_path"];
        
     


    }
    
}
-(void)hideContentMenu {
    CFIndex iMenuCount = [_c_mut_arr_content_menus count];
    CGPoint sPointCenter = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, self.cbtnEdit.center.y);
    CGFloat fAngleOffset =  0.0f;
    CGFloat fRadius = CGRectGetWidth(self.bounds) * 0.5f  - (CGRectGetWidth(self.bounds) - CGRectGetMidX(self.cbtnEdit.frame));
    
    NSArray* carrBehaviors = self.cDyAni.behaviors;
    /*
    for (UIDynamicBehavior* cdyBe  in [self.cDyAni behaviors]) {
        if ([cdyBe isKindOfClass:[UIAttachmentBehavior class]]) {
            [cmutarrAttachment addObject:cdyBe];
        }
    }*/
    for (UIDynamicBehavior* cdyBe in carrBehaviors) {
        [self.cDyAni removeBehavior:cdyBe];
    }
    self.cCollisionBe = nil;
    
    for (NSInteger i = 0 ; i < iMenuCount; i ++) {
        fAngleOffset = M_2_PI - (M_PI / (CGFloat)iMenuCount) *  (i + 1);
//        NSLog(@"angle offset %f", fAngleOffset);
        
        UIView* cviewItem = [_c_mut_arr_content_menus objectAtIndex: i];
        
        CAKeyframeAnimation* ckeyframeAnimation = (CAKeyframeAnimation*)[cviewItem.layer animationForKey:@"ani_move_along_a_path_disappear"];
        if (!ckeyframeAnimation) {
            CGMutablePathRef rcmutPath = CGPathCreateMutable();
            CGAffineTransform sAffineTrans = self.transform;
//            CGPathMoveToPoint(rcmutPath, &sAffineTrans, cviewItem.layer.position.x, cviewItem.layer.position.y);
            CGPathAddArc(rcmutPath, &sAffineTrans, sPointCenter.x
                         , sPointCenter.y, fRadius, fAngleOffset, (M_PI / (CGFloat)iMenuCount) , false);
            
            ckeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            ckeyframeAnimation.path = rcmutPath;
            cviewItem.layer.position = CGPathGetCurrentPoint(rcmutPath);
            ckeyframeAnimation.duration = .2f + i * 0.1f ;
            ckeyframeAnimation.removedOnCompletion = YES;
            ckeyframeAnimation.autoreverses = NO;
//            [ckeyframeAnimation setValue:[NSValue valueWithPointer:(void*)cviewItem] forKey:@"obj"];
//            [ckeyframeAnimation setValue:[NSValue valueWithCGPoint:CGPathGetCurrentPoint(rcmutPath)] forKey:@"position_destination"];

//            [ckeyframeAnimation setValue:@"ani_move_along_a_path_disappear" forKey:@"ani_name"];
//            ckeyframeAnimation.delegate = self;

            CGPathRelease(rcmutPath); rcmutPath = NULL;
        }
        [cviewItem.layer addAnimation:ckeyframeAnimation forKey:@"ani_move_along_a_path_disappear"];
        

    }
}

@end
