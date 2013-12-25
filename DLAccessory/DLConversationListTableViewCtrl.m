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
@interface DLConversationListTableViewCtrl ()

@end

@implementation DLConversationListTableViewCtrl

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
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


@end
