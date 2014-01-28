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
+(NSMutableArray*)GetChatListFrom:(MCPeerID*)acPeerIdFrom to:(MCPeerID*)acPeerIdTo {
    NSMutableArray* cmutArrlist = [[NSMutableArray alloc] init];
    NSManagedObjectContext* cmanagedObjCtx = [DLModel ManagedObjCtx];
//    NSPersistentStoreCoordinator* cPersistentStoreCoordinate = [cmanagedObjCtx persistentStoreCoordinator];
//    NSEntityDescription* centityDescription = [[[cPersistentStoreCoordinate managedObjectModel] entitiesByName] objectForKey:k_table_name_msg_item];
    NSError* cError = nil;
    NSFetchRequest* cfetchReq = [[NSFetchRequest alloc] initWithEntityName:k_table_name_msg_item];
    NSString* cstrFrom = [acPeerIdFrom displayName];
    NSString* cstrTo = [acPeerIdTo displayName];
    
    NSPredicate* cpredate = [NSPredicate predicateWithFormat:@"(%K = %@ and %K = %@)", k_chat_from, cstrFrom, k_chat_to, cstrTo];
    NSSortDescriptor* cSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:k_chat_date ascending:YES];
    cfetchReq.predicate = cpredate;
    cfetchReq.sortDescriptors = @[cSortDescriptor];
    
    NSArray* carrMsgs = [cmanagedObjCtx executeFetchRequest:cfetchReq error:&cError];
    if (cError) {
        NSLog(@"GetChatListFrom %@", [cError description]);
    }else {
        for (MsgItem* cmsgItem in carrMsgs) {
            NSMutableDictionary* cmutdicInfo = [[NSMutableDictionary alloc] init];
            [cmutdicInfo setObject:[[MCPeerID alloc] initWithDisplayName:cmsgItem.chat_from] forKey:k_chat_from];
            [cmutdicInfo setObject:[[MCPeerID alloc] initWithDisplayName:cmsgItem.chat_to] forKey:k_chat_to];
            [cmutdicInfo setObject:cmsgItem.chat_msg forKey:k_chat_msg];
            [cmutdicInfo setObject:cmsgItem.chat_msg_type forKey:k_chat_msg_type];
            [cmutdicInfo setObject:cmsgItem.chat_date forKey:k_chat_date];
            [cmutdicInfo setObject:cmsgItem.chat_media_url forKey:k_chat_msg_media_url];
            [cmutdicInfo setObject:cmsgItem.msg_id forKey:k_chat_msg_id];
            [cmutdicInfo setObject:cmsgItem.chat_msg_finished forKey:k_chat_msg_finished];

            [cmutArrlist addObject:cmutdicInfo];
        }
    }
    return cmutArrlist;
}

+(BOOL)DeleteMsgItemByMediaPath:(NSString*)acstrMediaPath {
    BOOL bFlag = YES;
    NSManagedObjectContext* cmanagedObjCtx = [DLModel ManagedObjCtx];
    //    NSPersistentStoreCoordinator* cPersistentStoreCoordinate = [cmanagedObjCtx persistentStoreCoordinator];
    //    NSEntityDescription* centityDescription = [[[cPersistentStoreCoordinate managedObjectModel] entitiesByName] objectForKey:k_table_name_msg_item];
    NSError* cError = nil;
    NSFetchRequest* cfetchReq = [[NSFetchRequest alloc] initWithEntityName:k_table_name_msg_item];
    NSPredicate* cpredate = [NSPredicate predicateWithFormat:@"(%K = %@)", @"chat_media_url", acstrMediaPath];
    cfetchReq.predicate = cpredate;
    NSArray* carrMsgs = [cmanagedObjCtx executeFetchRequest:cfetchReq error:&cError];
    if (cError) {
        NSLog(@"DeleteMsgItemByMediaPath %@", [cError description]);
        bFlag = NO;
    }else if([carrMsgs count] > 0){
        MsgItem* ccMsgItem = [carrMsgs firstObject];
        [cmanagedObjCtx deleteObject:ccMsgItem];
        if (ccMsgItem.isDeleted) {
            [cmanagedObjCtx save:&cError];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_msg_delete object:nil userInfo:@{k_obj_delete:ccMsgItem }];
            if (cError) {
                bFlag = NO;
            }
        }
        
    }

    return bFlag;
}


@end
