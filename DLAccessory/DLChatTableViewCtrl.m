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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"k_chat_room", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    _ctableViewChat = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _ctableViewChat.delegate =self;
    _ctableViewChat.dataSource = self;
    [self.view addSubview:_ctableViewChat];

    _ccViewChatInput = [[DLViewChatInput alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 100.0f)];
    _ccViewChatInput.idProtoViewChat = self;
    self.ctableViewChat.tableFooterView = _ccViewChatInput;
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
        ccCellChat.cstrPeerFrom = [self.cdicPeerInfoTo objectForKey:k_peer_id_name];
    }
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
        }
    }
}

@end
