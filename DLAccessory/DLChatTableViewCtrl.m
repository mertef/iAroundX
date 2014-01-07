//
//  DLChatTableViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLChatTableViewCtrl.h"
#import "DLTableCellChat.h"
#import "DLMCConfig.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLViewMore.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DLMapViewCtrl.h"

@interface DLChatTableViewCtrl ()
-(void)initAvAudioRecroder;
-(void)sendData:(NSData*)aData toPeer:(MCPeerID*)acPeerId withType:(T_PACKAGE_TYPE)atPackageType mediaUrl:(NSURL*)acMediaUrl;

@end

@implementation DLChatTableViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cmutarrChatList = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotiNewMsgArrived:) name:k_noti_chat_msg object:nil];
        self.self.bIsInputMode = YES;
    }
    return self;
}

-(void)actionNotiNewMsgArrived:(NSNotification*)acNoti {
    if ([acNoti.name isEqualToString:k_noti_chat_msg]) {
        NSDictionary* cdicUserInfo = acNoti.userInfo;
        MCPeerID* cpeerIdTo = [cdicUserInfo objectForKey:k_chat_to];
        MCPeerID* cpeerIdFrom = self.cdicPeerInfoFrom[k_peer_id];
        if ([[cpeerIdFrom displayName] isEqualToString:[cpeerIdTo displayName]]) {
            [self.cmutarrChatList addObject:cdicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.ctableViewChat reloadData];
                [self scrollChatToBottom];
            });
        }
    }
}
- (void)dealloc
{
    _c_str_audio_recording_path = nil;    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.cProgressSending removeObserver:self forKeyPath:@"fractionCompleted"];

    self.tabBarController.tabBar.hidden = NO;

}

-(void)didKeyBoardAppear:(NSNotification*)acNotifi {
    self.bIsInputMode = YES;
    NSDictionary* cdicInfo = acNotifi.userInfo;
    NSValue* cvalueFrameEnd = [cdicInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect srectFrameEnd = [cvalueFrameEnd CGRectValue];   
    
    if(CGRectGetMaxY(self.ccViewChatInput.frame) - CGRectGetMinY(srectFrameEnd) < 0) {
        return;
    }
    [UIView animateWithDuration:0.5f animations:^(void){
        self.ctableViewChat.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(srectFrameEnd) - CGRectGetHeight(self.ccViewChatInput.frame));
        CGRect srectFrameInput = self.ccViewChatInput.frame;
        srectFrameInput.origin.y = CGRectGetMinY(srectFrameEnd) - CGRectGetHeight(srectFrameInput);
        self.ccViewChatInput.frame = srectFrameInput;
        CGRect srectMore = self.ccViewMore.frame;
        srectMore.origin.y = CGRectGetHeight(self.view.bounds);
        self.ccViewMore.frame = srectMore;
    } completion:^(BOOL abFinished){
        [self scrollChatToBottom];
    }];
    
   
}

-(void)didKeyBoardHide:(NSNotification*)acNotifi {
//    NSDictionary* cdicInfo = acNotifi.userInfo;
//    NSValue* cvalueFrameEnd = [cdicInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect srectFrameEnd = [cvalueFrameEnd CGRectValue];
    if (self.bIsInputMode) {
        
//        CGFloat fHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.ccViewChatInput.frame);
//        if( fHeight > k_height_keyboard) {
//            return;
//        }
        
        [UIView animateWithDuration:0.5f animations:^(void){
            self.ctableViewChat.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.ccViewChatInput.frame));
            CGRect srectFrameInput = self.ccViewChatInput.frame;
            srectFrameInput.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(srectFrameInput);
            self.ccViewChatInput.frame = srectFrameInput;
            CGRect srectMore = self.ccViewMore.frame;
            srectMore.origin.y = CGRectGetHeight(self.view.bounds);
            self.ccViewMore.frame = srectMore;
        }];
    }
    
    
}


