//
//  DLChatTableViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLViewChatInput.h"
#import <AVFoundation/AVFoundation.h>
#import "DLTableCellChat.h"
#import <CoreLocation/CoreLocation.h>
#import "DLFolderViewViewCtrl.h"

@class MCSession;
@class DLViewMore;
@class MBProgressHUD;
@interface DLChatTableViewCtrl : DLRootViewCtrl<UITableViewDelegate, UITableViewDataSource, DLViewChatInputProto, AVAudioRecorderDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DLTableCellChatProto, CLLocationManagerDelegate, ProtoTreeViewModel>{
    AVAudioRecorder* _c_audio_recorder;
    NSString* _c_str_audio_recording_path;
    
}
@property(strong, nonatomic) UITableView* ctableViewChat;
@property(strong, nonatomic) NSMutableArray* cmutarrChatList;
@property(strong, nonatomic) NSDictionary* cdicPeerInfoTo;
@property(strong, nonatomic) NSDictionary* cdicPeerInfoFrom;

@property(strong, nonatomic) DLViewChatInput* ccViewChatInput;
@property(strong, nonatomic) MCSession* cMulPeerSession;
@property(strong, nonatomic) DLViewMore* ccViewMore;
@property(assign, nonatomic) BOOL bIsInputMode;
@property(strong, nonatomic) NSProgress* cProgressSending;
@property(strong, nonatomic) MBProgressHUD* ctProgressView;
@property(strong, nonatomic) CLLocationManager* cLocationManager;
@property(strong, nonatomic) CLLocation* cLocationCurrent;
-(void)feedChatList:(NSArray*)acarrList;

-(void)dismissKeyBoard:(UITapGestureRecognizer*)acTapGes;

-(void)scrollChatToBottom;
-(void)actionSelectGallery:(id)aidSender;
-(void)actionSelectCamera:(id)aidSender;
-(void)actionSelectVideo:(id)aidSender;
-(void)actionSelectFolder:(id)aidSender;
-(void)actionSelectLocation:(id)aidSender;
-(void)actionSelectVideoFile:(id)aidSender;

-(void)dismissProgressView;
-(void)showProgressView;
@end
