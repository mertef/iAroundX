//
//  DLMPViewCtrl.m
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLMPViewCtrl.h"
#import "DLMCConfig.h"
#import "DLItemTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DLTableCellPopoutView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PulsingHaloLayer.h"
#import "DLFolderViewViewCtrl.h"
#import "DLFolderViewViewCtrl.h"
#import "DLChatTableViewCtrl.h"
#import "MBProgressHUD.h"
#import "DLModel.h"
@interface DLMPViewCtrl ()
-(void)removeFromRemotePeerId:(MCPeerID*)acRemotePeerId;
-(MCSession*)addToRemotePeerId:(MCPeerID*)acRemotePeerId;
-(MCSession*)findRemoteSession:(MCPeerID*)acRemotePeerId;
-(void)restartScanning;
@end

@implementation DLMPViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cmutarrRemtoePeerIdsConnected = [[NSMutableArray alloc] init];

        // Custom initialization
        NSString* cstrUserName = [[NSUserDefaults standardUserDefaults] objectForKey:k_peer_user_name];
        if (!cstrUserName) {
            cstrUserName = [[UIDevice currentDevice] name];
            [[NSUserDefaults standardUserDefaults] setObject:cstrUserName forKey:k_peer_user_name];
            
        }        
       _cpeerId = [[MCPeerID alloc] initWithDisplayName:cstrUserName];
//       _csession= [[MCSession alloc] initWithPeer:_cpeerId];
//       _csession.delegate =self;
        
        self.cmutarrRemoteSessions = [[NSMutableArray alloc] init];


        _cnearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_cpeerId discoveryInfo:nil serviceType:k_service_type];
        _cnearbyServiceAdvertiser.delegate = self;
        
        
        _cnearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_cpeerId serviceType:k_service_type];
        _cnearbyServiceBrowser.delegate = self;

        
        // progress gradient, red, animated

                      
        self.cmutdicPeerMap = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}


-(MCSession*)addToRemotePeerId:(MCPeerID*)acRemotePeerId{
    
    NSString* cstrRightPeerId = acRemotePeerId.displayName;
    BOOL bFag = YES;
    MCSession* csession = nil;
    for (NSMutableDictionary* cmutdicItem in self.cmutarrRemoteSessions) {
        if ([[cmutdicItem objectForKey:k_session_right_peer_id] isEqualToString:cstrRightPeerId]) {
            bFag = NO;
            csession = [cmutdicItem objectForKey:k_session];
            break;
        }
        
    }
    if (bFag) {
        NSMutableDictionary* cmutdic = [[NSMutableDictionary alloc] init];
        csession = [[MCSession alloc] initWithPeer:self.cpeerId];
        csession.delegate = self;
        [cmutdic setObject:csession forKey:k_session];
        [cmutdic setObject:cstrRightPeerId forKey:k_session_right_peer_id];
        [self.cmutarrRemoteSessions addObject:cmutdic];
    }
    return csession;
}

-(void)removeFromRemotePeerId:(MCPeerID*)acRemotePeerId {
    NSString* cstrRightPeerId = acRemotePeerId.displayName;
    NSDictionary* cdicItemFound = nil;
    for (NSMutableDictionary* cmutdicItem in self.cmutarrRemoteSessions) {
        if ([[cmutdicItem objectForKey:k_session_right_peer_id] isEqualToString:cstrRightPeerId]) {
            cdicItemFound = cmutdicItem;
            break;
        }
    }
    if (cdicItemFound) {
        [self.cmutarrRemoteSessions removeObject:cdicItemFound];
    }
}

-(MCSession*)findRemoteSession:(MCPeerID*)acRemotePeerId {
    NSString* cstrRightPeerId = acRemotePeerId.displayName;

    MCSession* csession = nil;
    for (NSMutableDictionary* cmutdicItem in self.cmutarrRemoteSessions) {
        if ([[cmutdicItem objectForKey:k_session_right_peer_id] isEqualToString:cstrRightPeerId]) {
            csession = [cmutdicItem objectForKey:k_session];
            break;
        }
        
    }
    return csession;
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
-(void)addUIAdvertisementBanner {
    [super addUIAdvertisementBanner];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
        
    
    
    self.cTableServiceList = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.cviewContent.frame)) style:UITableViewStylePlain];
    [self.cviewContent addSubview:_cTableServiceList];
    [_cTableServiceList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:id_table_header];

