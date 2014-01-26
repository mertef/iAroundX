//
//  DLTableViewCellFolder.m
//  DLAccessory
//
//  Created by Mertef on 1/17/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTableViewCellFolder.h"
#import "DLMCConfig.h"
#import "TUTreeConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "FileItem.h"

@implementation DLTableViewCellFolder

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cimageView = [[UIImageView alloc] init];
        self.cimageView.backgroundColor = [UIColor clearColor];
        self.cimageView.contentMode = UIViewContentModeScaleAspectFit;
        self.cimageView.clipsToBounds = YES;
        [self.contentView addSubview:self.cimageView];
        
        self.clableFileName = [[UILabel alloc] init];
        self.clableFileName.backgroundColor = [UIColor clearColor];
        self.clableFileName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.clableFileName.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.clableFileName];
//        self.tDispatchQueue = dispatch_queue_create("queue_loading", DISPATCH_QUEUE_CONCURRENT);
        self.cbtnSaveToPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnSaveToPhone setImage:[UIImage imageNamed:@"folder_save"] forState:UIControlStateNormal];
        [self.cbtnSaveToPhone setImage:[UIImage imageNamed:@"folder_save_h"] forState:UIControlStateHighlighted];
        [self.cbtnSaveToPhone addTarget:self action:@selector(actionSave2Phone:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cbtnSaveToPhone];
        
        self.cbtnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cbtnDelete setImage:[UIImage imageNamed:@"folder_transh"] forState:UIControlStateNormal];
        [self.cbtnDelete setImage:[UIImage imageNamed:@"folder_transh_h"] forState:UIControlStateHighlighted];
        [self.cbtnDelete addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:self.cbtnDelete];
        
    }
    return self;
}

-(void)selectCell:(BOOL)abFlag {
    if (abFlag) {
        self.contentView.backgroundColor = k_colore_gradient_blue;
    }else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fW = CGRectGetWidth(self.contentView.frame);
    CGFloat fH = CGRectGetHeight(self.contentView.frame);
    NSInteger iLevel = [_ccFileItem.level integerValue];
    
    self.cimageView.frame = CGRectMake(4.0f + iLevel * 32.0f, (fH  - 32.0f) * 0.5f, 32.0f, 32.0f);
    self.clableFileName.frame = CGRectMake(CGRectGetMaxX(self.cimageView.frame) + 4.0f, (fH - 20.0f) * 0.5f, fW - CGRectGetMaxX(self.cimageView.frame) - 100.0f, 20.0f);
    UIImage* cimageNormal = [self.cbtnSaveToPhone imageForState:UIControlStateNormal];
    self.cbtnSaveToPhone.frame = CGRectMake(CGRectGetMaxX(self.clableFileName.frame) + 18.0f, (fH - cimageNormal.size.height) * 0.5f, cimageNormal.size.width, cimageNormal.size.height);
//    NSLog(@"%@", NSStringFromCGRect(self.cbtnSaveToPhone.frame));
    self.cbtnDelete.frame = CGRectMake(CGRectGetMaxX(self.cbtnSaveToPhone.frame) + 18.0f, (fH - cimageNormal.size.height) * 0.5f, cimageNormal.size.width, cimageNormal.size.height);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



-(void)feedInfo:(FileItem*)accFileItem {
    self.ccFileItem = accFileItem;
    //    NSLog(@"%@", cstrPath);
    self.cimageView.image = nil;
    self.clableFileName.text = self.ccFileItem.content;
    
}
-(void)actionDelete:(id)aidSender {
    if ([self.idProtoFolderCell respondsToSelector:@selector(didDeleteSelected:)]) {
        [self.idProtoFolderCell didDeleteSelected:self];
    }
}
-(void)actionSave2Phone:(id)aidSender {
    if ([self.idProtoFolderCell respondsToSelector:@selector(didSave2PhoneSelected:)]) {
        [self.idProtoFolderCell didSave2PhoneSelected:self];
    }
    
}
-(void)setModelCell {
    self.cbtnSaveToPhone.hidden = YES;
}


@end
