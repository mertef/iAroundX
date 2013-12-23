//
//  DLTableCellChat.h
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTableCellChat : UITableViewCell
@property(strong, nonatomic) UIImageView* cimageViewIcon;
@property(strong, nonatomic) UIImageView* cimageViewBg;
@property(strong, nonatomic) UILabel* clableMsg;
@property(strong, nonatomic) UILabel* clableDate;
@property(strong, nonatomic) NSDictionary* cdicInfo;
@property(copy, nonatomic) NSString* cstrPeerFrom;
-(void)feedDictionaryInfo:(NSDictionary*)acdicInfo;

@end
