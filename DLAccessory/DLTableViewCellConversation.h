//
//  DLTableViewCellConversation.h
//  DLAccessory
//
//  Created by Mertef on 12/25/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLViewIndicator;
@interface DLTableViewCellConversation : UITableViewCell
@property(strong, nonatomic) UILabel* clableName, * clableMsgHint;
@property(strong, nonatomic) NSDictionary* cdicInfo;
@property(strong, nonatomic) DLViewIndicator* ccViewIndicator;
@property(strong, nonatomic) UIView* cviewSeparator;
-(void)feedInfo:(NSDictionary*)acdic;

@end
