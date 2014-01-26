//
//  DLModel.m
//  DLAccessory
//
//  Created by Mertef on 1/26/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLModel.h"
#import <CoreData/CoreData.h>
#import "DLMCConfig.h"
#import "MsgItem.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DLModel()
+(void)initPersistentStore;
@end
@implementation DLModel

static NSManagedObjectContext* g_c_managed_obj_ctx = nil;
+(void)initPersistentStore {
    NSLog(@"%@ %@", NSHomeDirectory(), [[NSPersistentStoreCoordinator registeredStoreTypes] description]);
    NSURL* curlModel = [[NSBundle mainBundle] URLForResource:@"Model.momd/init" withExtension:@"mom"];
    NSManagedObjectModel* cMoM = [[NSManagedObjectModel alloc] initWithContentsOfURL:curlModel];
    NSPersistentStoreCoordinator* cPersistentStoreCooridinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:cMoM];
    NSError* cErrorStore = nil;
    NSString* cstrSqlitePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/%@", db_name];
    //    NSString* cstrBinaryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/x.binary"];
    
    [cPersistentStoreCooridinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:cstrSqlitePath] options:@{NSSQLitePragmasOption: @{@"journal_mode": @"delete"}}   error:&cErrorStore];
    //    [cPersistentStoreCooridinator addPersistentStoreWithType:NSBinaryStoreType configuration:nil URL:[NSURL fileURLWithPath:cstrBinaryPath] options:nil error:&cErrorStore];
    
    if (cErrorStore) {
        NSLog(@"%@", [cErrorStore description]);
    }
    NSError* cError = nil;
    if (!cError) {
        if (!g_c_managed_obj_ctx) {
            g_c_managed_obj_ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
            [g_c_managed_obj_ctx setPersistentStoreCoordinator:cPersistentStoreCooridinator];
        }
    }else {
        NSLog(@"init persistent store error : %@", [cError description]);
    }
}
+(NSManagedObjectContext*)ManagedObjCtx {
    if (!g_c_managed_obj_ctx) {
        [DLModel initPersistentStore];
    }
    return g_c_managed_obj_ctx;
}

+(void)SaveMsgItem:(NSDictionary*)acdicMsgItem {
    /*
     @{k_chat_from:peerID,
     k_chat_to:self.cpeerId,
     k_chat_msg:cmutData,
     k_chat_msg_type:@(puPackage->_u_l_package_type),
     k_chat_date: @([[NSDate date] timeIntervalSince1970]),
     k_chat_msg_media_url:cstrMediaUrl,
     k_chat_msg_id:@(puPackage->_u_l_msg_id),
     k_chat_msg_finished:@(puPackage->_i8_msg_finished)
     };
     */
    NSManagedObjectContext* cmanagedObjCtx = [DLModel ManagedObjCtx];
    NSPersistentStoreCoordinator* cPersistentStoreCoordinate = [cmanagedObjCtx persistentStoreCoordinator];
    NSEntityDescription* centityDescription = [[[cPersistentStoreCoordinate managedObjectModel] entitiesByName] objectForKey:k_table_name_msg_item];
    MsgItem* ccMsgItem = [[MsgItem alloc] initWithEntity:centityDescription insertIntoManagedObjectContext:cmanagedObjCtx];
    MCPeerID* cpeerIdFrom = [acdicMsgItem objectForKey:k_chat_from];
    MCPeerID* cpeerIdTo = [acdicMsgItem objectForKey:k_chat_to];

    ccMsgItem.chat_from = [cpeerIdFrom displayName];
    ccMsgItem.chat_to = [cpeerIdTo displayName];
    ccMsgItem.chat_msg = [acdicMsgItem objectForKey:k_chat_msg];
    ccMsgItem.chat_msg_type = [acdicMsgItem objectForKey:k_chat_msg_type];
    ccMsgItem.chat_date = [acdicMsgItem objectForKey:k_chat_date];
    ccMsgItem.chat_media_url = [acdicMsgItem objectForKey:k_chat_msg_media_url];
    ccMsgItem.msg_id = [acdicMsgItem objectForKey:k_chat_msg_id];
    ccMsgItem.chat_msg_finished = [acdicMsgItem objectForKey:k_chat_msg_finished];
    NSError* cErrorSave = nil;
    [cmanagedObjCtx insertObject:ccMsgItem];
    if (ccMsgItem.isInserted) {
        [cmanagedObjCtx save:&cErrorSave];
    }
    if (cErrorSave) {
        NSLog(@"save error msg %lu", [ccMsgItem.msg_id longValue]);
    }

    
}

@end
