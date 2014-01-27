//
//  DLItemTableViewCell.m
//  DLAccessory
//
//  Created by Mertef on 12/5/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLItemTableViewCell.h"
#import "DLMCConfig.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLTableCellPopoutView.h"
#import "CSAnimation.h"
#import "PendulumView.h"

@interface DLItemTableViewCell(){
    
}
@end

@implementation DLItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clableName = [[UILabel alloc] init];
        _clableName.textAlignment = NSTextAlignmentLeft;
        _clableName.backgroundColor = [UIColor clearColor];
        _clableName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [self.contentView addSubview:_clableName];
        self.cbtnAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_cbtnAction];
        
        _ccPopoutAction = [[DLTableCellPopoutView alloc] init];
        _ccPopoutAction.clipsToBounds = YES;
        
        [_cbtnAction addTarget:self action:@selector(actionShowPopout:) forControlEvents:UIControlEventTouchUpInside];
        [[_ccPopoutAction cbtnGallery] addTarget:self action:@selector(actionShowGallery:) forControlEvents:UIControlEventTouchUpInside];
        [[_ccPopoutAction cbtnCamera] addTarget:self action:@selector(actionShowCamera:) forControlEvents:UIControlEventTouchUpInside];
        [[_ccPopoutAction cbtnChat] addTarget:self action:@selector(actionShowChat:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_ccPopoutAction];
        
        UIColor *ballColor = [UIColor colorWithRed:0.47 green:0.60 blue:0.89 alpha:1];
       self.ctPendulumView = [[PendulumView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 44.0f)  ballColor:ballColor ballDiameter:12];
        [self.contentView addSubview:self.ctPendulumView];
        [self.ctPendulumView stopAnimating];
    }
    return self;
}

