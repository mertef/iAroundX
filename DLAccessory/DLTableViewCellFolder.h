//
//  DLTableViewCellFolder.h
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLTableViewCellFolder;
@protocol ProtoFolderCell <NSObject>

@optional
-(void)didSave2PhoneSelected:(DLTableViewCellFolder*)accFolderCell;
-(void)didDeleteSelected:(DLTableViewCellFolder*)accFolderCell;
@end
@interface DLTableViewCellFolder : UITableViewCell
@property(strong, nonatomic) NSDictionary* cdicInfo;
@property(strong, nonatomic) UIImageView* cimageView;
@property(strong, nonatomic) UILabel* clableFileName;
@property(retain, nonatomic) dispatch_queue_t tDispatchQueue;
@property(strong, nonatomic) UIButton* cbtnDelete, *cbtnSaveToPhone;
@property(assign, nonatomic) id<ProtoFolderCell> idProtoFolderCell;
-(void)feedInfo:(NSDictionary*)acdicInfo;
-(void)actionDelete:(id)aidSender;
-(void)actionSave2Phone:(id)aidSender;

@end
