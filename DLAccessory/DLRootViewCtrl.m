//
//  DLRootViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 2/7/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLRootViewCtrl.h"

#import "DLMCConfig.h"

@interface DLRootViewCtrl ()

@end

@implementation DLRootViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect srectBanner = self.cBannerView.frame;
    srectBanner.origin.y = CGRectGetMaxY(self.cviewContent.frame);
    self.cBannerView.frame = srectBanner;
   
}
-(void)initLayouConfig {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initLayouConfig];
    [self addUIAdvertisementBanner];
    CGRect srectFrame = CGRectZero;
    CGFloat fHeight = CGRectGetHeight(self.view.frame);
    CGFloat fYOffset = 0.0f;
    if(!self.prefersStatusBarHidden){
        fHeight -= 20.0f;
    }
    if (self.navigationController && !self.navigationController.navigationBarHidden ) {
        fHeight -= CGRectGetHeight(self.navigationController.navigationBar.frame);
    }
    if (( self.edgesForExtendedLayout == UIRectEdgeTop || self.edgesForExtendedLayout == UIRectEdgeAll)) {
        fYOffset += CGRectGetHeight(self.navigationController.navigationBar.frame);
        fYOffset += 20.0f;
    }
    if (self.tabBarController && !self.tabBarController.tabBar.hidden ) {
        fHeight -= CGRectGetHeight(self.tabBarController.tabBar.frame);
    }
    
//    if ((self.edgesForExtendedLayout  == UIRectEdgeBottom  || self.edgesForExtendedLayout  == UIRectEdgeAll  )) {
//        fYOffset += CGRectGetHeight(self.navigationController.navigationBar.frame);
//    }
    
    if (self.cBannerView) {
        fHeight -= 50.0f;
    }

#if TARGET_IPHONE_SIMULATOR
    //Simulator
    srectFrame = CGRectMake(0.0f, fYOffset, CGRectGetWidth(self.view.frame), fHeight);
#else
    // Device
    srectFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), fHeight);
#endif
 
//    srectFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), fHeight);

    self.cviewContent = [[UIView alloc] initWithFrame:srectFrame];
    self.cviewContent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cviewContent];
   
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addUIAdvertisementBanner {
    NSNumber* cnumberSupportAds = [[NSUserDefaults standardUserDefaults] objectForKey:k_no_ads];
    if (!cnumberSupportAds && ![cnumberSupportAds boolValue]) {
       self.cBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
       [self.view addSubview:self.cBannerView];
        self.cBannerView.backgroundColor = [UIColor whiteColor];
        self.cBannerView.delegate = self;
    }
}

@end