-(void)didKeyBoardFrameChange:(NSNotification*)acNotifi {
    if (self.ccViewChatInput.ctextViewInput.isFirstResponder) {
        self.bIsInputMode = YES;
        NSDictionary* cdicInfo = acNotifi.userInfo;
        NSValue* cvalueFrameEnd = [cdicInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect srectFrameEnd = [cvalueFrameEnd CGRectValue];
        [UIView animateWithDuration:0.5f animations:^(void){
            self.ctableViewChat.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(srectFrameEnd) - CGRectGetHeight(self.ccViewChatInput.frame));
            CGRect srectFrameInput = self.ccViewChatInput.frame;
            srectFrameInput.origin.y = CGRectGetMinY(srectFrameEnd) - CGRectGetHeight(srectFrameInput);
            self.ccViewChatInput.frame = srectFrameInput;

        } completion:^(BOOL abFinished){
        }];

    }else {
        self.bIsInputMode = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initAvAudioRecroder {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    if (!_c_audio_recorder) {
        NSError* cerror = nil;
        _c_str_audio_recording_path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", k_default_recording_path];
        _c_audio_recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_c_str_audio_recording_path]
                                                        settings:@{
                                                                  AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                                                  AVSampleRateKey:@(44100.0),
                                                                  AVNumberOfChannelsKey:@(2),
                                                                  AVEncoderAudioQualityKey: @(AVAudioQualityLow),
                                                                  AVEncoderBitRateKey:@(16)
                                                                  
                                                                  }
                                                           error:&cerror];
        _c_audio_recorder.delegate = self;
        if(cerror){
            UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_audio", nil) message:NSLocalizedString(@"k_audio_disable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
            [cAlertMsg show];
            cAlertMsg = nil;
        }
    }
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAvAudioRecroder];

    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];

    
    self.title = NSLocalizedString(@"k_chat_room", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    _ctableViewChat = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds) - k_height_input)];
    _ctableViewChat.delegate =self;
    _ctableViewChat.dataSource = self;
    _ctableViewChat.backgroundColor = [UIColor colorWithRed:0.9098 green:0.9098 blue:0.9098 alpha:1.0f];
    _ctableViewChat.separatorStyle = UITableViewCellSeparatorStyleNone;

    UITapGestureRecognizer* ctapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    ctapGes.delegate = self;
    [self.ctableViewChat addGestureRecognizer:ctapGes];
    
    [self.view addSubview:_ctableViewChat];
    
    self.ccViewChatInput = [[DLViewChatInput alloc] initWithFrame:CGRectMake(0.0f,  CGRectGetHeight(self.view.bounds) - k_height_input, CGRectGetWidth(self.view.bounds),k_height_input)];
    _ccViewChatInput.idProtoViewChat = self;
//    [_ccViewChatInput.ctextViewInput addObserver:self forKeyPath:@"sRectBoundContent" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:_ccViewChatInput];
    
     UIView* cviewBg = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 20.0f)];
    [cviewBg setBackgroundColor:[UIColor clearColor]];
    self.ctableViewChat.tableFooterView = cviewBg;
	// Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sRectBoundContent"]) {
        NSValue* cValueSizeNew = [change objectForKey:NSKeyValueChangeNewKey];
        NSValue* cValueSizeOld = [change objectForKey:NSKeyValueChangeOldKey];

        CGRect srectInputFrameOrigin = [cValueSizeOld CGRectValue];
        CGRect srectInputFrameNew = [cValueSizeNew CGRectValue];
        
        UIEdgeInsets sEdgeInset = [self.ccViewChatInput.ctextViewInput textContainerInset];

      
        if (srectInputFrameOrigin.size.height == srectInputFrameNew.size.height) {
            return;
        }

       srectInputFrameNew.size = CGSizeMake(srectInputFrameNew.size.width + sEdgeInset.left + sEdgeInset.right, srectInputFrameNew.size.height + sEdgeInset.top + sEdgeInset.bottom);
        
        NSLog(@"the input size is %@", NSStringFromCGRect(srectInputFrameNew));
        

        self.ccViewChatInput.frame = CGRectMake(srectInputFrameOrigin.origin.x, srectInputFrameOrigin.origin.y + srectInputFrameOrigin.size.height - srectInputFrameNew.size.height - 8.0f, srectInputFrameNew.size.width, srectInputFrameNew.size.height + 8.0f);

       
        return;
    }else if([keyPath isEqualToString:@"fractionCompleted"]){
//        NSLog(@"sending percentage is %f", [self.cProgressSending fractionCompleted]);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.ctProgressView.progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            if (self.cProgressSending.fractionCompleted >= 1.0f) {
                [self dismissProgressView];
            }
        });
       
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:nil];
}

