//
//  DLMPViewCtrl.h
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLItemTableViewCell.h"

@class MBProgressHUD;
@class PulsingHaloLayer;

@interface DLMPViewCtrl : UIViewController<MCSessionDelegate, MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate, UITableViewDataSource, UITableViewDelegate,DLCellPopoutProto, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIViewControllerTransitioningDelegate>
@property(nonatomic, strong) MCSession* csession;
@property(nonatomic, strong) MCPeerID* cpeerId;

@property(nonatomic, strong) MCNearbyServiceBrowser* cnearbyServiceBrowser;
@property(nonatomic, strong) MCNearbyServiceAdvertiser* cnearbyServiceAdvertiser;
@property(nonatomic, strong) NSMutableArray* cmutarrRemtoePeerIdsConnected;
@property(nonatomic, strong) NSMutableArray* cmutarrRemtoePeerIdsFound;

@property(nonatomic, strong) UITableView* cTableServiceList;
@property(nonatomic, strong) MBProgressHUD* ctProgressHud;

@property(nonatomic, strong) NSMutableData* cmutData;

@property(nonatomic, strong) MCPeerID* cpeerIdCurrent;
@property(nonatomic, strong) NSProgress* cprogressCurrentReceiver;
@property(nonatomic, strong) NSProgress* cprogressCurrentSender;
@property(nonatomic, strong) UIView* cviewTableHeader;
@property(nonatomic, strong) UIImageView* cimageViewBtnScan;
@property(nonatomic, strong) MCPeerID* cpeerIdGoingtoConnect;
@property(strong, nonatomic) PulsingHaloLayer* ctHaloLayer;
@property(strong, nonatomic) NSData* cdataCapturedImage;
@property(strong, nonatomic) NSDictionary* cdicSelectedPeer;
@property(copy, nonatomic) NSString* cstrSavedFilePath;
-(void)actionStartBrowserNearbyUsers:(id)aidSender;
-(void)actionDismissServiceBrowser:(id)aidsender;
-(void)actionSwipe:(UISwipeGestureRecognizer*)aswipeGes;

-(void)pushFolderViewCtrl;

@end

@interface DLInteractiveTransitioner : NSObject<UIViewControllerAnimatedTransitioning>
@property(assign, nonatomic) BOOL reverse;

@end