//    [_cTableServiceList registerClass:[UIView class] forHeaderFooterViewReuseIdentifier:id_table_footer];

    
    _cTableServiceList.delegate = self;
    _cTableServiceList.dataSource = self;
    
    self.cviewTableHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 68.0f)];
    _cTableServiceList.tableHeaderView = self.cviewTableHeader;

    _cTableServiceList.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 2.0f)];
    _cTableServiceList.tableFooterView.backgroundColor = [UIColor whiteColor];
    /*
    UIImage* cimageScan0 = [UIImage imageNamed:@"scan_0"];

    
    self.cimageViewBtnScan = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.cviewTableHeader.frame) - cimageScan0.size.width) * 0.5f, (CGRectGetHeight(self.cviewTableHeader.frame) - cimageScan0.size.height) * 0.5f, cimageScan0.size.width, cimageScan0.size.height)];
    self.cimageViewBtnScan.image = cimageScan0;
    self.cimageViewBtnScan.contentMode = UIViewContentModeScaleAspectFit;
    self.cimageViewBtnScan.animationImages = @[cimageScan0, [UIImage imageNamed:@"scan_1"],[UIImage imageNamed:@"scan_2"],[UIImage imageNamed:@"scan_3"]];
    
//    UITapGestureRecognizer* ctapScan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionStartBrowserNearbyUsers:)];
//    [self.cimageViewBtnScan addGestureRecognizer:ctapScan];
//    self.cimageViewBtnScan.userInteractionEnabled = YES;
    
    self.cimageViewBtnScan.animationDuration = 1.0f;
    
    [self.cviewTableHeader addSubview:self.cimageViewBtnScan];
     */
    UIImage* cimageScan0 = [UIImage imageNamed:@"os"];
    self.cimageViewBtnScan = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.cviewTableHeader.frame) - cimageScan0.size.width) * 0.5f, (CGRectGetHeight(self.cviewTableHeader.frame) - cimageScan0.size.height) * 0.5f, cimageScan0.size.width, cimageScan0.size.height)];
    self.cimageViewBtnScan.image = cimageScan0;
    
    _ctHaloLayer = [PulsingHaloLayer layer];
    _ctHaloLayer.radius = 40.0f;
//    _ctHaloLayer.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    _ctHaloLayer.position = self.cviewTableHeader.center;
    [self.cviewTableHeader.layer addSublayer:_ctHaloLayer];
/*
    _cbtnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* cimage = [UIImage imageNamed:@"people"];
    [_cbtnLogin setImage:cimage forState:UIControlStateNormal];
    _cbtnLogin.frame = CGRectMake(CGRectGetWidth(self.cviewTableHeader.frame) - 10.0f - cimage.size.width, (CGRectGetHeight(self.cviewTableHeader.frame) - cimage.size.height) * 0.5f, cimage.size.width, cimage.size.height);
    [_cbtnLogin addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.cviewTableHeader addSubview:_cbtnLogin];
    
    _cbtnFolder = [UIButton buttonWithType:UIButtonTypeCustom];
*/
    [self.cviewTableHeader addSubview:self.cimageViewBtnScan];
    UIImage* cimageFolder = [UIImage imageNamed:@"folder"];
    [_cbtnFolder setImage:cimageFolder forState:UIControlStateNormal];
    _cbtnFolder.frame = CGRectMake(10.0f, (CGRectGetHeight(self.cviewTableHeader.frame) - cimageFolder.size.height) * 0.5f, cimageFolder.size.width, cimageFolder.size.height);
    [_cbtnFolder addTarget:self action:@selector(actionShowFolderManager:) forControlEvents:UIControlEventTouchUpInside];

    [self.cviewTableHeader addSubview:_cbtnFolder];
    

    
    self.ctProgressHud = [[MBProgressHUD alloc] initWithView:self.view];
   CGSize sSizeHud =  [self.ctProgressHud sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame) * 0.6f, 200.0f)];
    self.ctProgressHud.frame = CGRectMake((CGRectGetWidth(self.view.frame) - sSizeHud.width) * 0.5f, 180.0f, sSizeHud.width, sSizeHud.height);
    
    self.ctProgressHud.mode = MBProgressHUDModeAnnularDeterminate;
    self.ctProgressHud.animationType = MBProgressHUDAnimationZoomIn;
    self.ctProgressHud.removeFromSuperViewOnHide = YES;
    self.ctProgressHud.tag = k_tag_progress_view;
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"k_send_file_tile", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(actionStartBrowserNearbyUsers:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(actionDismissServiceBrowser:)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
//    UISwipeGestureRecognizer* cSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe:)];
//    [self.view addGestureRecognizer:cSwipeGes];
    

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setNeedsDisplay];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)dealloc
{
    
    for (NSDictionary* cdicItem in self.cmutarrRemoteSessions) {
        MCSession* csession = [cdicItem objectForKey:k_session];
        [csession disconnect];
    }
    [self.cmutarrRemoteSessions removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self actionDismissServiceBrowser:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)actionStartBrowserNearbyUsers:(id)aidSender {
//    [self.cimageViewBtnScan startAnimating];
    [_ctHaloLayer startAnimation];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [_cnearbyServiceAdvertiser startAdvertisingPeer];
    [_cnearbyServiceBrowser startBrowsingForPeers];
    [aidSender setEnabled:NO];

}
-(void)actionDismissServiceBrowser:(id)aidsender {
    
//    [self.cimageViewBtnScan stopAnimating];
    [_ctHaloLayer stopAnimation];

    [_cnearbyServiceAdvertiser stopAdvertisingPeer];
    [_cnearbyServiceBrowser stopBrowsingForPeers];

    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    self.navigationItem.leftBarButtonItem.enabled = NO;

}


- (void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"encodeRestorableStateWithCoder");
    [super encodeRestorableStateWithCoder:coder];
}
- (void) decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"decodeRestorableStateWithCoder");
    [super decodeRestorableStateWithCoder:coder];
}
- (void) applicationFinishedRestoringState {
    NSLog(@"applicationFinishedRestoringState");
    [super applicationFinishedRestoringState];
}


