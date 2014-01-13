//
//  DLViewCtrlPersonalCenter.h
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLScrollViewPersonalGallery;
@class DLViewPCInfo;
@interface DLViewCtrlPersonalCenter : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(strong, nonatomic) DLScrollViewPersonalGallery* ccScrollviewPG;
@property(strong, nonatomic) DLViewPCInfo* ccViewPcInfo;
@property(strong, nonatomic) UIActionSheet* cactionSheetChangeAvatar;
-(void)actionChangeAvator:(UITapGestureRecognizer*)acTapGes;
@end
