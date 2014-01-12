//
//  DLViewCtrlPersonalCenter.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLViewCtrlPersonalCenter.h"
#import "DLScrollViewPersonalGallery.h"
#import "DLMCConfig.h"

@interface DLViewCtrlPersonalCenter ()
-(void)addUIAvatar;
@end

@implementation DLViewCtrlPersonalCenter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    NSLog(@"view frame %@", NSStringFromCGRect(self.view.frame));

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.navigationController.navigationBarHidden = YES;
    
    self.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.tabBarController.tabBar.frame.size.height);

	// Do any additional setup after loading the view.
    self.ccScrollviewPG = [[DLScrollViewPersonalGallery alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.4f)];
    NSLog(@"--%@", NSStringFromCGRect(self.ccScrollviewPG.frame));
    //IMG_0414
    
    /*
    NSString* cstrUrl0 = @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=342e93312a381f309e198aa99d394c08/91529822720e0cf37dcbeff20846f21fbe09aaff.jpg";
    NSString* cstrUrl1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=66cf64bed358ccbf1bbcb23a2de0bc3e/fd039245d688d43f52855cfe7f1ed21b0ef43b8a.jpg";
    NSString* cstrUrl2 = @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=f7f5d40ba918972ba33a07cad2f57a89/b8014a90f603738d8e94e43db11bb051f919ecd7.jpg";

     
    NSArray* carrImagesNetwork = @[cstrUrl0, cstrUrl1, cstrUrl2];
     */
    NSMutableArray* cmutarrImages = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        
        NSDictionary* cdicItem  = nil;
        /*
        if (i <= 2) {
             cdicItem = @{k_image_url:carrImagesNetwork[i], k_image_url_type:@(enum_scroll_view_image_url_network)};
        }else {
             cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};

        }*/
        cdicItem = @{k_image_url:[NSString stringWithFormat:@"%i.jpg", i], k_image_url_type:@(enum_scroll_view_image_url_app)};
        [cmutarrImages addObject:cdicItem];
    }
    [self.ccScrollviewPG feedImages:cmutarrImages];
    [self.view addSubview:self.ccScrollviewPG];
    [self addUIAvatar];
}
-(void)addUIAvatar{
    self.cimageviewAvator = [[UIImageView alloc] initWithFrame: CGRectMake(4.0f, CGRectGetMaxY(self.ccScrollviewPG.frame) + 4.0f, 80.0f, 80.0f)];
    self.cimageviewAvator.contentMode = UIViewContentModeScaleAspectFill;
    self.cimageviewAvator.image = [UIImage imageNamed:@"10.jpg"];
    self.cimageviewAvator.backgroundColor = [UIColor clearColor];
    CAShapeLayer* cShaperLayer = [CAShapeLayer layer];
    CGMutablePathRef rmutPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(rmutPath, NULL, self.cimageviewAvator.bounds);
    cShaperLayer.path = rmutPath;
    CGPathRelease(rmutPath);rmutPath = NULL;
    self.cimageviewAvator.layer.mask = cShaperLayer;
    [self.view addSubview:self.cimageviewAvator];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
