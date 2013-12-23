//
//  DLChatTableViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLChatTableViewCtrl : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
}
@property(strong, nonatomic) NSMutableArray* cmutarrChatList;
@property(strong, nonatomic) NSDictionary* cdicPeerInfoTo;

@end
