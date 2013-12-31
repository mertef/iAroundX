//
//  DLAudio.h
//  DLAccessory
//
//  Created by Mertef on 12/18/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLAudio : UIView {
    BOOL _b_should_stop;
    NSTimer* _c_timer_update;
}
@property(strong, nonatomic) UIImageView* cimageviewBg, * cimageviewCenterNormal, * cimageviewCenterActive;
@property(assign,readwrite) float fProgress;
@property(assign, nonatomic) BOOL bIsAnimating;
-(void)startAnimation;
-(void)stopAnimation;
@end