#pragma mark - session callback 
// Remote peer changed state
-(void)restartScanning {
    [self.cnearbyServiceAdvertiser stopAdvertisingPeer];
    [self.cnearbyServiceBrowser stopBrowsingForPeers];
    
    [self.cnearbyServiceAdvertiser startAdvertisingPeer];
    [self.cnearbyServiceBrowser startBrowsingForPeers];
}
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSLog(@"sesion did change state %d", [@(state) intValue]);
    NSPredicate* cprediate = [NSPredicate predicateWithFormat:@"(%K == %@)" , k_peer_id_name, [peerID displayName]];
    NSArray* carrList = [self.cmutarrRemtoePeerIdsConnected filteredArrayUsingPredicate:cprediate];
    
    if (state == MCSessionStateConnected) {
        if ([carrList count] == 0 ) {
            [self.cmutarrRemtoePeerIdsConnected addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:peerID,k_peer_id,[peerID displayName],k_peer_id_name, @(enum_peer_status_connected), k_peer_status, nil]];
           
        }else {
            NSMutableDictionary* cmutdicItem = (NSMutableDictionary*)[carrList firstObject];
            [cmutdicItem setObject:@(enum_peer_status_connected) forKey:k_peer_status];
        }
    }else if(state == MCSessionStateNotConnected){
        if ([carrList count] > 0) {
            NSMutableDictionary* cmutdicItem = (NSMutableDictionary*)[carrList firstObject];
            [cmutdicItem setObject:@(enum_peer_status_not_connected) forKey:k_peer_status];
        }
        
    }else if(state == MCSessionStateConnecting) {
        if ([carrList count] > 0) {
            NSMutableDictionary* cmutdicItem = (NSMutableDictionary*)[carrList firstObject];
            [cmutdicItem setObject:@(enum_peer_status_connecting) forKey:k_peer_status];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.cTableServiceList reloadData];
    });

}

-(void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
   if (certificateHandler != nil) { certificateHandler(YES); }
}
// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
//    NSLog(@"did receive data data lenght is %lu  package header %lu", (u_long)[data length], sizeof(T_PACKAGE_HEADER));
    
    /*
     "k_receiving_video_begin" = "Receiving video file begin!";
     "k_receiving_video_end" = "Receiving video Finished!";
     
     "k_receiving_image_begin" = "Receiving image file begin!";
     "k_receiving_image_end" = "Receiving image Finished!";
     
     "k_receiving_file_size" = "Size:";
     */
    NSMutableData* cmutdata = [self.cmutdicPeerMap objectForKey:[peerID displayName]];
    

    
    
    u_long ulPackageHeaderSize = (u_long)sizeof(T_PACKAGE_HEADER);
    if ([data length] < ulPackageHeaderSize) {
        return;
    }

    T_PACKAGE_HEADER* puPackage = malloc(sizeof(T_PACKAGE_HEADER));
     NSData* cdataHeader = [data subdataWithRange:NSMakeRange(0, sizeof(T_PACKAGE_HEADER))];
    [cdataHeader getBytes:puPackage];
    
    
    if (puPackage->_u_l_package_type == enum_package_type_short_msg ||
        
        puPackage->_u_l_package_type == enum_package_type_audio ||
        puPackage->_u_l_package_type == enum_package_type_video ||
        puPackage->_u_l_package_type == enum_package_type_image ||
        puPackage->_u_l_package_type == enum_package_type_music
        ) {
        NSData* cdataMsg = [data subdataWithRange:NSMakeRange(sizeof(T_PACKAGE_HEADER), puPackage->_u_l_package_length)];
        NSLog(@"finisehd is %d", puPackage->_i8_msg_finished);
        if (!cmutdata) {
            cmutdata = [[NSMutableData alloc] init];
            [cmutdata setLength:0];
            [self.cmutdicPeerMap setObject:cmutdata forKey:[peerID displayName]];
            NSDictionary* cdicChatItem = @{k_chat_from:peerID,
                                           k_chat_to:self.cpeerId,
                                           k_chat_msg_type:@(puPackage->_u_l_package_type),
                                           k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                           k_chat_msg_id:@(puPackage->_u_l_msg_id),
                                           k_chat_msg_finished:@(puPackage->_i8_msg_finished)
                                           };
            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_increase object:nil userInfo:cdicChatItem];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg object:nil userInfo:cdicChatItem];
        }
        

       
        
