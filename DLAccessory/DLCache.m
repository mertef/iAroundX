//
//  DLCache.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLCache.h"
@implementation DLCache
static DLCache* g_cc_cache = nil;

+(id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_cc_cache = [super allocWithZone:zone];
    });
    return g_cc_cache;
}
+(id)sharedInstance {
    if (!g_cc_cache) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            g_cc_cache = [ super alloc];
        });
    }else {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"<%@:%p> double allocation issue", [g_cc_cache class], g_cc_cache]  reason:@"your can't allocate the singleton class twice or more." userInfo:nil];
    }
    return g_cc_cache;
}
- (void)dealloc
{
    
}
+(id)alloc {
    @synchronized([DLCache class]){
        if (!g_cc_cache) {
            g_cc_cache = [super alloc];
        }else {
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"<%@:%p> double allocation issue", [g_cc_cache class], g_cc_cache]  reason:@"your can't allocate the singleton class twice or more." userInfo:nil];

        }
    }
    return g_cc_cache;
}

@end