-(void)didTextFrameChange:(DLViewChatInput*)accViewChatInput {
    
    CGRect srectFrameOrigin = accViewChatInput.frame;
    
    UIEdgeInsets sEdgeInset = [self.ccViewChatInput.ctextViewInput textContainerInset];
    UIEdgeInsets sEdgeInsetContent = [self.ccViewChatInput.ctextViewInput contentInset];

    CGRect srectBound = accViewChatInput.sRectBoundContent;
    srectBound.size.height = ceilf(srectBound.size.height);
    if ( srectBound.size.height < k_height_input) {
        srectBound.size.height = k_height_input - (sEdgeInset.top + sEdgeInset.bottom + 8.0f + sEdgeInsetContent.top + sEdgeInsetContent.bottom);
    }
    srectBound.size.width = ceilf(srectBound.size.width);
    srectBound.origin.x = ceilf(srectBound.origin.x);
    srectBound.origin.y = ceilf(srectBound.origin.y);
    
    
    CGRect srectFrameNew = CGRectMake(srectFrameOrigin.origin.x, CGRectGetMaxY(srectFrameOrigin) - (CGRectGetHeight(srectBound) + sEdgeInset.top + sEdgeInset.bottom + 8.0f + sEdgeInsetContent.top + sEdgeInsetContent.bottom), srectFrameOrigin.size.width, srectBound.size.height + sEdgeInset.top + sEdgeInset.bottom + 8.0f + sEdgeInsetContent.top + sEdgeInsetContent.bottom);
    
    if (srectFrameNew.size.height == srectFrameOrigin.size.height) {
        return;
    }
    srectFrameNew.size.height = ceilf(srectFrameNew.size.height);
    srectFrameNew.size.width = ceilf(srectFrameNew.size.width);
    srectFrameNew.origin.x = ceilf(srectFrameNew.origin.x);
    srectFrameNew.origin.y = ceilf(srectFrameNew.origin.y);
    
    
    self.ccViewChatInput.frame = srectFrameNew;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview callback 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fHeight = 0.0f;
    NSDictionary* cdicInfo = [self.cmutarrChatList objectAtIndex:[indexPath row]];
    fHeight = [DLTableCellChat HeightForCell:cdicInfo];
    return fHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cmutarrChatList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"k_cell_chat"];
    if (!cell) {
        cell = [[DLTableCellChat alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"k_cell_chat"];
        DLTableCellChat* ccCellChat = (DLTableCellChat*)cell;
        ccCellChat.idChatProto = self;
        ccCellChat.cstrPeerFrom = [self.cdicPeerInfoFrom objectForKey:k_peer_id_name];
    }
    
    DLTableCellChat* ccCellChat = (DLTableCellChat*)cell;
    
    [ccCellChat feedDictionaryInfo:[self.cmutarrChatList objectAtIndex:[indexPath row]]];
   
    return cell;
}
#pragma mark - textinput callback 

-(void)didSendTextMsg:(DLViewChatInput*)accViewChatInput {
    NSString* cstrText = [accViewChatInput ctextViewInput].text;
    
    if (cstrText && [cstrText length] > 0) {
        NSData* cdataTxt = [cstrText dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger uiUsedLength = [cdataTxt length];
        
        T_PACKAGE_HEADER tPackageHeader;
        tPackageHeader._u_l_package_type = enum_package_type_short_msg;
        tPackageHeader._u_l_package_size = (int32_t)(sizeof(T_PACKAGE_HEADER) + uiUsedLength);
        tPackageHeader._u_l_package_length = (int32_t)uiUsedLength;
        tPackageHeader._u_l_current_offset = (int32_t)sizeof(T_PACKAGE_HEADER);
        
        NSData* cdataHeader = [NSData dataWithBytes:&tPackageHeader length:sizeof(tPackageHeader)];
        
        NSMutableData* cmutDataPackage = [[NSMutableData alloc] init];
        [cmutDataPackage appendData:cdataHeader];
        [cmutDataPackage appendData:cdataTxt];
        NSLog(@"send sizie is %lu", (u_long)[cmutDataPackage length]);
        
        NSError* cError = nil;
        [self.cMulPeerSession sendData:cmutDataPackage toPeers:@[self.cdicPeerInfoTo[k_peer_id]] withMode:MCSessionSendDataReliable error:&cError];
        if (cError) {
            UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_session_error", nil) message:NSLocalizedString(@"k_error_session_msg", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
            [calertMsg show];
        }else {
            [accViewChatInput ctextViewInput].text = @"";
            NSDate* cdateNow = [NSDate date];
            NSMutableDictionary* cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, cdataTxt, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date, @(enum_package_type_short_msg), k_chat_msg_type, nil];
            
            [self.cmutarrChatList addObject:cmutdicItem];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.ctableViewChat reloadData];
                [self scrollChatToBottom];
            });
          
        }
    }
}

