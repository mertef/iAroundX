//
//  FileItem.h
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FileItem : NSManagedObject

@property (nonatomic, retain) NSString * cell_id;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * file_created_date;
@property (nonatomic, retain) NSNumber * file_id;
@property (nonatomic, retain) NSNumber * file_size;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * parent_id;
@property (nonatomic, retain) NSString * path;

@end
