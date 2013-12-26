//
//  DLConversationListTableViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCSession;
@class MCPeerID;
@interface DLConversationListTableViewCtrl : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray* cmutarrConversations;
@property(strong, nonatomic) UITableView* ctableView;
@property(strong, nonatomic) MCSession* cSession;
@property(strong, nonatomic) MCPeerID* cpeerIdFrom;
-(void)actionNotiMsgReceive:(NSNotification*)acNoti;

@end
