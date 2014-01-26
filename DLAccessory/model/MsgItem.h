//
//  MsgItem.h
//  DLAccessory
//
//  Created by Mertef on 1/26/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MsgItem : NSManagedObject

@property (nonatomic, retain) NSNumber * msg_id;
@property (nonatomic, retain) NSString * chat_from;
@property (nonatomic, retain) NSString * chat_to;
@property (nonatomic, retain) NSData * chat_msg;
@property (nonatomic, retain) NSNumber * chat_msg_type;
@property (nonatomic, retain) NSNumber * chat_date;
@property (nonatomic, retain) NSString * chat_media_url;
@property (nonatomic, retain) NSNumber * chat_msg_finished;

@end
