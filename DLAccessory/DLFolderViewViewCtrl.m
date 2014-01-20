//
//  DLFolderViewViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 12/17/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLFolderViewViewCtrl.h"
#import "DLMCConfig.h"
#import "TUTreeConfig.h"
#import "DLTableviewCellFolderMusic.h"
#import "DLTableviewCellFolderPicture.h"
#import "DLTableviewCellFolderMovie.h"
#import "DLTableViewCellFolderDirectory.h"
#import "DLTableViewCellFolder.h"
#import <CoreData/CoreData.h>
#import "FileItem.h"

@interface DLFolderViewViewCtrl () {
    dispatch_queue_t _dispatch_queue_scanning;
    enum_folder_cell_option _enum_folder_option;
}
-(void)deleteSelectedItem ;
-(void)saveSelectedItmIntoPhone;
-(void)initPersistentStore;
@end

@implementation DLFolderViewViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dispatch_queue_scanning = dispatch_queue_create("scanning", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPersistentStore];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = NSLocalizedString(@"k_folder_title", nil);
    
    
    __weak DLFolderViewViewCtrl* wccSelf = self;
    dispatch_async(_dispatch_queue_scanning, ^(void){
        
        NSString* cstrDocumentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        [wccSelf scanDirectory:cstrDocumentRoot withParentId:@(0) andDisplayLevel:@(0)];
        
        NSError* cErrorFetch = nil;
        NSPersistentStoreCoordinator* cPersistentStoreCoordinate = [self.cManagedObjectCtx persistentStoreCoordinator];
        NSArray* carrrAffectedStores = [cPersistentStoreCoordinate persistentStores];
        NSFetchRequest* cfetchRequst = [[NSFetchRequest alloc] initWithEntityName:k_table_file_item];
        NSSortDescriptor *cSortDesc = [[NSSortDescriptor alloc]
                                            initWithKey:@"file_created_date" ascending:NO];
        [cfetchRequst setSortDescriptors:@[cSortDesc]];
        
        [cfetchRequst setFetchOffset:0];
        [cfetchRequst setFetchLimit:10];
        [cfetchRequst setAffectedStores: carrrAffectedStores];
        NSArray* carrFiles = [self.cManagedObjectCtx executeFetchRequest:cfetchRequst error:&cErrorFetch];
        if (cErrorFetch) {
            NSLog(@"%@", [cErrorFetch description]);
        }else {
//            NSLog(@"----%@", [[carrFiles firstObject] description]);
            NSLog(@"fetched object count %d", [carrFiles count]);
            [self.cmutarrData addObjectsFromArray:carrFiles];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.cTableView reloadData];
        });
    });
}

-(void)initPersistentStore {
    NSLog(@"%@ %@", NSHomeDirectory(), [[NSPersistentStoreCoordinator registeredStoreTypes] description]);
    NSURL* curlModel = [[NSBundle mainBundle] URLForResource:@"Model.momd/init" withExtension:@"mom"];
    NSManagedObjectModel* cMoM = [[NSManagedObjectModel alloc] initWithContentsOfURL:curlModel];
    NSPersistentStoreCoordinator* cPersistentStoreCooridinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:cMoM];
    NSError* cErrorStore = nil;
    NSString* cstrSqlitePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/x.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cstrSqlitePath]) {
        
        [cPersistentStoreCooridinator setURL:[NSURL fileURLWithPath:cstrSqlitePath] forPersistentStore:[cPersistentStoreCooridinator persistentStoreForURL:[NSURL fileURLWithPath:cstrSqlitePath]]];
    }else {
       [cPersistentStoreCooridinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:cstrSqlitePath] options:nil error:&cErrorStore];
    }
    if (cErrorStore) {
        NSLog(@"%@", [cErrorStore description]);
    }

    
