//
//  DLAppDelegate.m
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLAppDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLMPViewCtrl.h"
#import "DLMCConfig.h"
#import "DLPerson.h"
#import "DLAudio.h"

#import "XHLoginViewController4.h"
#import "DLFolderViewViewCtrl.h"
@implementation DLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor clearColor];
//    [self testAudioView];
    
    
    _ccMpViewCtrl = [[DLMPViewCtrl alloc] init];
    UINavigationController* cCenterNavCt = [[UINavigationController alloc] init];
    
    cCenterNavCt.navigationBar.translucent = YES; // Setting this slides the view up, underneath the nav bar (otherwise it'll appear black)
    cCenterNavCt.navigationBar.tintColor = [UIColor whiteColor];
    
    [cCenterNavCt.navigationBar setBarStyle:UIBarStyleBlack];
    [cCenterNavCt pushViewController:_ccMpViewCtrl animated:YES];

    
//    XHLoginViewController4* ctLoginVc = [[XHLoginViewController4 alloc] init];
    
  //  DLFolderViewViewCtrl* ccFolderVc = [[DLFolderViewViewCtrl alloc] init];

//    IIViewDeckController* ctDeckVc = [[IIViewDeckController alloc] initWithCenterViewController: cCenterNavCt leftViewController:ccFolderVc rightViewController:ctLoginVc];
    self.window.rootViewController = cCenterNavCt;
    
    [self.window makeKeyAndVisible];
//    [self testAnchorView];
    /*
    */
//    [self testARC];
//    [self testExternalAccessory];
//    [self testBlock];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - test
-(void)testExternalAccessory{
    EAAccessoryManager* cAccessoryManger = [EAAccessoryManager sharedAccessoryManager];
    NSArray* carrConnectedAccessories = [cAccessoryManger connectedAccessories];
    for (EAAccessory* cAccessoryItem in carrConnectedAccessories) {
        NSLog(@"%@", [cAccessoryItem description]);
    }
}
-(void)testMultipeerConnectivity {
   
}
-(void)testARC{
    DLPerson* __strong cperson = [[DLPerson alloc] init];
    cperson.cstrName = @"mertef";
    cperson.cstrAddress = @"China, Chongqing";
    cperson.cstrTel = @"18696681549";
    NSLog(@"person:%@", [cperson description]);
    
}
-(void)testPredicate {
    NSDictionary* cdic0 = @{k_peer_id:@"joe0"};
    NSDictionary* cdic1 = @{k_peer_id:@"joe1"};
    NSDictionary* cdic2 = @{k_peer_id:@"joe2"};
    NSDictionary* cdic3 = @{k_peer_id:@"joe3"};
    NSDictionary* cdic4 = @{k_peer_id:@"joe4"};
    NSDictionary* cdic5 = @{k_peer_id:@"joe5"};
    NSArray* carrList = @[cdic0,cdic1,cdic2,cdic3,cdic4,cdic5];
    NSPredicate* cPredicate = [NSPredicate predicateWithFormat:@"(%K == %@)", k_peer_id, @"joe0"];
    NSArray* carrListFilter = [carrList filteredArrayUsingPredicate:cPredicate];
    if ([carrListFilter count] > 0) {
        NSLog(@"====%@", [carrListFilter description]);
    }
}
-(void)testAnchorView {
    UIView* cviewTest = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 60.0f)];
    cviewTest.center = CGPointMake(160.0f, 180.0f);
    [cviewTest setBackgroundColor:[UIColor cyanColor]];
    NSLog(@"before change the anchor point %@ and position is %@", NSStringFromCGRect(cviewTest.frame), NSStringFromCGPoint(cviewTest.layer.position));
   
    [self.window addSubview:cviewTest];
    cviewTest.layer.anchorPoint = CGPointMake(0.05f, 0.5f);
    NSLog(@"after change the anchor point %@ and position is %@", NSStringFromCGRect(cviewTest.frame), NSStringFromCGPoint(cviewTest.layer.position));

    /*
    [UIView animateWithDuration:3.0f animations:^(void){
        [self setAnchorPoint:CGPointMake(0.5f, .5f) forView:cviewTest];
        cviewTest.transform = CGAffineTransformMakeScale(10.0f, 10.0f);

    }];*/
}
-(void)testAudioView {
    DLAudio* ccAudio = [[DLAudio alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.window.bounds) * 0.7f, 60.0f)];
    [ccAudio startAnimation];
    [self.window addSubview:ccAudio];
}
-(void)testBlock {
    ^{
        NSLog(@"hello World!");
    }();
}
@end