-(void)actionShowGallery:(id)aidSender {
    if ([self.idCellUpdateCB respondsToSelector:@selector(didGallerySelected:)]) {
        [self.idCellUpdateCB performSelector:@selector(didGallerySelected:) withObject:self];
    }
}
-(void)actionShowCamera:(id)aidSender {
    if ([self.idCellUpdateCB respondsToSelector:@selector(didCameraSelected:)]) {
        [self.idCellUpdateCB performSelector:@selector(didCameraSelected:) withObject:self];
    }

}
-(void)actionShowChat:(id)aidSender {
    if ([self.idCellUpdateCB respondsToSelector:@selector(didChatSelected:)]) {
        [self.idCellUpdateCB performSelector:@selector(didChatSelected:) withObject:self];
    }

}
-(void)layoutSubviews {
    [super layoutSubviews];
//    self.contentView.frame = CGRectMake(30.0f, 2.0f, CGRectGetWidth(self.frame) - 40.0f, CGRectGetHeight(self.frame) - 4.0f);

    CGFloat fHeight = CGRectGetHeight(self.contentView.frame);
    
    NSNumber* cnumberStatus = [self.cdicInfo objectForKey:k_peer_status];
    
    
    NSNumber* cnumberShowAction =self.cdicInfo[k_show_action];
    if (cnumberShowAction && [cnumberShowAction boolValue]) {
        fHeight = 44.0f;
    }
    _clableName.frame = CGRectMake(20.0f, 0.0f, (CGRectGetWidth(self.contentView.bounds) - 30.0f) * 0.7f, fHeight);
    
    if ([cnumberStatus unsignedIntValue] == enum_peer_status_connected) {
        UIImage* cimageBtn = [_cbtnAction imageForState:UIControlStateNormal];
        _cbtnAction.frame = CGRectMake(CGRectGetMaxX(_clableName.frame) + (CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(_clableName.frame) - cimageBtn.size.width) * 0.5f, (fHeight - cimageBtn.size.height) * 0.5f, cimageBtn.size.width, cimageBtn.size.height);
        
        _ccPopoutAction.frame = CGRectMake(0.0f, CGRectGetMaxY(_clableName.frame), CGRectGetWidth(self.contentView.frame), k_poput_height);
        self.cbtnAction.hidden = NO;
        self.ctPendulumView.hidden = YES;
    }else if([cnumberStatus unsignedIntValue] == enum_peer_status_connecting ||
             [cnumberStatus unsignedIntValue] == enum_peer_status_try_connecting
             ) {
        self.ctPendulumView.frame = CGRectMake(CGRectGetMaxX(self.clableName.frame) + 4.0f, 0.0f, CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.clableName.frame) - 8.0f, CGRectGetHeight(self.contentView.frame));
        self.cbtnAction.hidden = YES;
        self.ctPendulumView.hidden = NO;
        if ([self.ctPendulumView isAnimating]) {
            [self.ctPendulumView stopAnimating];
        }
        
    }else if([cnumberStatus unsignedIntValue] == enum_peer_status_not_connected) {
        
    }
    
    
   
   
    
   
}
-(void)startPendulumAnimation {
    if (![self.ctPendulumView isAnimating]) {
        [self.ctPendulumView startAnimating];
    }
}
-(void)stopPendulumAnimation {
    if ([self.ctPendulumView isAnimating]) {
        [self.ctPendulumView stopAnimating];
        [self.ctPendulumView setHidden:YES];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedInfo:(NSDictionary*)acdicInfo {
    self.cdicInfo = acdicInfo;
    MCPeerID* cPeerId = acdicInfo[k_peer_id];
    _clableName.text = [cPeerId displayName];
    if (self.bIsConnected) {
        [_cbtnAction setImage:[UIImage imageNamed:@"action-h"] forState:UIControlStateNormal];
    }else {
        [_cbtnAction setImage:[UIImage imageNamed:@"action"] forState:UIControlStateNormal];
    }    
   
    
}
-(void)actionShowPopout:(id)aidSender {
    NSDictionary* cdicItem = self.cdicInfo;
//    NSLog(@"%@", [cdicItem description]);
    NSNumber* cnumberShowAction = [cdicItem objectForKey:k_show_action];
    
    if (![cnumberShowAction boolValue]) {
        
        [(NSMutableDictionary*)cdicItem setObject:@YES forKey:k_show_action];
        
        [self showAction:YES finished:^void(BOOL abFinished){
            if ([self.idCellUpdateCB respondsToSelector:@selector(didCellUpdated:)]) {
                [self.idCellUpdateCB performSelector:@selector(didCellUpdated:) withObject:self];
            }
        }];
                
       
    }else {
        [(NSMutableDictionary*)cdicItem setObject:@NO forKey:k_show_action];
        [self showAction:NO finished:^void(BOOL abFinished){
            if ([self.idCellUpdateCB respondsToSelector:@selector(didCellUpdated:)]) {
                [self.idCellUpdateCB performSelector:@selector(didCellUpdated:) withObject:self];
            }
        }];
        
        
    }

}
-(void)showAction:(BOOL)abFlag finished: ( void(^)(BOOL abFinished) )finished {
//    NSLog(@"flag is %@", abFlag?@"Yes":@"No");
    if (abFlag) {
        [_ccPopoutAction.layer setTransform: CATransform3DRotate(self.layer.transform, (1.0f/2.0f) * M_PI, 1.0f, 0.0f, 0.0f)];
        
        [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            [_ccPopoutAction.layer setTransform:CATransform3DRotate(_ccPopoutAction.layer.transform, (-1.0f/2.0f) * M_PI, 1.0f, 0.0f, 0.0f)];
            Class tBounceMeta = [CSAnimation classForAnimationType:CSAnimationTypeBounceDown];
            [tBounceMeta performAnimationOnView:_ccPopoutAction.cbtnGallery duration:.5f delay:0.0f];
            [tBounceMeta performAnimationOnView:_ccPopoutAction.cbtnCamera duration:.5f delay:.5f];
            [tBounceMeta performAnimationOnView:_ccPopoutAction.cbtnChat duration:.5f delay:1.0f];
        }completion:^(BOOL abFinisehd){
            
        }];
       
    }else {
        
        if (_ccPopoutAction.superview) {
            [UIView animateWithDuration:.3f animations:^(void){
                [_ccPopoutAction.layer setTransform: CATransform3DMakeRotation((1.0f/2.0f)* M_PI, 1.0f, 0.0f, 0.0f)];
            } completion:^(BOOL abFinished){
                if (abFinished) {
                    [_ccPopoutAction removeFromSuperview];
                    finished(abFinished);
                }
                
            }];
            
        }
       
    }
}


+(CGFloat)HeightForCell:(NSDictionary*)acdic {
    CGFloat fHeight = 44.0f;
    NSNumber* cnumberShowAction =acdic[k_show_action];
    if ([cnumberShowAction boolValue]) {
        fHeight += k_poput_height;
    }
//    NSLog(@"height is %f", fHeight);
    return fHeight;
}
@end
