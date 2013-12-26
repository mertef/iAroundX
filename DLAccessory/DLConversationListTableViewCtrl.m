//
//  DLConversationListTableViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLConversationListTableViewCtrl.h"
#import "DLTableViewCellConversation.h"
#import "DLMCConfig.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLChatTableViewCtrl.h"

@interface DLConversationListTableViewCtrl ()

@end

@implementation DLConversationListTableViewCtrl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotiMsgReceive:) name:k_noti_chat_msg object:nil];
        self.cmutarrConversations = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)actionNotiMsgReceive:(NSNotification*)acNoti {
    
    MCPeerID* cpeerIdFrom =  [acNoti.userInfo objectForKey:k_chat_from];
    NSString* cstrPeerFrom = [cpeerIdFrom displayName];
    
    NSPredicate* cPredicateFrom = [NSPredicate predicateWithFormat:@"(%K == %@)", k_chat_from_name,cstrPeerFrom];
    NSArray* carrPeople = [self.cmutarrConversations filteredArrayUsingPredicate:cPredicateFrom];
    if (carrPeople && [carrPeople count] > 0) {
        NSMutableDictionary* cmutdicItem = [carrPeople firstObject];
        NSMutableArray* cmutarrChatLit = [cmutdicItem objectForKey:k_chat_list];
        [cmutarrChatLit addObject:acNoti.userInfo];
        [self.ctableView reloadData];
    }else {
        NSMutableDictionary* cmutDicConversation = [NSMutableDictionary dictionary];
        [cmutDicConversation setObject:cstrPeerFrom forKey:k_chat_from_name];
        [cmutDicConversation setObject:[NSMutableArray arrayWithObject:acNoti.userInfo] forKey:k_chat_list];
        [self.cmutarrConversations addObject:cmutDicConversation];
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
       
        [self.ctableView reloadData];
    });
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"k_conversation_title", nil);
    self.ctableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.ctableView.delegate = self;
    self.ctableView.dataSource = self;
    [self.view addSubview:self.ctableView];
    self.ctableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.ctableView.separatorColor = k_colore_gradient_blue;
    self.ctableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.ctableView.bounds), 2.0f)];
    self.ctableView.tableFooterView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cmutarrConversations count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cCell = [tableView dequeueReusableCellWithIdentifier:@"id_cell_conversation"];
    if (!cCell) {
        cCell = [[DLTableViewCellConversation alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id_cell_conversation"];
    }
    [(DLTableViewCellConversation*)cCell feedInfo:[self.cmutarrConversations objectAtIndex:[indexPath row]]];
    return cCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* cdicItem = [self.cmutarrConversations objectAtIndex:[indexPath row]];
    NSArray* carrList = [cdicItem objectForKey:k_chat_list];
    DLChatTableViewCtrl* ccTableViewCtrlChat = [[DLChatTableViewCtrl alloc] init];
    ccTableViewCtrlChat.cMulPeerSession = self.cSession;
    [ccTableViewCtrlChat feedChatList:carrList];        
    [self.navigationController pushViewController:ccTableViewCtrlChat animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSDictionary* cdicItem = [self.cmutarrConversations objectAtIndex:[indexPath row]];
            NSArray* carrList = [cdicItem objectForKey:k_chat_list];
            NSUInteger iUnreadMsgCount = [carrList count];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_chat_msg_decrease object:nil userInfo:@{k_msg_cout:@(iUnreadMsgCount)}];
                                      
            [self.cmutarrConversations removeObject:[self.cmutarrConversations objectAtIndex:[indexPath row]]];
            [tableView endUpdates];
        }
            break;
            
        default:
            break;
    }
}

@end
