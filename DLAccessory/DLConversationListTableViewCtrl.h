//
//  DLConversationListTableViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLConversationListTableViewCtrl : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray* cmutarrConversations;
@property(strong, nonatomic) UITableView* ctableView;

-(void)actionNotiMsgReceive:(NSNotification*)acNoti;

@end
