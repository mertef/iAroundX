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
#import "DLPage.h"
#import "DLViewTableFooterMore.h"
#import "DLViewTableHeader.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DLZoomableImageView.h"
#import "CSAnimation.h"

@interface DLFolderViewViewCtrl () {
    dispatch_queue_t _dispatch_queue_scanning;
    enum_folder_cell_option _enum_folder_option;
    BOOL _b_enable_scroll;
    FileItem* _cc_file_item_selected;
    CGRect _s_rect_selcted;
}
-(void)deleteSelectedItem ;
-(void)saveSelectedItmIntoPhone;
-(void)initPersistentStore;
-(void)fetchDataFromOffset:(NSUInteger)auiFrom withLimit:(NSUInteger)auiLimit;
-(void)syncFolder;
-(void)scanningFolder;
-(void)actionScan;
-(void)addUIPage;
-(void)enableScroll:(BOOL)abFlag;
@end

@implementation DLFolderViewViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dispatch_queue_scanning = dispatch_queue_create("scanning", DISPATCH_QUEUE_SERIAL);
        self.ccPage = [[DLPage alloc] init];
        [self.ccPage reset];
        _b_enable_scroll = NO;
    }
    return self;
}

-(void)fetchDataFromOffset:(NSUInteger)auiFrom withLimit:(NSUInteger)auiLimit {
    NSError* cErrorFetch = nil;
    NSPersistentStoreCoordinator* cPersistentStoreCoordinate = [self.cManagedObjectCtx persistentStoreCoordinator];
    NSArray* carrrAffectedStores = [cPersistentStoreCoordinate persistentStores];
    self.ccPage.uiLimit = auiLimit;
    if (!self.ccPage.uiCount) {
        NSFetchRequest* cfetchRequstCount = [[NSFetchRequest alloc] initWithEntityName:k_table_file_item];
        self.ccPage.uiCount = [self.cManagedObjectCtx countForFetchRequest:cfetchRequstCount error:&cErrorFetch];
        NSLog(@"fetched object count %lu", self.ccPage.uiCount);
    }
    NSFetchRequest* cfetchRequst = [[NSFetchRequest alloc] initWithEntityName:k_table_file_item];
    NSSortDescriptor *cSortDesc0 = [[NSSortDescriptor alloc]
                                   initWithKey:@"order" ascending:NO];
    NSSortDescriptor *cSortDesc = [[NSSortDescriptor alloc]
                                   initWithKey:@"file_created_date" ascending:NO];
    NSPredicate* cpredicate = [NSPredicate predicateWithFormat:@"%K != %@", @"content",k_ds_store];
    [cfetchRequst setPredicate:cpredicate];
    [cfetchRequst setSortDescriptors:@[cSortDesc0,cSortDesc]];
    
    [cfetchRequst setFetchOffset:self.ccPage.uiOffset];
    [cfetchRequst setFetchLimit:self.ccPage.uiLimit];
    [cfetchRequst setAffectedStores: @[carrrAffectedStores.lastObject]];
    NSArray* carrFiles = [self.cManagedObjectCtx executeFetchRequest:cfetchRequst error:&cErrorFetch];
    if (cErrorFetch) {
        NSLog(@"%@", [cErrorFetch description]);
    }else {
        //            NSLog(@"----%@", [[carrFiles firstObject] description]);
        self.ccPage.uiOffset += [carrFiles count];
        [self.cmutarrData addObjectsFromArray:carrFiles];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.cTableView reloadData];
        });
    }
}
-(void)syncFolder {
    NSString* cstrSqlitePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/%@", db_name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cstrSqlitePath]) {
        [self fetchDataFromOffset:0 withLimit:10];
    }else {
        __weak DLFolderViewViewCtrl* wccSelf = self;
        dispatch_async(_dispatch_queue_scanning, ^(void){
            
            NSString* cstrDocumentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            [wccSelf scanDirectory:cstrDocumentRoot withParentId:@(0) andDisplayLevel:@(0)];
            NSError* cError = nil;
            [self.cManagedObjectCtx save:&cError];
            if (cError) {
                NSLog(@"save changed to the persistent store error %@", [cError description]);
            }else {
                [self fetchDataFromOffset:0 withLimit:10];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.cTableView reloadData];
                    [self.view setNeedsLayout];
                });
            }
            
        });
    }
}
-(void)scanningFolder {
    __weak DLFolderViewViewCtrl* wccSelf = self;
    [self.view addSubview:self.ctProgressHud];
    [self.ctProgressHud show:YES];
    self.idObjectSelected = nil;
    dispatch_async(_dispatch_queue_scanning, ^(void){
        
        NSString* cstrDocumentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        [wccSelf scanDirectory:cstrDocumentRoot withParentId:@(0) andDisplayLevel:@(0)];
        NSError* cErrorDelete = nil;
        for (NSManagedObject* cmanagedObj in self.cmutarrData) {
            [self.cManagedObjectCtx delete:cmanagedObj];
            [self.cManagedObjectCtx save:&cErrorDelete];
            if (cErrorDelete) {
                NSLog(@"%@", [cErrorDelete description]);
            }
        }
        [self.cmutarrData removeAllObjects];
        [self.ccPage reset];
        [self fetchDataFromOffset:0 withLimit:141];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.cTableView reloadData];
            self.cTableView.userInteractionEnabled = YES;
            [self.ctProgressHud hide:YES];
        });
        
    });
}

