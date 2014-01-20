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

#import "DLFolderViewViewCtrl.h"
#import "DLConversationListTableViewCtrl.h"
#import "DLNavigationCtrl.h"
#import "DLTabbarViewCtr.h"
#import "DLFolderViewViewCtrl.h"
#import "DLLoginViewCtrl.h"
#import "DLViewCtrlPersonalCenter.h"


@implementation DLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _ccMpViewCtrl = [[DLMPViewCtrl alloc] init];
    
    UINavigationController* cCenterNavCt = [[DLNavigationCtrl alloc] init];
    [cCenterNavCt pushViewController:_ccMpViewCtrl animated:YES];

    self.ccTableViewCtrlConverstaion = [[DLConversationListTableViewCtrl alloc] init];
    UINavigationController* ccConversationNavCtrl = [[DLNavigationCtrl alloc] init];
    [ccConversationNavCtrl pushViewController:_ccTableViewCtrlConverstaion animated:YES];
    
    self.ctabbarItemConverstaion = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"k_conversation", nil) image:[[UIImage imageNamed:@"msg_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"msg_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ccConversationNavCtrl.tabBarItem = self.ctabbarItemConverstaion;
    
    DLFolderViewViewCtrl* ccFolderViewCtrl = [[DLFolderViewViewCtrl alloc] init];
    UINavigationController* ccNavCtrlFolder = [[DLNavigationCtrl alloc] initWithRootViewController:ccFolderViewCtrl];
     UITabBarItem* cTabbarItemFolder = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"k_folder", nil) image:[[UIImage imageNamed:@"tabbar_bottom_folder_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_bottom_folder_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ccNavCtrlFolder.tabBarItem = cTabbarItemFolder;


    DLViewCtrlPersonalCenter* ccSettingCtrl = [[DLViewCtrlPersonalCenter alloc] init];
    UINavigationController* ccNaviCtrlSetting = [[DLNavigationCtrl alloc] initWithRootViewController:ccSettingCtrl];
     UITabBarItem* cTabbarItemSetting = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"k_setting", nil) image:[[UIImage imageNamed:@"tabbar_setting_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_setting_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ccSettingCtrl.tabBarItem = cTabbarItemSetting;
    
    
    UITabBarController* cTabbarViewCtrl = [[DLTabbarViewCtr alloc] init];
    cTabbarViewCtrl.viewControllers = @[ccNavCtrlFolder, cCenterNavCt, ccConversationNavCtrl, ccNaviCtrlSetting];
    cTabbarViewCtrl.selectedViewController = cCenterNavCt;
    self.window.rootViewController = cTabbarViewCtrl;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotiMsgReceive:) name:k_noti_chat_msg_decrease object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotiMsgReceive:) name:k_noti_chat_msg_increase object:nil];
    
    [self.window makeKeyAndVisible];

    //[self testFilterNumber];
    return YES;
}
-(void)actionNotiMsgReceive:(NSNotification*)acNoti {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (!self.ccTableViewCtrlConverstaion.cSession){
            self.ccTableViewCtrlConverstaion.cSession = self.ccMpViewCtrl.csession;
            self.ccTableViewCtrlConverstaion.cpeerIdFrom = self.ccMpViewCtrl.cpeerId;
        }
        if ([acNoti.name isEqualToString:k_noti_chat_msg_increase]) {
            if (!self.ctabbarItemConverstaion.badgeValue) {
                self.ctabbarItemConverstaion.badgeValue = @"1";
            }else {
                self.ctabbarItemConverstaion.badgeValue = [NSString stringWithFormat:@"%d", [self.ctabbarItemConverstaion.badgeValue intValue] + 1];
            }
        }else if([acNoti.name isEqualToString:k_noti_chat_msg_decrease]){
            NSNumber* cnumberValue = [[acNoti userInfo] objectForKey:k_msg_cout];
            NSUInteger iNumberMsgCount = [self.ctabbarItemConverstaion.badgeValue integerValue] - [cnumberValue integerValue];
            if (!iNumberMsgCount) {
                self.ctabbarItemConverstaion.badgeValue = nil;
            }else {
               self.ctabbarItemConverstaion.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)iNumberMsgCount];
            }
        }
        

    });
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
typedef struct{
    u_long _u_l_0;
    u_long _u_l_1;
}T_X;
-(void)testByte {
    
    T_X tt;
    tt._u_l_0 = 100;
    tt._u_l_1 = 1000;
    printf("raw_data has %lu elements\n", sizeof(tt)/sizeof(u_long));
    NSString* cstrX = @"Hello World";
    
    NSData *data = [NSData dataWithBytes:&tt length:sizeof(tt)];
    printf("data has %ld bytes\n", (u_long)[data length]);
    NSMutableData* cmutData = [NSMutableData data];
    [cmutData appendData:data];
    [cmutData appendData:[cstrX dataUsingEncoding:NSUTF8StringEncoding]];
    T_X* ptx = malloc(sizeof(T_X));
    [data getBytes:ptx length:sizeof(T_X)];
    NSLog(@"x0 is %ld  %ld", ptx->_u_l_0, ptx->_u_l_1);
    NSData* cdataString = [cmutData subdataWithRange:NSMakeRange(sizeof(T_X), [[cstrX dataUsingEncoding:NSUTF8StringEncoding] length])];
    NSString* cstrTest = [[NSString alloc] initWithData:cdataString encoding:NSUTF8StringEncoding];
    NSLog(@"====%@", cstrTest);
}
-(void)testFilterNumber{
    NSMutableArray* cmutArrNumber = [[NSMutableArray alloc ] init];
    for (int i = 0; i < 60; i ++) {
        NSDictionary* cdicNumber = @{k_chat_msg_id:@(i)};
        [cmutArrNumber addObject:cdicNumber];
    }
    NSPredicate* cPredicateFilter = [NSPredicate predicateWithFormat:@"(%K == %d)", k_chat_msg_id, 13];
    NSArray* carrList = [cmutArrNumber filteredArrayUsingPredicate:cPredicateFilter];
    if (carrList && [carrList count] > 0) {
        NSLog(@"----%@", [carrList description]);
    }
   
    
}


@end
