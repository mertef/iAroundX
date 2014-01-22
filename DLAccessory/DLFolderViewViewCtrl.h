//
//  DLFolderViewViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 12/17/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUTreeViewCtrl.h"
#import "DLTableViewCellFolder.h"
@class NSManagedObjectContext;
@class DLPage;
@class DLViewTableFooterMore;
@class DLViewTableHeader;
@class MBProgressHUD;
@interface DLFolderViewViewCtrl : TUTreeViewCtrl <ProtoFolderCell, UIAlertViewDelegate, UIActionSheetDelegate>
@property(weak, nonatomic) DLTableViewCellFolder* ctableviewCellSelected;
@property(strong, nonatomic) DLPage* ccPage;
@property(strong, nonatomic) NSManagedObjectContext* cManagedObjectCtx;
@property(strong, nonatomic) UIRefreshControl* crefreshCtrl;
@property(strong, nonatomic) DLViewTableFooterMore* ccTableFooterMore;
@property(strong, nonatomic) DLViewTableHeader* ccTableHeaderMore;
@property(strong, nonatomic) MBProgressHUD* ctProgressHud;
@property(strong, nonatomic) UIActionSheet* cactionSheetOption;

-(void)actionCreateFolder:(id)aidSender;
-(void)actionReOrderFolder:(id)aidSender;
-(void)actionRescanFolder:(id)aidSender;
-(void)actionLoadMore:(id)aidSender;
@end
