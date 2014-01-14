//
//  DLScrollViewPersonalGallery.h
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLZoomableImageView.h"
@interface DLScrollViewPersonalGallery : UIView<UIScrollViewDelegate, ProtoZoomableImageView>
@property(strong, nonatomic) NSMutableArray* cmutarrImages;
@property(strong, nonatomic) UIScrollView* cscrollviewImage;
@property(strong, nonatomic) UIPageControl* cpageControl;
@property(strong, nonatomic) UIButton* cbtnEdit;
@property(strong, nonatomic) UIDynamicAnimator* cDyAni;
@property(strong, nonatomic) UICollisionBehavior* cCollisionBe;
-(void)feedImages:(NSMutableArray*)acmutArrImages;
-(void)actionEdit:(id)aidSender;
-(void)setContentMenu:(NSMutableArray*)acMutarrMenus;


@end
