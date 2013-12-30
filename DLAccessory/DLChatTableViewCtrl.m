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

@interface DLChatTableViewCtrl ()

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        CGFloat fHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.ccViewChatInput.frame);
        if( fHeight > k_height_keyboard) {
            return;
        }
        
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
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UITapGestureRecognizer* ctapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
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
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:nil];
}

-(void)didTextFrameChange:(DLViewChatInput*)accViewChatInput {
    
    CGRect srectFrameOrigin = accViewChatInput.frame;
    
    UIEdgeInsets sEdgeInset = [self.ccViewChatInput.ctextViewInput textContainerInset];
    UIEdgeInsets sEdgeInsetContent = [self.ccViewChatInput.ctextViewInput contentInset];

    
    
    CGRect srectFrameNew = CGRectMake(srectFrameOrigin.origin.x, CGRectGetMaxY(srectFrameOrigin) - (accViewChatInput.sRectBoundContent.size.height + sEdgeInset.top + sEdgeInset.bottom + 8.0f + sEdgeInsetContent.top + sEdgeInsetContent.bottom), srectFrameOrigin.size.width, accViewChatInput.sRectBoundContent.size.height + sEdgeInset.top + sEdgeInset.bottom + 8.0f + sEdgeInsetContent.top + sEdgeInsetContent.bottom);
                
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
            NSMutableDictionary* cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, cstrText, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date,nil];
            [self.cmutarrChatList addObject:cmutdicItem];
            [self.ctableViewChat reloadData];
            [self scrollChatToBottom];
        }
    }
}

-(void)didMorePressed:(DLViewChatInput*)accViewChatInput{
    
    if (!self.ccViewMore) {
        self.ccViewMore = [[DLViewMore alloc] initWithFrame: CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), k_height_keyboard)];
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
    if ([self.cmutarrChatList count] > 3) {
        NSIndexPath* cIndexPath = [NSIndexPath indexPathForRow: [self.cmutarrChatList count] - 1 inSection: 0];
        [self.ctableViewChat scrollToRowAtIndexPath: cIndexPath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
    
}

@end
