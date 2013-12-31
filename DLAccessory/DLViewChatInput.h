//
//  DLViewChatInput.h
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLViewChatInput;
@class DLAudio;
@protocol DLViewChatInputProto<NSObject>
@optional
-(void)didSendTextMsg:(DLViewChatInput*)accViewChatInput;
-(void)didMorePressed:(DLViewChatInput*)accViewChatInput;
-(void)didTextFrameChange:(DLViewChatInput*)accViewChatInput;
-(void)didStartRecording:(DLViewChatInput*)accViewChatInput;
-(void)didStopRecording:(DLViewChatInput*)accViewChatInput;
@end
@interface DLViewChatInput : UIView<UITextViewDelegate>
@property(strong, nonatomic) UITextView* ctextViewInput;
@property(strong, nonatomic) UIButton* cbtnSend;
@property(strong, nonatomic) DLAudio* ccAudio;
@property(assign, nonatomic) CGRect sRectBoundContent;
@property(assign, nonatomic) CGFloat fMaxNumberOfLines;
@property(assign, nonatomic) NSUInteger uMaxNubmerOfCharacter;
@property(strong, nonatomic) UIImageView* cimageviewBg;
@property(weak, nonatomic) id<DLViewChatInputProto> idProtoViewChat;
-(void)actionSendMsg:(id)aidSender;
-(void)actionMore:(id)aidSender;
-(void)actionAudio:(id)asender;

@end
