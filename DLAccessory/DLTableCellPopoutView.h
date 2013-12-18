//
//  DLTableCellPopoutView.h
//  DLAccessory
//
//  Created by Mertef on 12/10/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTableCellPopoutView : UIView
@property(strong, nonatomic) UIImageView* cimageviewBg;
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
@property(strong, nonatomic) UIButton* cbtnGallery, * cbtnCamera, * cbtnChat;
@end