//    NSDictionary* cdicOpiton = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSReadOnlyPersistentStoreOption,nil];
    NSError* cError = nil;
    if (!cError) {
         self.cManagedObjectCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [self.cManagedObjectCtx setPersistentStoreCoordinator:cPersistentStoreCooridinator];
      
    }else {
        NSLog(@"init persistent store error : %@", [cError description]);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileItem* ccFileItem =[m_c_mut_arr_data objectAtIndex:[indexPath row]];
    NSString* cstrIdCell  = ccFileItem.cell_id;
    DLTableViewCellFolder *cell = [tableView dequeueReusableCellWithIdentifier:cstrIdCell forIndexPath:indexPath];
    if ([[cell gestureRecognizers] count] == 0) {
        UIPanGestureRecognizer* cPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionBeginEdit:)];
        [cell addGestureRecognizer:cPanGes];
        cPanGes.enabled = NO;
    }
    cell.idProtoFolderCell = self;
    cell.indentationLevel = [ccFileItem.level integerValue];
    [cell feedInfo:ccFileItem];
    //    NSLog(@"%@", [cdicItem description]);
    
//    cell.textLabel.text = cdicItem[k_content];
    
    return cell;
}


-(void)registerTableviewCells {
    [self.cTableView registerClass:[DLTableviewCellFolderMusic class] forCellReuseIdentifier:@"DLTableviewCellFolderMusic"];
    [self.cTableView registerClass:[DLTableviewCellFolderPicture class] forCellReuseIdentifier:@"DLTableviewCellFolderPicture"];
    [self.cTableView registerClass:[DLTableviewCellFolderMovie class] forCellReuseIdentifier:@"DLTableviewCellFolderMovie"];

    [self.cTableView registerClass:[DLTableViewCellFolder class] forCellReuseIdentifier:@"DLTableviewCellFolder"];
    [self.cTableView registerClass:[DLTableViewCellFolderDirectory class] forCellReuseIdentifier:@"DLTableViewCellFolderDirectory"];

}
-(void)scanDirectory:(NSString*)acstrDirectoryPath withParentId:(NSNumber*)acnumberParendId andDisplayLevel:(NSNumber*)acNumberDisplayLevel{
    @autoreleasepool {
        NSUInteger uiOrder = 0;
        NSFileManager* cfileManagerDefault = [NSFileManager defaultManager];
        //        NSError* cError = nil;
        NSDirectoryEnumerator* cDirEnumerator = [cfileManagerDefault enumeratorAtPath:acstrDirectoryPath];
        NSString* cstrItem = cDirEnumerator.nextObject;
        NSError* cError = nil;
        while (cstrItem) {
//            NSLog(@"%@", cstrItem);
            //get attributes
            @autoreleasepool {
            NSString* cstrFilePath = [acstrDirectoryPath stringByAppendingPathComponent:cstrItem];
            NSDictionary* cdicAttribute = [cfileManagerDefault attributesOfItemAtPath:cstrFilePath error:&cError];
            if (cError) {
                NSLog(@"can't read the file attribute:%@", cstrItem);
            }else {
                NSDictionary* cdicEntityNames = [[[self.cManagedObjectCtx persistentStoreCoordinator] managedObjectModel] entitiesByName];
//                NSLog(@"%@", [cdicEntityNames description]);
                NSEntityDescription* cEntityDescription = [cdicEntityNames objectForKey:k_table_file_item];
                
                 FileItem* ccFileItem = [[FileItem alloc] initWithEntity: cEntityDescription insertIntoManagedObjectContext:self.cManagedObjectCtx];
//                NSLog(@"%@", [cdicAttribute description]);
                NSNumber* cnumberFileNumber = [cdicAttribute objectForKey:NSFileSystemFileNumber];
                NSString* cstrFileType = [cdicAttribute objectForKey:NSFileType];
                __weak DLFolderViewViewCtrl* wccSelf = self;

//                NSMutableDictionary* cmutdicItem = [NSMutableDictionary dictionary];
                NSString* cstrItemLowcase = [cstrItem lowercaseString];

                if ([cstrFileType isEqualToString:NSFileTypeDirectory]) {
                    [wccSelf scanDirectory:cstrFilePath withParentId:acnumberParendId andDisplayLevel:[NSNumber numberWithInt:[acNumberDisplayLevel intValue] + 1]];
//                    [cmutdicItem setObject:k_cell_id_folder forKey:k_id_cell];
                    ccFileItem.cell_id = k_cell_id_folder;
                }else if ([cstrItemLowcase hasSuffix:@"jpg"] || [cstrItemLowcase hasSuffix:@"png"] || [cstrItemLowcase hasSuffix:@"jpeg"]) {
//                    [cmutdicItem setObject:k_cell_id_picture forKey:k_id_cell];
                    ccFileItem.cell_id = k_cell_id_picture;

                }else if([cstrItemLowcase hasSuffix:@"mov"]) {
//                    [cmutdicItem setObject:k_cell_id_movie forKey:k_id_cell];
                    ccFileItem.cell_id = k_cell_id_movie;
                }else if([cstrItemLowcase hasSuffix:@"mp3"] ||
                         [cstrItemLowcase hasSuffix:@"aac"] ||
                         [cstrItemLowcase hasSuffix:@"mp4"]) {
//                        [cmutdicItem setObject:k_cell_id_music forKey:k_id_cell];
                    ccFileItem.cell_id = k_cell_id_music;


                }else {
//                        [cmutdicItem setObject:k_cell_id_general forKey:k_id_cell];
                    ccFileItem.cell_id = k_cell_id_general;

                }
                NSNumber* cnumberFileSize = [cdicAttribute objectForKey:NSFileSize];
                NSDate* cdateCreated = [cdicAttribute objectForKey:NSFileCreationDate];
                /*
                [cmutdicItem setObject:cnumberFileSize forKey:k_file_size];
                [cmutdicItem setObject:cdateCreated forKey:k_file_created_date];
                [cmutdicItem setObject:cnumberFileNumber forKey:k_id];
                [cmutdicItem setObject:acnumberParendId forKey:k_parent_id];
                [cmutdicItem setObject:cstrItem forKey:k_content];
//                [cmutdicItem setObject:cdicAttribute forKey:k_file_attr];
                [cmutdicItem setObject:acNumberDisplayLevel forKey:k_level];
                [cmutdicItem setObject:@(uiOrder) forKey:k_order];
                [cmutdicItem setObject:cstrFilePath forKey:k_path];
//                [self.cmutarrData addObject:cmutdicItem];
                */
                uiOrder ++;

                ccFileItem.content = cstrItem;
                ccFileItem.file_id = cnumberFileNumber;
                ccFileItem.parent_id = acnumberParendId;
                ccFileItem.file_created_date = cdateCreated;
                ccFileItem.file_size = cnumberFileSize;
                ccFileItem.order = @(uiOrder);
                ccFileItem.path = cstrFilePath;
                ccFileItem.level = acNumberDisplayLevel;
                
                [self.cManagedObjectCtx assignObject:ccFileItem toPersistentStore:[[self.cManagedObjectCtx persistentStoreCoordinator].persistentStores firstObject]];
                [self.cManagedObjectCtx insertObject:ccFileItem];

//                if (ccFileItem.isInserted) {
//                    NSLog(@"insert success!");
//                }
            }
            cstrItem = cDirEnumerator.nextObject;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - cell action 

-(void)didSave2PhoneSelected:(DLTableViewCellFolder*)accFolderCell {
    self.ctableviewCellSelected = accFolderCell;
    _enum_folder_option = enum_folder_cell_option_save_to_phone;
    UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_save_to_phone", nil) message:NSLocalizedString(@"k_save_to_phone_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
    [cAlertMsg show];
}
-(void)didDeleteSelected:(DLTableViewCellFolder*)accFolderCell {
    _enum_folder_option = enum_folder_cell_option_delete;

    UIAlertView* cAlertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_delete_file", nil) message:NSLocalizedString(@"k_delete_file_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
    [cAlertMsg show];
    
    self.ctableviewCellSelected = accFolderCell;
   
    
}
-(void)deleteSelectedItem {
    NSLog(@"delete item");
    FileItem* ccFileItem = self.ctableviewCellSelected.ccFileItem;

    [self.cTableView beginUpdates];
    [self.cmutarrData removeObject:ccFileItem];
    NSIndexPath* cIndexPath = [self.cTableView indexPathForCell:self.ctableviewCellSelected];
    [self.cTableView deleteRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.cTableView endUpdates];
    self.ctableviewCellSelected = nil;
}
-(void)saveSelectedItmIntoPhone {
    FileItem* ccFileItem = self.ctableviewCellSelected.ccFileItem;
    NSLog(@"save to phone");
    self.ctableviewCellSelected = nil;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        switch (_enum_folder_option) {
            case enum_folder_cell_option_delete:
                [self deleteSelectedItem];
                break;
            default:
                [self saveSelectedItmIntoPhone];
                break;
        }
    }
    [alertView dismissWithClickedButtonIndex:0 animated:YES];

}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
