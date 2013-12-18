//
//  DLImageViewCtrl.h
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLImageViewCtrl : UIViewController
@property(nonatomic, strong) UIImageView* cimageView;
-(void)actionTapExit:(UITapGestureRecognizer*)acTapGes;

@end