-(void)didMorePressed:(DLViewChatInput*)accViewChatInput{
    
    if (!self.ccViewMore) {
        self.ccViewMore = [[DLViewMore alloc] initWithFrame: CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), k_height_keyboard)];
        [self.ccViewMore.cbtnGallery addTarget:self action:@selector(actionSelectGallery:) forControlEvents:UIControlEventTouchUpInside];
        [self.ccViewMore.cbtnCamera addTarget:self action:@selector(actionSelectCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self.ccViewMore.cbtnVideo addTarget:self action:@selector(actionSelectVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.ccViewMore.cbtnLocation addTarget:self action:@selector(actionSelectLocation:) forControlEvents:UIControlEventTouchUpInside];
        [self.ccViewMore.cbtnFile addTarget:self action:@selector(actionSelectFolder:) forControlEvents:UIControlEventTouchUpInside];
        [self.ccViewMore.cbtnVideoFile addTarget:self action:@selector(actionSelectVideoFile:) forControlEvents:UIControlEventTouchUpInside];



    }
    CGFloat fHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.ccViewChatInput.frame);

    self.bIsInputMode = !self.bIsInputMode;
    if (fHeight < k_height_keyboard) {
        self.bIsInputMode = NO;
    }
    if (self.bIsInputMode) {
        [self.ccViewChatInput.ctextViewInput becomeFirstResponder];

        [UIView animateWithDuration:0.2 animations:^(void){
            self.ccViewMore.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), k_height_keyboard);
        } completion:^(BOOL abFinished){
            if (abFinished) {
                [self.ccViewMore removeFromSuperview];
            }
        }];
    }else {
        if ([self.ccViewChatInput.ctextViewInput isFirstResponder]) {
            [self.ccViewChatInput.ctextViewInput resignFirstResponder];
        }
        [self.view addSubview:self.ccViewMore];
        [self.view bringSubviewToFront:self.ccViewMore];

        if ( fHeight <  k_height_keyboard) {
            [UIView animateWithDuration:0.5f animations:^(void){
                self.ctableViewChat.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - k_height_keyboard - CGRectGetHeight(self.ccViewChatInput.frame));
                CGRect srectFrameInput = self.ccViewChatInput.frame;
                srectFrameInput.origin.y =  CGRectGetHeight(self.view.bounds) - k_height_keyboard - CGRectGetHeight(srectFrameInput);
                self.ccViewChatInput.frame = srectFrameInput;
                self.ccViewMore.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - k_height_keyboard, CGRectGetWidth(self.view.bounds), k_height_keyboard);

            } completion:^(BOOL abFinished){
                [self scrollChatToBottom];
            }];
        }else {
            [UIView animateWithDuration:0.2 animations:^(void){
                
                 self.ccViewMore.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - k_height_keyboard, CGRectGetWidth(self.view.bounds), k_height_keyboard);
//                NSLog(@"view more %@", NSStringFromCGRect(self.ccViewMore.frame));
            }];
        }
        
        
    }
}

-(void)feedChatList:(NSArray*)acarrList {
    NSDictionary* cdicItem = [acarrList firstObject];
    MCPeerID* cPeerIdFrom = cdicItem[k_chat_from];
    MCPeerID* cPeerIdTo = cdicItem[k_chat_to];

    
    self.cdicPeerInfoTo = @{k_peer_id:cPeerIdFrom, k_peer_id_name: [cPeerIdFrom displayName]};
    self.cdicPeerInfoFrom = @{k_peer_id:cPeerIdTo, k_peer_id_name: [cPeerIdTo displayName]};

    
    [self.cmutarrChatList addObjectsFromArray:acarrList];
}

