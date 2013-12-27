//
//  DLChatTableViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLViewChatInput.h"
@class MCSession;
@class DLViewMore;
@interface DLChatTableViewCtrl : UIViewController<UITableViewDelegate, UITableViewDataSource, DLViewChatInputProto>{
    
}
@property(strong, nonatomic) UITableView* ctableViewChat;
@property(strong, nonatomic) NSMutableArray* cmutarrChatList;
@property(strong, nonatomic) NSDictionary* cdicPeerInfoTo;
@property(strong, nonatomic) NSDictionary* cdicPeerInfoFrom;

@property(strong, nonatomic) DLViewChatInput* ccViewChatInput;
@property(strong, nonatomic) MCSession* cMulPeerSession;
@property(strong, nonatomic) DLViewMore* ccViewMore;
@property(assign, nonatomic) BOOL bIsInputMode;
-(void)feedChatList:(NSArray*)acarrList;

-(void)dismissKeyBoard:(UITapGestureRecognizer*)acTapGes;

-(void)scrollChatToBottom;

@end
