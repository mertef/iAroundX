//
//  TUTreeViewCtrl.h
//  TreeUI
//
//  Created by Zhang Mertef on 11/7/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TUTreeViewCtrl : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray* m_c_mut_arr_data;
}
@property(strong,nonatomic) NSMutableArray* cmutarrData;
@property(strong, nonatomic) UITableView* cTableView;
-(void)emulateData;
-(void)registerTableviewCells;

@end