-(void)dismissKeyBoard:(UITapGestureRecognizer*)acTapGes {
    
    if (self.ccViewChatInput.ctextViewInput.isFirstResponder) {
        [self.ccViewChatInput.ctextViewInput resignFirstResponder];
    }else {
        [UIView animateWithDuration:0.5f animations:^(void){
            self.ctableViewChat.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.ccViewChatInput.frame));
            CGRect srectFrameInput = self.ccViewChatInput.frame;
            srectFrameInput.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(srectFrameInput);
            self.ccViewChatInput.frame = srectFrameInput;
            self.ccViewMore.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), k_height_keyboard);

        }];
    }
    
    
    
}
-(void)scrollChatToBottom {
    if ([self.ctableViewChat contentSize].height >= CGRectGetHeight(self.view.bounds) * 0.5f) {
        NSIndexPath* cIndexPath = [NSIndexPath indexPathForRow: [self.cmutarrChatList count] - 1 inSection: 0];
        [self.ctableViewChat scrollToRowAtIndexPath: cIndexPath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }        
}

-(void)didStartRecording:(DLViewChatInput*)accViewChatInput {
    if ([_c_audio_recorder isRecording]) {
        [_c_audio_recorder stop];
    }
    
    BOOL abFlag = [_c_audio_recorder prepareToRecord];
    
    if(!abFlag) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_audio", nil) message:NSLocalizedString(@"k_audio_disable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
    }
    abFlag = [_c_audio_recorder record];
    
    
    if(!abFlag) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_audio", nil) message:NSLocalizedString(@"k_audio_disable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
    }
}
-(void)didStopRecording:(DLViewChatInput*)accViewChatInput {
    //send
    [_c_audio_recorder stop];
    NSLog(@"---%@", [[_c_audio_recorder url] absoluteString]);
    NSData* cdataAudio = [[NSData alloc] initWithContentsOfURL:_c_audio_recorder.url];

    NSUInteger uiUsedLength = [cdataAudio length];
    if (uiUsedLength == 0) {
        return;
    }
    
    T_PACKAGE_HEADER tPackageHeader;
    tPackageHeader._u_l_package_type = enum_package_type_audio;
    tPackageHeader._u_l_package_size = (int32_t)(sizeof(T_PACKAGE_HEADER) + uiUsedLength);
    tPackageHeader._u_l_package_length = (int32_t)uiUsedLength;
    tPackageHeader._u_l_current_offset = (int32_t)sizeof(T_PACKAGE_HEADER);
    
    NSData* cdataHeader = [NSData dataWithBytes:&tPackageHeader length:sizeof(tPackageHeader)];
    
    NSMutableData* cmutDataPackage = [[NSMutableData alloc] init];
    [cmutDataPackage appendData:cdataHeader];
    [cmutDataPackage appendData:cdataAudio];
//    NSLog(@"send sizie is %lu", (u_long)[cmutDataPackage length]);
    
    NSError* cError = nil;
    [self.cMulPeerSession sendData:cmutDataPackage toPeers:@[self.cdicPeerInfoTo[k_peer_id]] withMode:MCSessionSendDataReliable error:&cError];
    if (cError) {
//        NSLog(@"I am the main thread %@", [NSThread isMainThread]?@"yes":@"NO");
        UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_session_error", nil) message:NSLocalizedString(@"k_error_session_msg", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
        [calertMsg show];
    }else {
        NSDate* cdateNow = [NSDate date];
        NSMutableDictionary* cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, cdataAudio, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date, @(enum_package_type_audio), k_chat_msg_type,nil];
        
        [self.cmutarrChatList addObject:cmutdicItem];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.ctableViewChat reloadData];
            [self scrollChatToBottom];
        });
       
    }
    
    
}
#pragma mark - audio callback
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
    }
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_audio", nil) message:NSLocalizedString(@"k_audio_disable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:nil, nil];
    [cAlertMsg show];
    NSLog(@"%@", [error description]);

}



/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    [recorder pause];
}

/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
        [recorder record];
}


