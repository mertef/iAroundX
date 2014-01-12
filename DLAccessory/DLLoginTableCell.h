//
//  DLLoginTableCell.h
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLoginTableCell : UITableViewCell <UITextFieldDelegate>{
    NSDictionary* _cdic_info;
}
@property(strong, nonatomic, readonly) NSDictionary* cdicInfo;
@property(strong, nonatomic) UITextField* ctextfieldInput;
@property(strong, nonatomic) UIImageView* cimageviewLeft;
-(void)feedInfo:(NSDictionary*)acdicInfo;
@end
