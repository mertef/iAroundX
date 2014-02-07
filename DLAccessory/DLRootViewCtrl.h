//
//  DLRootViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 2/7/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface DLRootViewCtrl : UIViewController<ADBannerViewDelegate>
@property(strong, nonatomic) ADBannerView* cBannerView;
@property(strong, nonatomic) UIView* cviewContent;
-(void)addUIAdvertisementBanner;
-(void)initLayouConfig;
@end
