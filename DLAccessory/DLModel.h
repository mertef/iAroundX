//
//  DLModel.h
//  DLAccessory
//
//  Created by Mertef on 1/26/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MsgItem;
@class MCPeerID;
@interface DLModel : NSObject
+(NSManagedObjectContext*)ManagedObjCtx;
+(void)SaveMsgItem:(NSDictionary*)acdicMsgItem;
+(NSMutableArray*)GetChatListFrom:(MCPeerID*)acPeerIdFrom to:(MCPeerID*)acPeerIdTo;
+(BOOL)DeleteMsgItemByMediaPath:(NSString*)acstrMediaPath;
@end
