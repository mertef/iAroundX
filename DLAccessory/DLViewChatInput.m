//
//  DLViewChatInput.m
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLViewChatInput.h"

@implementation DLViewChatInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ctextViewInput = [[UITextView alloc] initWithFrame:CGRectMake(4.0f, 2.0f, CGRectGetWidth(self.bounds) - 66.0f, CGRectGetHeight(self.bounds) - 4.0f)];
        _ctextViewInput.layer.borderColor = [UIColor orangeColor].CGColor;
        _ctextViewInput.layer.borderWidth = 1.0f;
        [self addSubview:_ctextViewInput];
        
        _cbtnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _cbtnSend.frame = CGRectMake(CGRectGetMaxX(_ctextViewInput.frame) + 2.0f, CGRectGetMaxY(self.bounds) - 40.0f - 2.0f, 60.0f, 40.0f);
        [_cbtnSend setBackgroundColor:[UIColor orangeColor]];
        [_cbtnSend setTitle:NSLocalizedString(@"k_send", nil) forState:UIControlStateNormal];
        [_cbtnSend addTarget:self action:@selector(actionSendMsg:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cbtnSend];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)actionSendMsg:(id)aidSender {
    if ([self.idProtoViewChat respondsToSelector:@selector(didSendTextMsg:)]) {
        [self.idProtoViewChat performSelector:@selector(didSendTextMsg:) withObject:self];
    }
}

@end
