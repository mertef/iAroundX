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

@interface DLFolderViewViewCtrl () {
    dispatch_queue_t _dispatch_queue_scanning;
    enum_folder_cell_option _enum_folder_option;
}
-(void)deleteSelectedItem ;
-(void)saveSelectedItmIntoPhone;

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = NSLocalizedString(@"k_folder_title", nil);
    
    
    __weak DLFolderViewViewCtrl* wccSelf = self;
    dispatch_async(_dispatch_queue_scanning, ^(void){
        NSString* cstrDocumentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        [wccSelf scanDirectory:cstrDocumentRoot withParentId:@(0) andDisplayLevel:@(0)];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.cTableView reloadData];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* cdicItem = [m_c_mut_arr_data objectAtIndex:[indexPath row]];
    NSString* cstrIdCell  = [cdicItem objectForKey:k_id_cell];
    DLTableViewCellFolder *cell = [tableView dequeueReusableCellWithIdentifier:cstrIdCell forIndexPath:indexPath];
    if ([[cell gestureRecognizers] count] == 0) {
        UIPanGestureRecognizer* cPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionBeginEdit:)];
        [cell addGestureRecognizer:cPanGes];
        cPanGes.enabled = NO;
    }
    cell.idProtoFolderCell = self;
    cell.indentationLevel = [cdicItem[k_level] integerValue];
    [cell feedInfo:cdicItem];
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
            NSString* cstrFilePath = [acstrDirectoryPath stringByAppendingPathComponent:cstrItem];
            NSDictionary* cdicAttribute = [cfileManagerDefault attributesOfItemAtPath:cstrFilePath error:&cError];
            if (cError) {
                NSLog(@"can't read the file attribute:%@", cstrItem);
            }else {
//                NSLog(@"%@", [cdicAttribute description]);
                NSNumber* cnumberFileNumber = [cdicAttribute objectForKey:NSFileSystemFileNumber];
                NSString* cstrFileType = [cdicAttribute objectForKey:NSFileType];
                __weak DLFolderViewViewCtrl* wccSelf = self;

                NSMutableDictionary* cmutdicItem = [NSMutableDictionary dictionary];
                NSString* cstrItemLowcase = [cstrItem lowercaseString];

                if ([cstrFileType isEqualToString:NSFileTypeDirectory]) {
                    [wccSelf scanDirectory:cstrFilePath withParentId:acnumberParendId andDisplayLevel:[NSNumber numberWithInt:[acNumberDisplayLevel intValue] + 1]];
                    [cmutdicItem setObject:k_cell_id_folder forKey:k_id_cell];
                }else if ([cstrItemLowcase hasSuffix:@"jpg"] || [cstrItemLowcase hasSuffix:@"png"] || [cstrItemLowcase hasSuffix:@"jpeg"]) {
                    [cmutdicItem setObject:k_cell_id_picture forKey:k_id_cell];
                }else if([cstrItemLowcase hasSuffix:@"mov"]) {
                    [cmutdicItem setObject:k_cell_id_movie forKey:k_id_cell];
                }else if([cstrItemLowcase hasSuffix:@"mp3"] ||
                         [cstrItemLowcase hasSuffix:@"aac"] ||
                         [cstrItemLowcase hasSuffix:@"mp4"]) {
                        [cmutdicItem setObject:k_cell_id_music forKey:k_id_cell];

                }else {
                        [cmutdicItem setObject:k_cell_id_general forKey:k_id_cell];
                }
                
                [cmutdicItem setObject:cnumberFileNumber forKey:k_id];
                [cmutdicItem setObject:acnumberParendId forKey:k_parent_id];
                [cmutdicItem setObject:cstrItem forKey:k_content];
                [cmutdicItem setObject:cdicAttribute forKey:k_file_attr];
                [cmutdicItem setObject:acNumberDisplayLevel forKey:k_level];
                [cmutdicItem setObject:@(uiOrder) forKey:k_order];
                [cmutdicItem setObject:cstrFilePath forKey:k_path];
                 uiOrder ++;
                [self.cmutarrData addObject:cmutdicItem];
            }
            cstrItem = cDirEnumerator.nextObject;
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

    NSDictionary* cdicItem = self.ctableviewCellSelected.cdicInfo;
    [self.cTableView beginUpdates];
    [self.cmutarrData removeObject:cdicItem];
    NSIndexPath* cIndexPath = [self.cTableView indexPathForCell:self.ctableviewCellSelected];
    [self.cTableView deleteRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.cTableView endUpdates];
    self.ctableviewCellSelected = nil;
}
-(void)saveSelectedItmIntoPhone {
    NSDictionary* cdicItem = self.ctableviewCellSelected.cdicInfo;
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
