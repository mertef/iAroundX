//
//  DLCache.h
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLCache : NSCache
+(id)sharedInstance;
+(instancetype)new __attribute__((unavailable("new not available")));
+(instancetype) alloc __attribute__((unavailable("new not available")));
+(instancetype) init __attribute__((unavailable("new not available")));
@end