-(void)addUIPage {

    CGRect srectFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.cTableView.frame), 44.0f);

    self.ccTableFooterMore = [[DLViewTableFooterMore alloc] initWithReuseIdentifier:@"id_footer_more"];
    self.ccTableFooterMore.frame = srectFrame;
    [self.ccTableFooterMore.cbtnMore addTarget:self action:@selector(actionLoadMore:) forControlEvents:UIControlEventTouchUpInside];
    self.cTableView.tableFooterView  = self.ccTableFooterMore;
    
    CGRect srectFrameHeader = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.cTableView.frame), 44.0f);
    
    
    self.ccTableHeaderMore = [[DLViewTableHeader alloc] initWithReuseIdentifier:@"id_header_more"];
    [self.ccTableHeaderMore.cbtnCreateFolder addTarget:self action:@selector(actionCreateFolder:) forControlEvents:UIControlEventTouchUpInside];
    [self.ccTableHeaderMore.cbtnEditOrder addTarget:self action:@selector(actionReOrderFolder:) forControlEvents:UIControlEventTouchUpInside];
    [self.ccTableHeaderMore.cbtnReScan addTarget:self action:@selector(actionRescanFolder:) forControlEvents:UIControlEventTouchUpInside];

    self.ccTableHeaderMore.frame = srectFrameHeader;

    self.ctProgressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.ctProgressHud.removeFromSuperViewOnHide = YES;
    self.ctProgressHud.mode = MBProgressHUDModeIndeterminate;

}
-(void)actionCreateFolder:(id)aidSender {
    _enum_folder_option = enum_folder_cell_option_create_dir;
    UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_create_new_folder", nil) message:NSLocalizedString(@"k_sure_create_folder_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
    [calertMsg show];
}
-(void)createFolder {
    NSFileManager* cfileMangerDefault = [NSFileManager defaultManager];
    NSError* cError = nil;
    [cfileMangerDefault createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xx"] withIntermediateDirectories:YES attributes:nil error:&cError];
    if (cError) {
        NSLog(@"%@", [cError description]);
    }
}

-(void)enableScroll:(BOOL)abFlag {
    NSArray* carrVisibleCells = [self.cTableView visibleCells];
    for (UITableViewCell* cellItem in carrVisibleCells) {
        [[cellItem gestureRecognizers].firstObject setEnabled:abFlag];
    }
}
-(void)actionReOrderFolder:(id)aidSender {
    _b_enable_scroll = !_b_enable_scroll;
    UIButton* cbtnSender = (UIButton*)aidSender;
    Class tBounceMeta = [CSAnimation classForAnimationType:CSAnimationTypeShake];
    [tBounceMeta performAnimationOnView:cbtnSender duration:1.0f delay:0.0f];
    
    UIButton* cbtn = (UIButton*)aidSender;
    if (_b_enable_scroll) {
        [self enableScroll:YES];
        self.cTableView.scrollEnabled =  NO;
        cbtn.selected = YES;
    }else {
        [self enableScroll:NO];
        self.cTableView.scrollEnabled =  YES;
        cbtn.selected = NO;
    }
}
-(void)actionRescanFolder:(id)aidSender {
    _enum_folder_option = enum_folder_cell_option_rescanning;
   
    UIAlertView* calertMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"k_rescanning_folder", nil) message:NSLocalizedString(@"k_sure_rescan_folder_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) otherButtonTitles:NSLocalizedString(@"k_ok", nil), nil];
    [calertMsg show];
  

}

-(void)actionLoadMore:(id)aidSender {
    [self fetchDataFromOffset:_ccPage.uiOffset withLimit:_ccPage.uiLimit];
}

-(void)actionScan {
    self.cTableView.userInteractionEnabled = NO;
    _cc_file_item_selected = nil;
    _s_rect_selcted = CGRectZero;
    [self scanningFolder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addUIPage];
    [self initPersistentStore];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = NSLocalizedString(@"k_folder_title", nil);
    
    [self scanningFolder];
    
    self.cactionSheetOption = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"k_view", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"k_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"k_view_opiton", nil), nil];
    
        /*
    self.crefreshCtrl = [[UIRefreshControl alloc] init];
    CGRect srectRefresh = self.crefreshCtrl.frame;
    srectRefresh.origin.y -= srectRefresh.size.height;
    self.crefreshCtrl.frame = srectRefresh;
    NSLog(@"---%@", NSStringFromCGRect(self.crefreshCtrl.frame));
    [self.cTableView addSubview:self.crefreshCtrl];
     */
//    self.cTableView.tableHeaderView = self.crefreshCtrl;
//    [self syncFolder];
   
}

-(void)initPersistentStore {
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
         self.cManagedObjectCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [self.cManagedObjectCtx setPersistentStoreCoordinator:cPersistentStoreCooridinator];
      
    }else {
        NSLog(@"init persistent store error : %@", [cError description]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.ccTableHeaderMore;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileItem* ccFileItem =  [self.cmutarrData objectAtIndex:[indexPath row]];
    NSLog(@"indent level is %l", [ccFileItem.level longValue]);
    return [ccFileItem.level unsignedLongValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileItem* ccFileItem =[m_c_mut_arr_data objectAtIndex:[indexPath row]];
    NSString* cstrIdCell  = ccFileItem.cell_id;
    DLTableViewCellFolder *cell = [tableView dequeueReusableCellWithIdentifier:cstrIdCell];
    
    if (!cell) {
        cell = (DLTableViewCellFolder*)[[NSClassFromString(cstrIdCell) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cstrIdCell];
        UIPanGestureRecognizer* cPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionBeginEdit:)];
        [cell addGestureRecognizer:cPanGes];
        cell.idProtoFolderCell = self;
        cPanGes.enabled = NO;

    }
    cell.indentationLevel = [ccFileItem.level integerValue];
    if ([ccFileItem isEqual:self.idObjectSelected]) {
        [cell selectCell:YES];
    }else {
        [cell selectCell:NO];
    }
    [cell feedInfo:ccFileItem];
    return cell;
}



-(void)registerTableviewCells {
    
    /*
    [self.cTableView registerClass:[DLTableviewCellFolderMusic class] forCellReuseIdentifier:@"DLTableviewCellFolderMusic"];
    [self.cTableView registerClass:[DLTableviewCellFolderPicture class] forCellReuseIdentifier:@"DLTableviewCellFolderPicture"];
    [self.cTableView registerClass:[DLTableviewCellFolderMovie class] forCellReuseIdentifier:@"DLTableviewCellFolderMovie"];

    [self.cTableView registerClass:[DLTableViewCellFolder class] forCellReuseIdentifier:@"DLTableviewCellFolder"];
    [self.cTableView registerClass:[DLTableViewCellFolderDirectory class] forCellReuseIdentifier:@"DLTableViewCellFolderDirectory"];
    
    
    [self.cTableView registerClass:[DLViewTableFooterMore class] forHeaderFooterViewReuseIdentifier:@"DLViewTableFooterMore"];
    [self.cTableView registerClass:[DLViewTableFooterMore class] forHeaderFooterViewReuseIdentifier:@"DLViewTableHeader"];
   */


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
            [self.ctProgressHud setLabelText:cstrItem];
            //get attributes
            @autoreleasepool {
                NSString* cstrFilePath = [acstrDirectoryPath stringByAppendingPathComponent:cstrItem];
                NSLog(@"---%@", cstrFilePath);
                NSDictionary* cdicAttribute = [cfileManagerDefault attributesOfItemAtPath:cstrFilePath error:&cError];
                NSNumber* cnumberFileNumber = [cdicAttribute objectForKey:NSFileSystemFileNumber];
                NSFetchRequest* cFetchReqExist = [[NSFetchRequest alloc] initWithEntityName:k_table_file_item];
                NSPredicate* cpredicateExist = [NSPredicate predicateWithFormat:@"%K == %ld", @"file_id", [cnumberFileNumber longValue]];
                [cFetchReqExist setPredicate:cpredicateExist];
                NSUInteger uiCount = [self.cManagedObjectCtx countForFetchRequest:cFetchReqExist error:&cError];
                    if (cError) {
                        NSLog(@"can't read the file attribute:%@", cstrItem);
                    }else {
                        NSDictionary* cdicEntityNames = [[[self.cManagedObjectCtx persistentStoreCoordinator] managedObjectModel] entitiesByName];
                        NSEntityDescription* cEntityDescription = [cdicEntityNames objectForKey:k_table_file_item];
                        FileItem* ccFileItem = nil;
                        if (uiCount == 0) {
                             ccFileItem = [[FileItem alloc] initWithEntity: cEntityDescription insertIntoManagedObjectContext:self.cManagedObjectCtx];
                        }
                        
                        NSString* cstrFileType = [cdicAttribute objectForKey:NSFileType];
                        __weak DLFolderViewViewCtrl* wccSelf = self;
                        NSString* cstrItemLowcase = [cstrItem lowercaseString];
                        
                        if ([cstrFileType isEqualToString:NSFileTypeDirectory]) {
                            NSLog(@"directory!");
                            [wccSelf scanDirectory:cstrFilePath withParentId:acnumberParendId andDisplayLevel:[NSNumber numberWithInt:[acNumberDisplayLevel intValue] + 1]];
                            ccFileItem.cell_id = k_cell_id_folder;
                        }else if ([cstrItemLowcase hasSuffix:@"jpg"] || [cstrItemLowcase hasSuffix:@"png"] || [cstrItemLowcase hasSuffix:@"jpeg"]) {
                            ccFileItem.cell_id = k_cell_id_picture;
                        }else if([cstrItemLowcase hasSuffix:@"mov"]) {
                            ccFileItem.cell_id = k_cell_id_movie;
                        }else if([cstrItemLowcase hasSuffix:@"mp3"] ||
                                 [cstrItemLowcase hasSuffix:@"aac"] ||
                                 [cstrItemLowcase hasSuffix:@"mp4"]) {
                            ccFileItem.cell_id = k_cell_id_music;
                        }else {
                            ccFileItem.cell_id = k_cell_id_general;
                            
                        }
                        NSNumber* cnumberFileSize = [cdicAttribute objectForKey:NSFileSize];
                        NSDate* cdateCreated = [cdicAttribute objectForKey:NSFileCreationDate];
                        uiOrder ++;
                        
                        ccFileItem.content = cstrItem;
                        ccFileItem.file_id = cnumberFileNumber;
                        ccFileItem.parent_id = acnumberParendId;
                        ccFileItem.file_created_date = cdateCreated;
                        ccFileItem.file_size = cnumberFileSize;
                        ccFileItem.order = @(uiOrder);
                        ccFileItem.path = cstrFilePath;
                        ccFileItem.level = acNumberDisplayLevel;
                        
                        
                        
                        if (ccFileItem) {
                            NSArray* carrStores = [[self.cManagedObjectCtx persistentStoreCoordinator]  persistentStores];
                            NSPersistentStore* cPersistentStoreBinary = [carrStores lastObject];
                            [self.cManagedObjectCtx assignObject:ccFileItem toPersistentStore:cPersistentStoreBinary];
                            [self.cManagedObjectCtx insertObject:ccFileItem];
                            if (ccFileItem.isInserted) {
                                [self.cManagedObjectCtx save:&cError];
                            }
                        }
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
    if ([ccFileItem isEqual:self.idObjectSelected]) {
        self.idObjectSelected = nil;
    }
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
            case enum_folder_cell_option_rescanning:
                [self actionScan];
                break;
            case enum_folder_cell_option_create_dir:
                [self createFolder];
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
-(void)exchanged:(NSUInteger)auiFrom with:(NSUInteger)auiTo {
    
    FileItem* ccFileItem0 = [self.cmutarrData objectAtIndex:auiFrom];
    FileItem* ccFileItem1 = [self.cmutarrData objectAtIndex:auiTo];
    NSNumber* cnumberOrder0 = ccFileItem0.order;
    ccFileItem0.order = ccFileItem1.order;
    NSError* cError = nil;
    [self.cManagedObjectCtx save:&cError];
    ccFileItem1.order = cnumberOrder0;
    [self.cManagedObjectCtx save:&cError];

}

#pragma mark - action option 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _cc_file_item_selected = [self.cmutarrData objectAtIndex:[indexPath row]];
    UITableViewCell* cTableviewCell = [tableView cellForRowAtIndexPath:indexPath];
    DLTableViewCellFolder* ccTableviewCell = (DLTableViewCellFolder*)cTableviewCell;
    _s_rect_selcted = [self.view convertRect:ccTableviewCell.cimageView.frame fromView:ccTableviewCell.contentView];
    [self.cactionSheetOption showFromTabBar:self.tabBarController.tabBar];
}
-(void)processSelectedTableCellOption {
    NSLog(@"selected file path is %@", _cc_file_item_selected.path);
    if (_cc_file_item_selected) {
        if ([_cc_file_item_selected.cell_id isEqualToString:k_cell_id_folder]) {
            
        }else if([_cc_file_item_selected.cell_id isEqualToString:k_cell_id_movie]) {
            MPMoviePlayerViewController* cMoviePlayerVeiwCtrl = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:_cc_file_item_selected.path]];
            [self presentViewController:cMoviePlayerVeiwCtrl animated:YES completion:^(void){
                [cMoviePlayerVeiwCtrl.moviePlayer play];
            }];
        }else if([_cc_file_item_selected.cell_id isEqualToString:k_cell_id_music]) {
            MPMoviePlayerViewController* cMoviePlayerVeiwCtrl = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:_cc_file_item_selected.path]];
            [self presentViewController:cMoviePlayerVeiwCtrl animated:YES completion:^(void){
                [cMoviePlayerVeiwCtrl.moviePlayer play];
            }];
        }else if([_cc_file_item_selected.cell_id isEqualToString:k_cell_id_picture]) {
//            NSString* cstrImagePath = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"];
            NSString* cstrImagePath = _cc_file_item_selected.path;
            DLZoomableImageView* ccZoomableImageView = [[DLZoomableImageView alloc] initWithFrame:self.view.bounds];
            ccZoomableImageView.clablePageNumber.hidden = YES;
            UIImage* cimageFile = [UIImage imageWithContentsOfFile: cstrImagePath];
            [ccZoomableImageView setImage:cimageFile];
            [self.view addSubview:ccZoomableImageView];
            [ccZoomableImageView appearAnimationFromRect:_s_rect_selcted];
        }else if([_cc_file_item_selected.cell_id isEqualToString:k_cell_id_general]) {
            
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    switch (buttonIndex) {
        case 0:
        {
            [self processSelectedTableCellOption];
        }
            break;
            
        default:
            break;
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
