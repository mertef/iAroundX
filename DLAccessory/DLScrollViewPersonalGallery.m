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
        
        self.cbtnEdit.backgroundColor = [UIColor redColor];
        self.cbtnEdit.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60.0f, CGRectGetHeight(self.bounds) - 60.0f, 60.0f, 60.0f);
        [self.cscrollviewImage addSubview:self.cbtnEdit];
        [self.cbtnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    //    NSLog(@"%@", NSStringFromCGRect(self.cscrollviewImage.frame));

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.cbtnEdit.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60.0f + self.cscrollviewImage.contentOffset.x, CGRectGetHeight(self.bounds) - 60.0f, 60.0f, 60.0f);
    [self.cscrollviewImage bringSubviewToFront:self.cbtnEdit];
}
- (void)dealloc
{
}
-(void)feedImages:(NSMutableArray*)acmutArrImages {
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
    ccZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu", self.cpageControl.currentPage + 1, self.cpageControl.numberOfPages];
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
        
        self.cbtnEdit.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60.0f + self.cscrollviewImage.contentOffset.x, CGRectGetHeight(self.bounds) - 60.0f, 60.0f, 60.0f);
        [self.cscrollviewImage bringSubviewToFront:self.cbtnEdit];
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
    accZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu", self.cpageControl.currentPage + 1, self.cpageControl.numberOfPages];

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
    accZoomableImageView.clablePageNumber.text = [NSString stringWithFormat:@"%lu/%lu", self.cpageControl.currentPage + 1, self.cpageControl.numberOfPages];

}
-(void)actionEdit:(id)aidSender {
    [self showContentMenu];
}

-(void)setContentMenu:(NSMutableArray*)acMutarrMenus {
    [_c_mut_arr_content_menus removeAllObjects];
    _c_mut_arr_content_menus = nil;
    _c_mut_arr_content_menus = acMutarrMenus;
    for (UIView* cviewItem in _c_mut_arr_content_menus) {
        cviewItem.center = self.cbtnEdit.center;
        [self addSubview:cviewItem];
    }
}
-(void)showContentMenu{
    CGMutablePathRef rcmutPath = CGPathCreateMutable();
    CGPathMoveToPoint(rcmutPath, NULL, self.cbtnEdit.center.x, self.cbtnEdit.center.y);
    CFIndex iMenuCount = [_c_mut_arr_content_menus count];
//    CGPoint sPointLeft = CGPointMake(CGRectGetWidth(self.bounds) - self.cbtnEdit.center.x, self.cbtnEdit.center.y);
    CGPoint sPointCenter = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, self.cbtnEdit.center.y);
    CGPoint sPointRight = self.cbtnEdit.center;
    CGFloat fAngleOffset = 0.0f;
    NSLog(@"show contnet menu  %@", NSStringFromCGRect(self.bounds));
    CGFloat fRadius = CGRectGetHeight(self.bounds) - (CGRectGetHeight(self.bounds) - sPointCenter.y) - 10.0f;
  
    for (int i = 0 ; i < iMenuCount; i ++) {
        fAngleOffset += M_PI / iMenuCount;
        UIView* cviewItem = [_c_mut_arr_content_menus objectAtIndex:i];
        
        CGPoint sPointTemp = CGPointMake(sPointCenter.x + fRadius * cosf(fAngleOffset) , sPointCenter.y - fRadius * sinf(fAngleOffset));
        
        cviewItem.center = sPointTemp;
        /*
        CGPathAddArcToPoint(rcmutPath, NULL, sPointRight.x, sPointRight.y,sPointTemp.x, sPointTemp.y, fRadius);
        CAKeyframeAnimation* ckeyframeAnimation = (CAKeyframeAnimation*)[cviewItem.layer animationForKey:@"ani_move_along_a_path"];
        if (!ckeyframeAnimation) {
            ckeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            CGPathRef rpath = CGPathCreateCopy(rcmutPath);
            ckeyframeAnimation.path = rpath;
            CGPathRelease(rpath); rpath = NULL;
        }*/
//        [cviewItem.layer addAnimation:ckeyframeAnimation forKey:@"ani_move_along_a_path"];
    }
    
}
-(void)hideContentMenu {
    
}

@end