#pragma mark - buttion action 
-(void)actionSelectGallery:(id)aidSender {
   
    
    UIImagePickerController* cImagePickerCtrl = [[UIImagePickerController alloc] init];
    cImagePickerCtrl.mediaTypes = @[((__bridge NSString*)kUTTypeImage)];
    cImagePickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    cImagePickerCtrl.delegate = self;
    [self presentViewController:cImagePickerCtrl animated:YES completion:^(void){
        
    }];
}
-(void)actionSelectCamera:(id)aidSender {
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
-(void)actionSelectVideoFile:(id)aidSender {
    
    UIImagePickerController* cImagePickerCtr = [[UIImagePickerController alloc] init];
    cImagePickerCtr.mediaTypes = @[(__bridge NSString*)kUTTypeMovie];
    cImagePickerCtr.allowsEditing = NO;
    cImagePickerCtr.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    cImagePickerCtr.delegate = self;
    [self presentViewController:cImagePickerCtr animated:YES completion:^(void){
    }];

}

-(void)actionSelectVideo:(id)aidSender {
    if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_error_camera", nil) message:NSLocalizedString(@"k_error_camera_not_availale", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
        return;
    }
    
    UIImagePickerController* cImagePickerCtr = [[UIImagePickerController alloc] init];
    cImagePickerCtr.mediaTypes = @[(__bridge NSString*)kUTTypeMovie];
    cImagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
    cImagePickerCtr.allowsEditing = YES;
    cImagePickerCtr.showsCameraControls = YES;
    cImagePickerCtr.delegate = self;
    [self presentViewController:cImagePickerCtr animated:YES completion:^(void){
    }];

}
-(void)actionSelectFolder:(id)aidSender {
    
}
-(void)actionSelectLocation:(id)aidSender {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"k_location_disabled", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
    }
    
    if (!self.cLocationManager) {
        self.cLocationManager = [[CLLocationManager alloc] init];
    }
    
    self.cLocationCurrent = self.cLocationManager.location;
    CLLocationCoordinate2D tLocationCoordinate = [self.cLocationCurrent coordinate];
    NSString* cstrLocation = [[NSString alloc] initWithFormat:@"%f,%f",tLocationCoordinate.latitude, tLocationCoordinate.longitude];
    NSLog(@"coordinate is %@", cstrLocation);
    
    NSData* cdataLocation = [[NSData alloc] initWithBytes:[cstrLocation UTF8String] length:[cstrLocation length]];
    [self sendData:cdataLocation toPeer:self.cdicPeerInfoTo[k_peer_id] withType:enum_package_type_location mediaUrl:[NSURL URLWithString:k_url_invliad]];
    
    if (![CLLocationManager significantLocationChangeMonitoringAvailable]) {
        UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"k_location_change_unavailable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
        [cAlertMsg show];
        return;
    }
    [self.cLocationManager startMonitoringSignificantLocationChanges];
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^(void){
//        NSLog(@"%@", [info description]);
        /*
         "k_cancel" = "取消";
         "k_ok" = "确定";
         "k_rename_file" = "保存文件名字";
         */
        NSData* cdataPicture = nil;
        
        
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString*)kUTTypeImage]) {
            UIImage* cimageEditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
            if (cimageEditedImage) {
                cdataPicture = UIImageJPEGRepresentation(cimageEditedImage, 0.5f);
            }else {
                UIImage* cimageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
                cdataPicture = UIImageJPEGRepresentation(cimageOriginal, 0.5f);
            }
            NSURL* curlImage = [info objectForKey:UIImagePickerControllerMediaURL];

            /*
             NSString* cstrFileName = nil;
            NSTimeInterval iInterval = [[NSDate date] timeIntervalSince1970];
            cstrFileName = [NSString stringWithFormat:@"%f.jpg", iInterval];
            
            NSString* cstrMediaURl = [NSTemporaryDirectory() stringByAppendingPathComponent:cstrFileName];
            [cdataPicture writeToURL:[NSURL fileURLWithPath:cstrMediaURl] atomically:YES];

//            [self sendMedia:[NSURL fileURLWithPath:cstrMediaURl] toPeer:self.cdicPeerInfoTo[k_peer_id] withType:enum_package_type_image];
             */

            [self sendData:cdataPicture toPeer:self.cdicPeerInfoTo[k_peer_id] withType:enum_package_type_image mediaUrl:curlImage];
            
            NSLog(@"picture");
        }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString*)kUTTypeMovie]) {
            NSLog(@"movei");
            NSURL* curlMovie = [info objectForKey:UIImagePickerControllerMediaURL];
            
             NSString* cstrFileName = nil;
            NSTimeInterval iInterval = [[NSDate date] timeIntervalSince1970];
            cstrFileName = [NSString stringWithFormat:@"%f.mov", iInterval];
            NSString* cstrMediaURl = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", cstrFileName];
            NSError* cError = nil;
            [[NSFileManager defaultManager] copyItemAtURL:curlMovie toURL:[NSURL fileURLWithPath:cstrMediaURl] error:&cError];
            if (!cError) {
//                [self sendMedia:[NSURL fileURLWithPath:cstrMediaURl] toPeer:self.cdicPeerInfoTo[k_peer_id] withType:enum_package_type_video];
                NSData* cdataMovie = [[NSData alloc] initWithContentsOfURL:curlMovie];
                [self sendData:cdataMovie toPeer:self.cdicPeerInfoTo[k_peer_id] withType:enum_package_type_video mediaUrl:[NSURL fileURLWithPath:cstrMediaURl]];
                
            }else {
                UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"k_save_file_failure", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
                [cAlertMsg show];
            }
            
        }
        
    }];
    
}

-(void)sendMedia:(NSURL*)aUrlMedia toPeer:(MCPeerID*)acPeerId withType:(T_PACKAGE_TYPE)atPackageType  {
    
    NSString* cstrFileName = [[aUrlMedia absoluteString] lastPathComponent];
    
    [self showProgressView];

    self.cProgressSending = [self.cMulPeerSession sendResourceAtURL:aUrlMedia withName:cstrFileName toPeer:acPeerId withCompletionHandler:^(NSError* acError){
        if (acError) {
            UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"k_save_file_failure", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
            [cAlertMsg show];
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self dismissProgressView];
            });
        }
    }];
    [self.cProgressSending addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}

-(void)dismissProgressView {
    [self.ctProgressView hide:YES];
}

