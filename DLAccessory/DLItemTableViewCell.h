//
//  DLItemTableViewCell.h
//  DLAccessory
//
//  Created by Mertef on 12/5/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLCellPopoutProto <NSObject>

@optional
-(void)didCellUpdated:(UITableViewCell*)acTableviewCell;
-(void)didGallerySelected:(UITableViewCell*)acTableviewCell;
-(void)didCameraSelected:(UITableViewCell*)acTableviewCell;
-(void)didChatSelected:(UITableViewCell*)acTableviewCell;
-(void)shouldConnectToPeer:(UITableViewCell*)acTableviewCell;
@end
@class DLTableCellPopoutView;
@class PendulumView;
@interface DLItemTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel* clableName;
@property(nonatomic, strong) UIButton* cbtnAction;
@property(nonatomic, assign) BOOL bIsConnected;
@property(nonatomic, strong) DLTableCellPopoutView* ccPopoutAction;
@property(nonatomic, weak) id<DLCellPopoutProto> idCellUpdateCB;
@property(nonatomic, strong) NSDictionary* cdicInfo;
@property(nonatomic, strong) PendulumView* ctPendulumView;
-(void)feedInfo:(NSDictionary*)acdicInfo;
-(void)showAction:(BOOL)abFlag finished: ( void(^)(BOOL abFinished) )finished ;
+(CGFloat)HeightForCell:(NSDictionary*)acdic;
-(void)actionShowGallery:(id)aidSender;
-(void)actionShowCamera:(id)aidSender;
-(void)actionShowChat:(id)aidSender;
-(void)startPendulumAnimation;
-(void)stopPendulumAnimation ;
@end