//        NSLog(@"data size is %lu", (unsigned long)[cdataMsg length]);
        NSLog(@"msg id is %d", puPackage->_u_l_msg_id);
        [cmutdata appendData:cdataMsg];
        
        NSDictionary* cdicChatItemProgress = @{k_chat_from:peerID,
                                               k_chat_to:self.cpeerId,
                                               k_chat_msg_type:@(puPackage->_u_l_package_type),
                                               k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                               k_chat_msg_id:@(puPackage->_u_l_msg_id),
                                               k_chat_msg_size:@(puPackage->_u_l_package_size),
                                               k_chat_msg_current_size:@([cmutdata length]),
                                               k_chat_msg_finished:@(puPackage->_i8_msg_finished)

                                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_receive_progress object:nil userInfo:cdicChatItemProgress];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (puPackage->_u_l_package_type == enum_package_type_video || puPackage->_u_l_package_type == enum_package_type_image){
            if (![self.view viewWithTag:k_tag_progress_view]) {
                [self.view addSubview:self.ctProgressHud];
                [self.ctProgressHud show:YES];
                self.ctProgressHud.progress = 0.0f;
                self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_video_begin", nil);
                [self.view bringSubviewToFront:self.ctProgressHud];
            }
        }
        
    });
    
    if (puPackage->_u_l_package_type == enum_package_type_video){
       CGFloat fProgress = [cmutdata length] / (CGFloat)puPackage->_u_l_package_size;
       self.ctProgressHud.progress = fProgress;
        CGFloat fSize = (CGFloat)puPackage->_u_l_package_size / (CGFloat)(1024.0  * 1024.0f);
        self.ctProgressHud.labelText = [NSString stringWithFormat:@"%@:%0.2f%%",NSLocalizedString(@"k_receiving_video_begin", nil), fProgress * 100.0f];

        self.ctProgressHud.detailsLabelText = [NSString stringWithFormat:@"%@ %0.2fM", NSLocalizedString(@"k_receiving_file_size", nil), fSize];
        
    }else if (puPackage->_u_l_package_type == enum_package_type_image){
        CGFloat fProgress = [cmutdata length] / (CGFloat)puPackage->_u_l_package_size;
        self.ctProgressHud.progress = fProgress;
        CGFloat fSize = (CGFloat)puPackage->_u_l_package_size / (CGFloat)(1024.0  * 1024.0f);
        self.ctProgressHud.labelText = [NSString stringWithFormat:@"%@:%0.2f%%",NSLocalizedString(@"k_receiving_video_begin", nil), fProgress * 100.0f];
        self.ctProgressHud.detailsLabelText = [NSString stringWithFormat:@"%@ %0.2fM", NSLocalizedString(@"k_receiving_file_size", nil), fSize];
    }else if (puPackage->_u_l_package_type == enum_package_type_music){
        CGFloat fProgress = [cmutdata length] / (CGFloat)puPackage->_u_l_package_size;
        self.ctProgressHud.progress = fProgress;
        CGFloat fSize = (CGFloat)puPackage->_u_l_package_size / (CGFloat)(1024.0  * 1024.0f);
        self.ctProgressHud.labelText = [NSString stringWithFormat:@"%@:%0.2f%%",NSLocalizedString(@"k_receiving_music_begin", nil), fProgress * 100.0f];
        self.ctProgressHud.detailsLabelText = [NSString stringWithFormat:@"%@ %0.2fM", NSLocalizedString(@"k_receiving_file_size", nil), fSize];
    }

    
    if (puPackage->_u_l_package_size == (puPackage->_u_l_package_length + puPackage->_u_l_current_offset)) {
        
        NSMutableData* cmutData = [[NSMutableData alloc] initWithData:cmutdata];
        NSString* cstrMediaUrl = @"";
        NSTimeInterval tTime = [[NSDate date] timeIntervalSince1970];
        long lTime = round(tTime);
        if (puPackage->_u_l_package_type == enum_package_type_short_msg) {
            NSString* cstrMsg = [[NSString alloc] initWithData:cmutdata  encoding:NSUTF8StringEncoding];
            NSLog(@"received short msg from %@ : %@", [peerID displayName], cstrMsg);
        }else if(puPackage->_u_l_package_type == enum_package_type_image) {
            NSLog(@"received image from %@ ", [peerID displayName]);
            cstrMediaUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%ld.jpg", lTime];
            NSLog(@"----%@", cstrMediaUrl);
            [cmutData writeToFile:cstrMediaUrl atomically:NO];
        }else if(puPackage->_u_l_package_type == enum_package_type_video) {
            
            NSLog(@"received video msg from %@ ", [peerID displayName]);
            cstrMediaUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%ld.mov", lTime];
            [cmutData writeToFile:cstrMediaUrl atomically:NO];
            NSLog(@"----%@", cstrMediaUrl);
        }else if(puPackage->_u_l_package_type == enum_package_type_audio) {
            
            NSLog(@"received video audio from %@ ", [peerID displayName]);
            cstrMediaUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%ld.aac", lTime];
            [cmutData writeToFile:cstrMediaUrl atomically:NO];
            NSLog(@"----%@", cstrMediaUrl);
        }else if(puPackage->_u_l_package_type == enum_package_type_music) {
            
            NSLog(@"received video music from %@ ", [peerID displayName]);
            cstrMediaUrl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%ld.mp3", lTime];
            [cmutData writeToFile:cstrMediaUrl atomically:NO];
            NSLog(@"----%@", cstrMediaUrl);
        }
        
        NSDictionary* cdicChatItem = @{k_chat_from:peerID,
                                       k_chat_to:self.cpeerId,
                                       k_chat_msg:cmutData,
                                       k_chat_msg_type:@(puPackage->_u_l_package_type),
                                       k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                       k_chat_msg_media_url:cstrMediaUrl,
                                       k_chat_msg_id:@(puPackage->_u_l_msg_id),
                                       k_chat_msg_finished:@(puPackage->_i8_msg_finished)
                                       };
        [DLModel SaveMsgItem:cdicChatItem];
//        [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_increase object:nil userInfo:cdicChatItem];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg object:nil userInfo:cdicChatItem];

        
        [cmutdata setLength:0];
        [self.cmutdicPeerMap removeObjectForKey:[peerID displayName]];
        if ([self.view viewWithTag:k_tag_progress_view]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (puPackage->_u_l_package_type == enum_package_type_video){
                    self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_video_end", nil);

                }else if(puPackage->_u_l_package_type == enum_package_type_image) {
                    self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_image_end", nil);

                }else if(puPackage->_u_l_package_type == enum_package_type_music) {
                    self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_music_end", nil);
                    
                }
                [self.ctProgressHud hide:YES afterDelay:1.0f];
            });
        }
        
    }
    free(puPackage);puPackage = NULL;

}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@"didReceiveStream");
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
    NSLog(@"didStartReceivingResourceWithName %@", resourceName);

   
    NSMutableData* cmutdata = [self.cmutdicPeerMap objectForKey:[peerID displayName]];
    if (!cmutdata) {
        [self.cmutdicPeerMap setObject:[NSMutableData data] forKey:[peerID displayName]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (![self.view viewWithTag:k_tag_progress_view]) {
            [self.view addSubview:self.ctProgressHud];
        }
        self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_file", nil);
        [self.view bringSubviewToFront:self.ctProgressHud];
        [self.ctProgressHud show:YES];
    });
    [cmutdata setLength:0];
    
    self.cpeerIdCurrent = peerID;
    
    self.cprogressCurrentReceiver = progress;
    [self.cprogressCurrentReceiver addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"keypath is : %@", keyPath);
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSNumber* cnumberFractionCompleted = [change objectForKey:NSKeyValueChangeNewKey];
//        NSLog(@"%f`", [cnumberFractionCompleted doubleValue]);
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.ctProgressHud.progress = [cnumberFractionCompleted doubleValue];
            self.ctProgressHud.detailsLabelText = [NSString stringWithFormat:@"%.2f%%", [cnumberFractionCompleted doubleValue] * 100.0f];
        });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}


// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
    u_int32_t uiMsgId = [[NSDate date] timeIntervalSince1970];
    
    NSMutableData* cmutdata = [self.cmutdicPeerMap objectForKey:[peerID displayName]];

    if ([self.view viewWithTag:k_tag_progress_view]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.ctProgressHud.labelText = NSLocalizedString(@"k_receiving_file_finished", nil);
            [self.ctProgressHud hide:YES];
        });
    }
    if (error) {
        [cmutdata setLength:0];
        NSLog(@"receive error %@", [error description]);
    }else{ //save file
        [cmutdata appendData:[[NSData alloc] initWithContentsOfURL:localURL]];
        NSString* cstrHome = NSHomeDirectory();
        NSString* cstrMediaUrl = [cstrHome stringByAppendingFormat:@"/Documents/%@", resourceName];
        NSError* cError = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:cstrMediaUrl]) {
            [[NSFileManager defaultManager] removeItemAtPath:cstrMediaUrl error:&cError];
           
        }
        if (cError) {
            NSLog(@"can't delete the file, file exists!");
        }else {
            [cmutdata  writeToFile:cstrMediaUrl atomically:YES];
        }
        NSDictionary* cdicChatItem = nil;
        if ([resourceName hasSuffix:k_file_type_video]) {
           cdicChatItem = @{
                            k_chat_msg_id:@(uiMsgId),
                            k_chat_from:peerID,
                                           k_chat_to:self.cpeerId,
                                           k_chat_msg:cmutdata,
                                           k_chat_msg_type:@(enum_package_type_video),
                                           k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                           k_chat_msg_media_url:cstrMediaUrl,
                                           k_chat_msg_finished:@(1)

                                           };
        }else if([resourceName hasSuffix:k_file_type_image]) {
             cdicChatItem = @{
                              k_chat_msg_id:@(uiMsgId),
                              k_chat_from:peerID,
                                           k_chat_to:self.cpeerId,
                                           k_chat_msg:cmutdata,
                                           k_chat_msg_type:@(enum_package_type_image),
                                           k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                           k_chat_msg_media_url:cstrMediaUrl,
                                           k_chat_msg_finished:@(1)

                                           };
        }else {
            cdicChatItem = @{
                             k_chat_msg_id:@(uiMsgId),
                             k_chat_from:peerID,
                                           k_chat_to:self.cpeerId,
                                           k_chat_msg:cmutdata,
                                           k_chat_msg_type:@(enum_package_type_other),
                                           k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                                           k_chat_msg_media_url:cstrMediaUrl,
                                           k_chat_msg_finished:@(1)
                                           };
        }
        
        [DLModel SaveMsgItem:cdicChatItem];

        [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_increase object:nil userInfo:cdicChatItem];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg object:nil userInfo:cdicChatItem];
        [self.cmutdicPeerMap removeObjectForKey:[peerID displayName]];

        
//        if ([resourceName hasSuffix:@"jpg"]) {
//            NSLog(@"show image");
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                DLImageViewCtrl* ccImageViewCtrl = [[DLImageViewCtrl alloc]
//                                                     init];
//                [self presentViewController:ccImageViewCtrl animated:YES completion:^(void){
//                    ccImageViewCtrl.cimageView.contentMode = UIViewContentModeScaleAspectFill;
//                    ccImageViewCtrl.cimageView.backgroundColor = [UIColor orangeColor];
//                    ccImageViewCtrl.cimageView.image = [[UIImage alloc] initWithData:self.cmutData];
//                }];
//            });
//        }
    }
    self.cprogressCurrentReceiver = nil;
    [self.cprogressCurrentReceiver removeObserver:self forKeyPath:@"fractionCompleted"];
    self.cprogressCurrentReceiver = nil;
    
}
#pragma mark - nearby service
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
//    NSLog(@"found peer %@ %@", [peerID displayName], [info description]);
    