-(void)showProgressView {
    if (![[NSThread currentThread] isMainThread]) {
        
        UIWindow* cwindowApp = [[UIApplication sharedApplication] keyWindow];
        self.ctProgressView = [[MBProgressHUD alloc] initWithWindow:cwindowApp];
        CGSize sSizeHud =  [self.ctProgressView  sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame) * 0.6f, 200.0f)];
        CGRect srectProgressView = CGRectMake((CGRectGetWidth(self.view.frame) - sSizeHud.width) * 0.5f, 180.0f, sSizeHud.width, sSizeHud.height);

        self.ctProgressView.frame = srectProgressView;
        self.ctProgressView.mode = MBProgressHUDModeDeterminate;
        self.ctProgressView.animationType = MBProgressHUDAnimationZoomIn;
        self.ctProgressView.removeFromSuperViewOnHide = YES;
        [cwindowApp addSubview:self.ctProgressView];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIWindow* cwindowApp = [[UIApplication sharedApplication] keyWindow];
        self.ctProgressView = [[MBProgressHUD alloc] initWithWindow:cwindowApp];
        CGSize sSizeHud = CGSizeMake(180.0f, 200.0f);
        CGRect srectProgressView = CGRectMake((CGRectGetWidth(self.view.frame) - sSizeHud.width) * 0.5f, 180.0f, sSizeHud.width, sSizeHud.height);
        self.ctProgressView.frame = srectProgressView;
        
        self.ctProgressView.mode = MBProgressHUDModeDeterminate;
        self.ctProgressView.animationType = MBProgressHUDAnimationZoomIn;
        self.ctProgressView.removeFromSuperViewOnHide = YES;
        [self.ctProgressView sizeToFit];
        [cwindowApp addSubview:self.ctProgressView];
        
    
    });
}

