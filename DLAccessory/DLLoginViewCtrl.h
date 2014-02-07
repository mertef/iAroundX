//
//  DLLoginViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLViewLoginFooter;
@interface DLLoginViewCtrl : DLRootViewCtrl<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) UITableView* cTableview;
@property(strong, nonatomic) NSMutableArray* cmutarrModel;
@property(strong, nonatomic) DLViewLoginFooter* ccViewLoginFooter;
-(void)actionLogin:(id)aidSender;
-(void)actionRegister:(id)aiSender;
@end