//    NSLog(@"found %@", [self.cmutarrRemtoePeerIdsFound description]);
    if (!peerID) {
        return;
    }
    NSPredicate* cprediate = [NSPredicate predicateWithFormat:@"(%K == %@)" , k_peer_id_name, [peerID displayName]];

    NSArray* carrList = [self.cmutarrRemtoePeerIdsConnected filteredArrayUsingPredicate:cprediate];
    
    if ([carrList count] == 0) {
        [self.cmutarrRemtoePeerIdsConnected addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:peerID,k_peer_id, [peerID displayName], k_peer_id_name, @(enum_peer_status_try_connecting), k_peer_status, nil]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.cTableServiceList reloadData];
        });
    }
   
    MCSession* csession = [self addToRemotePeerId:peerID];
    [browser invitePeer:peerID toSession:csession withContext:nil timeout:30.0f];
    
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"lost peer %@", [peerID displayName]);
    

    //remove session from session list
    [self removeFromRemotePeerId:peerID];
    
    NSPredicate* cprediate = [NSPredicate predicateWithFormat:@"(%K == %@)" , k_peer_id_name, [peerID displayName]];

    
    NSArray* carrListConnected = [self.cmutarrRemtoePeerIdsConnected filteredArrayUsingPredicate:cprediate];
    
    if ([carrListConnected count] > 0) {
        NSMutableDictionary* cmutdicPeerItem = [carrListConnected firstObject];
        [cmutdicPeerItem setObject:[NSNumber numberWithInt:enum_peer_status_not_connected] forKey:k_peer_status];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.cTableServiceList reloadData];
    });
}


// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
    NSLog(@"didNotStartBrowsingForPeers error:%@", [error description]);
    
}


#pragma mark - nearby advertise callback
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"didReceiveInvitationFromPeer %@", [peerID displayName]);

    NSPredicate* cpredicateFilter = [NSPredicate predicateWithFormat:@"(%K == %@)", k_peer_id_name, [peerID displayName]];
    NSArray* carrrConnected = [self.cmutarrRemtoePeerIdsConnected filteredArrayUsingPredicate:cpredicateFilter];
    
  
    
    if ([carrrConnected count] > 0) {
        NSDictionary* cdicConnected = [carrrConnected firstObject];
        NSNumber* cnumberStatus = [cdicConnected objectForKey:k_peer_status];
        if ([cnumberStatus unsignedIntValue] != enum_peer_status_connected) {
            MCSession* csessionNew = [[MCSession alloc] initWithPeer:self.cpeerId];
            csessionNew.delegate = self;
            MCSession* csession = [self addToRemotePeerId:peerID];
            invitationHandler(YES, csession);
        }
    }else {
        [self.cmutarrRemtoePeerIdsConnected addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:peerID,k_peer_id, [peerID displayName], k_peer_id_name, @(enum_peer_status_try_connecting), k_peer_status, nil]];
        
        MCSession* csession = [self addToRemotePeerId:peerID];
        invitationHandler(YES, csession);
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.cTableServiceList reloadData];
    });
    
}


// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"didNotStartAdvertisingPeer %@", [error description]);
}
#pragma mark - tableview  callback

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 50.0f;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* cviewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:id_table_header];
    cviewHeader.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cviewHeader.textLabel.textColor = k_colore_blue;
    switch (section) {
        case 0:
        {
            cviewHeader.textLabel.textAlignment = NSTextAlignmentCenter;
            cviewHeader.textLabel.text = NSLocalizedString(@"k_connected_service", nil);
            break;
        }

        default:
        {
            cviewHeader.textLabel.textAlignment = NSTextAlignmentCenter;
            cviewHeader.textLabel.text = NSLocalizedString(@"k_disconnected_service", nil);                      
            break;
        }
    }
    return cviewHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fHeight = 0.0f;

    fHeight = [DLItemTableViewCell HeightForCell:[self.cmutarrRemtoePeerIdsConnected objectAtIndex:[indexPath row]]];


    return  fHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger iNumber = 0;
    iNumber = [self.cmutarrRemtoePeerIdsConnected count];
    return iNumber;

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLItemTableViewCell* ccCellItem = [tableView dequeueReusableCellWithIdentifier:id_table_cell];
    if (!ccCellItem) {
        ccCellItem = [[DLItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id_table_cell];
        ccCellItem.idCellUpdateCB = self;
    }
    [ccCellItem ccPopoutAction].layer.transform = CATransform3DIdentity;
    
    NSDictionary* cdicItem = [self.cmutarrRemtoePeerIdsConnected objectAtIndex:[indexPath row]];
    ccCellItem.bIsConnected = YES;
    [ccCellItem feedInfo:cdicItem];
    
    return ccCellItem;
}


#pragma mark - cell proto 

-(void)didCellUpdated:(UITableViewCell*)acTableviewCell {
    [self.cTableServiceList reloadData];
    
}



-(void)didGallerySelected:(UITableViewCell*)acTableviewCell {
    DLItemTableViewCell* ccItemCell = (DLItemTableViewCell*)acTableviewCell;
    self.cdicSelectedPeer = ccItemCell.cdicInfo;
    //NSLog(@"gallery selected %@", ccItemCell.cdicInfo);
    
    if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_camera", nil) message:NSLocalizedString(@"k_error_camera_not_availale", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
        return;
    }
    
    UIImagePickerController* cImagePickerCtrl = [[UIImagePickerController alloc] init];
    cImagePickerCtrl.mediaTypes = @[((__bridge NSString*)kUTTypeImage)];
    cImagePickerCtrl.delegate = self;
    [self presentViewController:cImagePickerCtrl animated:YES completion:^(void){
        
    }];
}

