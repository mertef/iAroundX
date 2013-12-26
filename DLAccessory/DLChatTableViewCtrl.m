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
            });
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didKeyBoardAppear:(NSNotification*)acNotifi {
    NSDictionary* cdicInfo = acNotifi.userInfo;
    
}

-(void)didKeyBoardHide:(NSNotification*)acNotifi {
    NSDictionary* cdicInfo = acNotifi.userInfo;
    
}


-(void)didKeyBoardFrameChange:(NSNotification*)acNotifi {
    NSDictionary* cdicInfo = acNotifi.userInfo;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyBoardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];

    
    self.title = NSLocalizedString(@"k_chat_room", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    _ctableViewChat = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40.0f)];
    _ctableViewChat.delegate =self;
    _ctableViewChat.dataSource = self;
    [self.view addSubview:_ctableViewChat];
    
    _ccViewChatInput = [[DLViewChatInput alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(_ctableViewChat.frame), CGRectGetWidth(self.view.bounds), 40.0f)];
    _ccViewChatInput.idProtoViewChat = self;
    [self.view addSubview:_ccViewChatInput];
    
     UIView* cviewBg = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 20.0f)];
    [cviewBg setBackgroundColor:[UIColor clearColor]];
    self.ctableViewChat.tableFooterView = cviewBg;
	// Do any additional setup after loading the view.
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
            NSDate* cdateNow = [NSDate date];
            NSMutableDictionary* cmutdicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.cdicPeerInfoTo[k_peer_id], k_chat_to, self.cdicPeerInfoFrom[k_peer_id], k_chat_from, cstrText, k_chat_msg, [NSNumber numberWithDouble:[cdateNow timeIntervalSince1970]], k_chat_date,nil];
            [self.cmutarrChatList addObject:cmutdicItem];
            [self.ctableViewChat reloadData];
            
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


@end