-(void)sendData:(NSData*)aData toPeer:(MCPeerID*)acPeerId withType:(T_PACKAGE_TYPE)atPackageType mediaUrl:(NSURL*)acMediaUrl{
    
     /*
     "k_sending_video_begin" = "Sending video file begin!";
     "k_sending_video_end" = "Sending video Finished!";
     
     "k_sending_image_begin" = "Sending image file begin!";
     "k_sending_image_end" = "Sending image Finished!";
     
     "k_sending_file_size" = "Size:";
    
    
    UIWindow* cwindowKey = [[UIApplication sharedApplication] keyWindow];
    self.ctProgressView = (MBProgressHUD*)[cwindowKey viewWithTag:k_tag_progress_view_chat];
    if (!self.ctProgressView) {
        self.ctProgressView = [[MBProgressHUD alloc] initWithWindow:cwindowKey];
         self.ctProgressView.removeFromSuperViewOnHide = YES;
         self.ctProgressView.tag = k_tag_progress_view_chat;
         self.ctProgressView.mode = MBProgressHUDModeDeterminate;
         self.ctProgressView.progress = 0.01f;
        CGSize sSizeHud =  [ self.ctProgressView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame) * 0.6f, 200.0f)];
         self.ctProgressView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - sSizeHud.width) * 0.5f, 180.0f, sSizeHud.width, sSizeHud.height);
    }
    
    
    CGFloat fSize = [aData length] / (CGFloat)(1024  * 1024);
    switch (atPackageType) {
        case enum_package_type_image:
            self.ctProgressView.labelText = NSLocalizedString(@"k_sending_image_begin", nil);
            self.ctProgressView.detailsLabelText = [NSString stringWithFormat:@"%@ %0.2fM", NSLocalizedString(@"", nil), fSize];

            break;
        case enum_package_type_video:
            self.ctProgressView.labelText = NSLocalizedString(@"k_sending_video_begin", nil);
            
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [cwindowKey addSubview:self.ctProgressView];
    });
    */
    u_int32_t uiLength = (u_int32_t)[aData length];
    u_int32_t uiOffset = 1024 * 512;
    u_int32_t uiLoopCount = uiLength / uiOffset;
    u_int32_t uiRemainder = uiLength % uiOffset;

    u_int32_t uiLoop = 0;
    NSMutableData* cmutdata = [[NSMutableData alloc] init];
    NSError* cError = nil;
    BOOL bSendFlag = YES;
    for (; uiLoop < uiLoopCount ;  uiLoop ++) {
        [cmutdata setLength:0];
        T_PACKAGE_HEADER tPackageHeader;
        tPackageHeader._u_l_current_offset = uiLoop * uiOffset;
        tPackageHeader._u_l_package_length = uiOffset;
        tPackageHeader._u_l_package_size = uiLength;
        tPackageHeader._u_l_package_type = atPackageType;
        
        NSData* cdataHeader = [NSData dataWithBytes:&tPackageHeader length:sizeof(tPackageHeader)];

        [cmutdata appendData:cdataHeader];
        [cmutdata appendData:[aData subdataWithRange:NSMakeRange(tPackageHeader._u_l_current_offset, tPackageHeader._u_l_package_length)]];
        
        bSendFlag = [self.cMulPeerSession sendData:cmutdata toPeers:@[acPeerId] withMode:MCSessionSendDataReliable error:&cError];
        if (cError) {
            NSLog(@"%@", [cError description]);
            break;
        }
        CGFloat fProgress = (tPackageHeader._u_l_current_offset + tPackageHeader._u_l_package_length) / (CGFloat)uiLength;
        NSLog(@"percent is %.2f", fProgress);
        self.ctProgressView.progress = fProgress;
        
    }
    if(uiRemainder > 0 && bSendFlag){
        [cmutdata setLength:0];
        T_PACKAGE_HEADER tPackageHeader;
        tPackageHeader._u_l_current_offset = uiLoop * uiOffset;
        tPackageHeader._u_l_package_length = uiRemainder;
        tPackageHeader._u_l_package_size = uiLength;
        tPackageHeader._u_l_package_type = atPackageType;
        NSData* cdataHeader = [NSData dataWithBytes:&tPackageHeader length:sizeof(tPackageHeader)];
        [cmutdata appendData:cdataHeader];

        [cmutdata appendData:[aData subdataWithRange:NSMakeRange(tPackageHeader._u_l_current_offset, tPackageHeader._u_l_package_length)]];
        NSLog(@"percent is %.2f", (tPackageHeader._u_l_current_offset + tPackageHeader._u_l_package_length) / (CGFloat)uiLength);
        [self.cMulPeerSession sendData:cmutdata toPeers:@[acPeerId] withMode:MCSessionSendDataReliable error:&cError];
        if (cError) {
            NSLog(@"%@", [cError description]);
            self.ctProgressView.labelText = NSLocalizedString(@"k_session_error", nil);

        }
        
    }
    
    NSMutableDictionary* cmutdicItem = nil;
    NSDate* cdateNow = [NSDate date];

    switch (atPackageType) {
        case enum_package_type_image:
            self.ctProgressView.labelText = NSLocalizedString(@"k_sending_image_end", nil);
            cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, aData, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date, @(enum_package_type_image), k_chat_msg_type, [acMediaUrl absoluteString], k_chat_msg_media_url, nil];
            break;
        case enum_package_type_video:
            self.ctProgressView.labelText = NSLocalizedString(@"k_sending_video_end", nil);
            cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, aData, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date, @(enum_package_type_video), k_chat_msg_type, [acMediaUrl absoluteString], k_chat_msg_media_url,nil];
            
        case enum_package_type_location:
            self.ctProgressView.labelText = NSLocalizedString(@"k_sending_video_end", nil);
            cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, aData, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date, @(enum_package_type_location), k_chat_msg_type, [acMediaUrl absoluteString], k_chat_msg_media_url,nil];

            break;
        default:
            break;
    }


    
    [self.cmutarrChatList addObject:cmutdicItem];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.ctableViewChat reloadData];
        [self scrollChatToBottom];
    });

  
    
    [self.ctProgressView hide:YES afterDelay:0.1f];

    
}

#pragma mark - chat callback 
-(void)didRequestPlayerVideo:(NSDictionary*)acdicInfo {
    MPMoviePlayerViewController* cMoviePlayerViewCtrl = nil;;
    NSLog(@"-----%@", acdicInfo[k_chat_msg_media_url]);
    NSURL* curl = [NSURL URLWithString:acdicInfo[k_chat_msg_media_url]];
    cMoviePlayerViewCtrl = [[MPMoviePlayerViewController alloc] initWithContentURL:curl];
    [[cMoviePlayerViewCtrl moviePlayer] play];
    [self presentMoviePlayerViewControllerAnimated:cMoviePlayerViewCtrl];
}
-(void)didRequestShowImage:(NSDictionary*)acdicInfo {
    
}
-(void)didRequestShowLocation:(NSDictionary *)acdicInfo {
    
    DLMapViewCtrl* ccMapViewCtrl = [[DLMapViewCtrl alloc] init];
    ccMapViewCtrl.cdicInfo = acdicInfo;
    ccMapViewCtrl.tLocationCoordinate2d = self.cLocationCurrent.coordinate;
    [self.navigationController pushViewController:ccMapViewCtrl animated:YES];
    
}
#pragma mark - location manager 
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.cLocationCurrent = [locations lastObject];
}
-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
}
-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"k_location_invalid", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"k_ok", nil) otherButtonTitles:nil, nil];
    [cAlertMsg show];
}
-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
}

@end