-(void)didCameraSelected:(UITableViewCell*)acTableviewCell {
    DLItemTableViewCell* ccItemCell = (DLItemTableViewCell*)acTableviewCell;
//    NSLog(@"gallery selected %@", ccItemCell.cdicInfo);
    self.cdicSelectedPeer = ccItemCell.cdicInfo;
    
    
    if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_camera", nil) message:NSLocalizedString(@"k_error_camera_not_availale", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
        return;
    }
    
    UIImagePickerController* cImagePickerCtr = [[UIImagePickerController alloc] init];
    cImagePickerCtr.mediaTypes = @[(__bridge NSString*)kUTTypeImage];
    cImagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
    cImagePickerCtr.allowsEditing = YES;
    cImagePickerCtr.showsCameraControls = YES;
    cImagePickerCtr.delegate = self;
    [self presentViewController:cImagePickerCtr animated:YES completion:^(void){
    }];
    

}

-(void)didChatSelected:(UITableViewCell*)acTableviewCell {
    DLItemTableViewCell* ccItemCell = (DLItemTableViewCell*)acTableviewCell;
//    NSLog(@"gallery selected %@", ccItemCell.cdicInfo);
    
    DLChatTableViewCtrl* ccChatViewCtrl = [[DLChatTableViewCtrl alloc] init];
    ccChatViewCtrl.cdicPeerInfoFrom = @{k_peer_id:self.cpeerId, k_peer_id_name:[self.cpeerId displayName]};
    ccChatViewCtrl.cdicPeerInfoTo = ccItemCell.cdicInfo;

    ccChatViewCtrl.cMulPeerSession = [self findRemoteSession:[ccItemCell.cdicInfo objectForKey:k_peer_id]];
    [self.navigationController pushViewController:ccChatViewCtrl animated:YES];
    

}

#pragma mark - image controller callback 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"%@", [info description]);
        /*
         "k_cancel" = "取消";
         "k_ok" = "确定";
         "k_rename_file" = "保存文件名字";
         */
        
        UIImage* cimageEditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (cimageEditedImage) {
            _cdataCapturedImage = UIImageJPEGRepresentation(cimageEditedImage, 0.5f);
        }else {
            UIImage* cimageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
            _cdataCapturedImage = UIImageJPEGRepresentation(cimageOriginal, 0.5f);
        }
        
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_rename_file", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
        calertMsg.alertViewStyle = UIAlertViewStylePlainTextInput;
        [calertMsg show];
    }];

}

