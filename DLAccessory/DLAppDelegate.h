//
//  DLAppDelegate.h
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLMPViewCtrl;
@interface DLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController* cNaviCtrl;
@property(strong, nonatomic) DLMPViewCtrl* ccMpViewCtrl;
@property(strong, nonatomic) UIImageView* cimageviewBg;


@end
