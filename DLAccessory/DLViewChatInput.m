//
//  DLViewChatInput.m
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLViewChatInput.h"
#import "DLMCConfig.h"
#import "DLAudio.h"

@implementation DLViewChatInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ctextViewInput = [[UITextView alloc] initWithFrame:CGRectMake(4.0f + 66.0f, CGRectGetHeight(self.frame) - k_text_input_height - 4.0f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f,k_text_input_height)];
        _ctextViewInput.layer.cornerRadius = 4.0f;
        _ctextViewInput.layer.borderColor = [UIColor orangeColor].CGColor;
        _ctextViewInput.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _ctextViewInput.layer.borderWidth = 1.0f;
        _ctextViewInput.returnKeyType = UIReturnKeySend;
        _ctextViewInput.delegate =self;
        
        [self addSubview:_ctextViewInput];
        NSLog(@"line height is %f", _ctextViewInput.font.lineHeight);
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.cbtnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _cbtnSend.frame = CGRectMake(CGRectGetMaxX(_ctextViewInput.frame) + 3.0f, CGRectGetHeight(self.frame) - k_text_input_height - 2.0f,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height);
        [_cbtnSend setBackgroundColor:[UIColor clearColor]];
        [_cbtnSend setImage:[UIImage imageNamed:@"addmore"] forState:UIControlStateNormal];
        [_cbtnSend addTarget:self action:@selector(actionMore:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cbtnSend];
        
        
        self.ccAudio = [[DLAudio alloc] initWithFrame:CGRectMake(4.0f, CGRectGetHeight(self.frame) - k_text_input_height - 4.0f,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height)];
      
        [self addSubview:_ccAudio];
        
    }
    return self;
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    CGSize sSizeContent = _ctextViewInput.contentSize;
    
    if (sSizeContent.height == 60.0f) {
        _ctextViewInput.frame = CGRectMake(4.0f + 66.0f, CGRectGetHeight(self.frame) - 60.0f - 4.0f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f, 60.0f);
        [_ctextViewInput layoutIfNeeded];
    }else if(sSizeContent.height == 82.0f){
        _ctextViewInput.frame = CGRectMake(4.0f+ 66.0f, CGRectGetHeight(self.frame) - 82.0f - 4.0f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f, 82.0f);
        [_ctextViewInput layoutIfNeeded];
    }else if(sSizeContent.height == 38.0f) {
        _ctextViewInput.frame = CGRectMake(4.0f+ 66.0f, CGRectGetHeight(self.frame) - 38.0f - 4.0f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f, 38.0f);
        [_ctextViewInput layoutIfNeeded];
    }
    self.cbtnSend.frame = CGRectMake(CGRectGetMaxX(_ctextViewInput.frame) + 3.0f, CGRectGetHeight(self.frame) - k_text_input_height - 4.0f ,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)actionMore:(id)aidSender {
    if ([self.idProtoViewChat respondsToSelector:@selector(didMorePressed:)]) {
        [self.idProtoViewChat performSelector:@selector(didMorePressed:) withObject:self];
    }
}


-(void)actionSendMsg:(id)aidSender {
    if ([self.idProtoViewChat respondsToSelector:@selector(didSendTextMsg:)]) {
        [self.idProtoViewChat performSelector:@selector(didSendTextMsg:) withObject:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self performSelector:@selector(actionSendMsg:) withObject:nil afterDelay:0.0f];
        return NO;
    }
    
    return YES;
}
@end