-(void)sendResource:(NSURL*)acUrl toPeer:(NSDictionary*)acdicPeerId {
   
     if (![self.view viewWithTag:k_tag_progress_view]) {
     [self.view addSubview:self.ctProgressHud];
     self.ctProgressHud.labelText = NSLocalizedString(@"k_sending_file", nil);
     }
     [self.ctProgressHud show:YES];
    NSString* cstrLastName = [[acUrl absoluteString] lastPathComponent];
    
    MCSession* csession = [self findRemoteSession:[acdicPeerId objectForKey:k_peer_id]];

     self.cprogressCurrentSender = [csession sendResourceAtURL:acUrl withName:cstrLastName toPeer:acdicPeerId[k_peer_id] withCompletionHandler:^(NSError* cError) {
     if (cError) {
     NSLog(@"tranfer complete error %@", [cError description]);
     }else {
     NSLog(@"tranfer complete");
     }
     u_int32_t uiSessionId = (u_int32_t)lround([[NSDate date] timeIntervalSince1970]);

     NSData* cdataMedia = [NSData dataWithContentsOfURL:acUrl];
     NSString* cstrType = [cstrLastName lowercaseString];
     NSDictionary*  cdicChatItem = nil;
     if ([cstrType hasSuffix:@"jpg"] || [cstrLastName hasSuffix:@"png"]) {
         cdicChatItem = @{
                          k_chat_from:self.cpeerId,
                          k_chat_to:acdicPeerId[k_peer_id],
                          k_chat_msg:cdataMedia,
                          k_chat_msg_id:@(uiSessionId),
                          k_chat_msg_type:@(enum_package_type_image),
                          k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                          k_chat_msg_media_url:[acUrl absoluteString],
                          k_chat_msg_finished:@(1)
                          };
     }else if([cstrLastName hasSuffix:@"mov"]) {
         cdicChatItem = @{
                          k_chat_from:self.cpeerId,
                          k_chat_to:acdicPeerId[k_peer_id],
                          k_chat_msg:cdataMedia,
                          k_chat_msg_id:@(uiSessionId),
                          k_chat_msg_type:@(enum_package_type_video),
                          k_chat_date: @([[NSDate date] timeIntervalSince1970]),
                          k_chat_msg_media_url:[acUrl absoluteString],
                          k_chat_msg_finished:@(1)
                          };
     }
      
    [DLModel SaveMsgItem:cdicChatItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_increase object:nil userInfo:cdicChatItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg object:nil userInfo:cdicChatItem];

                                    
     [self.cprogressCurrentSender removeObserver:self forKeyPath:@"fractionCompleted"];
     dispatch_async(dispatch_get_main_queue(), ^(void){
     self.ctProgressHud.labelText = NSLocalizedString(@"k_sending_file_finished", nil);
     [self.ctProgressHud hide:YES];
     });
     
     }];
     [self.cprogressCurrentSender addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
-(void)shouldConnectToPeer:(UITableViewCell*)acTableviewCell {
    DLItemTableViewCell* ccItemTableviewCell = (DLItemTableViewCell*)acTableviewCell;
    
    NSMutableDictionary* cmutdicPeerItem = (NSMutableDictionary*)ccItemTableviewCell.cdicInfo;
    MCPeerID* cPeerId = cmutdicPeerItem[k_peer_id];
    NSNumber* cnumberStatus = [cmutdicPeerItem objectForKey:k_peer_status];
    
    if ([cnumberStatus unsignedIntValue] == enum_peer_status_not_connected ) {
        self.cpeerIdGoingtoConnect = cPeerId;
        
        [cmutdicPeerItem setObject:@(enum_peer_status_try_connecting) forKey:k_peer_status];
        [cmutdicPeerItem setObject:[NSNumber numberWithBool:NO] forKey:k_show_action];
        [self.cTableServiceList reloadData];
        /*
        MCSession* csession = [self findRemoteSession:self.cpeerIdGoingtoConnect];
        if(csession){
            @try {
                [_cnearbyServiceBrowser invitePeer: self.cpeerIdGoingtoConnect toSession:csession withContext:nil timeout:30.0f];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception description]);
            }
        }else {
            NSLog(@"lost connect session");
        }*/
        
    }else {
        self.cpeerIdGoingtoConnect = nil;
    }

}

#pragma mark - alert callback 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* cstrClickBtnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([cstrClickBtnTitle isEqualToString:NSLocalizedString(@"k_file_replace", nil)]) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        NSError* cError = nil;
        [self.cdataCapturedImage writeToFile:self.cstrSavedFilePath options:NSDataWritingAtomic error:&cError];
        if (cError) {
            UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_warnning", nil) message:NSLocalizedString(@"k_save_file_failure", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
            [calertMsg show];
            return;
        }
        [self sendResource:[NSURL fileURLWithPath:self.cstrSavedFilePath] toPeer:self.cdicSelectedPeer];
        return;
    }else if([cstrClickBtnTitle isEqualToString:NSLocalizedString(@"k_cancel", nil)]) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    UITextField* ctextfield = [alertView textFieldAtIndex:0];
    NSString* cstrText = [ctextfield text];
    if (!cstrText || [cstrText length] == 0) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_warnning", nil) message:NSLocalizedString(@"k_file_name_required", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [calertMsg show];
        return;
    }
    if (![cstrText hasSuffix:@"jpg"]) {
        cstrText = [cstrText stringByAppendingPathExtension:@"jpg"];
    }
    NSFileManager* cfileMgDefault = [NSFileManager defaultManager];
    NSString* cstrFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[@"Documents" stringByAppendingPathComponent:cstrText]];
    self.cstrSavedFilePath = cstrFilePath;

    if([cfileMgDefault fileExistsAtPath:cstrFilePath]) {
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_warnning", nil) message:NSLocalizedString(@"k_file_exists", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_file_replace", nil), nil];
        [calertMsg show];
        return;
    }
    
    NSError* cError = nil;
    [self.cdataCapturedImage writeToFile:cstrFilePath options:NSDataWritingAtomic error:&cError];
    if (cError) {
        NSLog(@"Error %@", [cError description]);
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_warnning", nil) message:NSLocalizedString(@"k_save_file_failure", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [calertMsg show];
        return;
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self sendResource:[NSURL fileURLWithPath:cstrFilePath] toPeer:self.cdicSelectedPeer];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - swipe
-(void)actionSwipe:(UISwipeGestureRecognizer*)aswipeGes {
    switch (aswipeGes.direction) {
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"swipe down");
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"swipe up");
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"swipe left");
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"swipe right");
        {
            [self pushFolderViewCtrl];
        }
            break;
        default:
            break;
    }
}
-(void)pushFolderViewCtrl {
    
    DLFolderViewViewCtrl* ccFolderViewCtrl = [[DLFolderViewViewCtrl alloc] init];
    ccFolderViewCtrl.transitioningDelegate = self;
    [self presentViewController:ccFolderViewCtrl animated:YES completion:nil];
    
}

-(void)actionLogin:(id)aidSender {
}
-(void)actionShowFolderManager:(id)aidSender {
    DLFolderViewViewCtrl* ccFolderViewCtrl = [[DLFolderViewViewCtrl alloc] init];
    [self.navigationController pushViewController:ccFolderViewCtrl animated:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[DLInteractiveTransitioner alloc] init];

}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    DLInteractiveTransitioner* ccInteractiveTr =  [[DLInteractiveTransitioner alloc] init];
    ccInteractiveTr.reverse = YES;
    return ccInteractiveTr;

}




#pragma mark - transition coordinator
- (BOOL)animateAlongsideTransition:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))animation
                        completion:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
    return YES;
}

// This alternative API is needed if the view is not a descendent of the container view AND you require this animation
// to be driven by a UIPercentDrivenInteractiveTransition interaction controller.
- (BOOL)animateAlongsideTransitionInView:(UIView *)view
                               animation:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))animation
                              completion:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
    return YES;
}

// When a transition changes from interactive to non-interactive then handler is
// invoked. The handler will typically then do something depending on whether or
// not the transition isCancelled. Note that only interactive transitions can
// be cancelled and all interactive transitions complete as non-interactive
// ones. In general, when a transition is cancelled the view controller that was
// appearing will receive a viewWillDisappear: call, and the view controller
// that was disappearing will receive a viewWillAppear: call.  This handler is
// invoked BEFORE the "will" method calls are made.
- (void)notifyWhenInteractionEndsUsingBlock: (void (^)(id <UIViewControllerTransitionCoordinatorContext>context))handler {
    
}
@end

@implementation DLInteractiveTransitioner

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:2.0f delay:0 options:0 animations:^{
        if (self.reverse) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        }
        else {
            toViewController.view.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}



@end
