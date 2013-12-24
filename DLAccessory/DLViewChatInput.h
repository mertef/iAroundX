//
//  DLViewChatInput.h
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLViewChatInput;
@protocol DLViewChatInputProto<NSObject>
@optional
-(void)didSendTextMsg:(DLViewChatInput*)accViewChatInput;
@end
@interface DLViewChatInput : UIView
@property(strong, nonatomic) UITextView* ctextViewInput;
@property(strong, nonatomic) UIButton* cbtnSend;
@property(weak, nonatomic) id<DLViewChatInputProto> idProtoViewChat;
-(void)actionSendMsg:(id)aidSender;
@end
