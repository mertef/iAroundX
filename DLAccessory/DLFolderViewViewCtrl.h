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
@interface DLFolderViewViewCtrl : TUTreeViewCtrl <ProtoFolderCell, UIAlertViewDelegate>
@property(weak, nonatomic) DLTableViewCellFolder* ctableviewCellSelected;
@end
