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
@interface DLViewChatInput()
-(void)computeContentBound;
@end;

@implementation DLViewChatInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        _ctextViewInput = [[UITextView alloc] init];
        _ctextViewInput.layer.cornerRadius = 4.0f;
        _ctextViewInput.textContainerInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
        _ctextViewInput.layer.borderColor = [UIColor orangeColor].CGColor;
        _ctextViewInput.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:20.0f];
        _ctextViewInput.layer.borderWidth = 1.0f;
        _ctextViewInput.returnKeyType = UIReturnKeySend;
        _ctextViewInput.delegate =self;
        
        CGFloat fHeight = _ctextViewInput.textContainerInset.top + _ctextViewInput.textContainerInset.bottom + _ctextViewInput.font.lineHeight;
        
        _ctextViewInput.frame = CGRectMake(4.0f + 66.0f, 4.0f + (CGRectGetHeight(self.frame) - fHeight  - 8.0f) * 0.5f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f,fHeight);
        self.sRectBoundContent = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_ctextViewInput.bounds), _ctextViewInput.font.lineHeight);
        [self addSubview:_ctextViewInput];
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.cbtnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _cbtnSend.frame = CGRectMake(CGRectGetMaxX(_ctextViewInput.frame) + 3.0f, CGRectGetHeight(self.frame) - k_text_input_height - 2.0f,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height);
        [_cbtnSend setBackgroundColor:[UIColor clearColor]];
        [_cbtnSend setImage:[UIImage imageNamed:@"addmore"] forState:UIControlStateNormal];
        [_cbtnSend addTarget:self action:@selector(actionMore:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cbtnSend];
        
        _fMaxNumberOfLines = 3.0f;
        _uMaxNubmerOfCharacter = 1024;
        self.ccAudio = [[DLAudio alloc] initWithFrame:CGRectMake(4.0f, CGRectGetHeight(self.frame) - k_text_input_height - 4.0f,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height)];
      
        [self addSubview:_ccAudio];
        
    }
    return self;
}
-(void)layoutSubviews {
    
    [super layoutSubviews];    
    
    CGFloat fHeight = 0.0f;
    if (self.sRectBoundContent.size.height == 0.0f) {
        fHeight = _ctextViewInput.font.lineHeight + _ctextViewInput.textContainerInset.top + _ctextViewInput.textContainerInset.bottom;
    }else {
        fHeight  = self.sRectBoundContent.size.height + _ctextViewInput.textContainerInset.top + _ctextViewInput.textContainerInset.bottom;
    }

    if (self.sRectBoundContent.size.height <= 3.0f * _fMaxNumberOfLines * (_ctextViewInput.font.lineHeight + _ctextViewInput.textContainerInset.top + _ctextViewInput.textContainerInset.bottom)) {
       _ctextViewInput.frame = CGRectMake(4.0f+ 66.0f, 4.0f + (CGRectGetHeight(self.frame) -fHeight - 8.0f) * 0.5f, CGRectGetWidth(self.bounds) - 66.0f * 2.0f, fHeight);
        
        self.cbtnSend.frame = CGRectMake(CGRectGetMaxX(_ctextViewInput.frame) + 3.0f, CGRectGetHeight(self.frame) - k_text_input_height - 4.0f ,CGRectGetWidth(self.frame) - CGRectGetMaxX(_ctextViewInput.frame) - 6.0f, k_text_input_height);
    }
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
    
    BOOL bShouldChange = YES;
    if([text isEqualToString:@"\n"]) {
        [self performSelector:@selector(actionSendMsg:) withObject:nil afterDelay:0.0f];
        return NO;
    }
    if ([textView.text length] > self.uMaxNubmerOfCharacter) {
        bShouldChange = NO;
    }
    if (bShouldChange) {
        [self computeContentBound];
    }
    return bShouldChange;
}
-(void)computeContentBound {
    NSString* cstrText = [_ctextViewInput text];
    UIEdgeInsets sEdgeInset = [_ctextViewInput textContainerInset];
    NSMutableParagraphStyle* cmutParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    cmutParagrahStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIEdgeInsets sEdgeInsetContent = _ctextViewInput.textContainerInset;

    CGRect srectNew =  [cstrText boundingRectWithSize:CGSizeMake(CGRectGetWidth(_ctextViewInput.frame) - sEdgeInset.left - sEdgeInset.right - sEdgeInsetContent.left - sEdgeInsetContent.right - _ctextViewInput.textContainer.lineFragmentPadding * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _ctextViewInput.font, NSParagraphStyleAttributeName: cmutParagrahStyle} context:nil];
    
    if (self.sRectBoundContent.size.height == srectNew.size.height) {
        return;
    }


    self.sRectBoundContent = srectNew;
    CGFloat fMaxHeight =  _fMaxNumberOfLines * (_ctextViewInput.font.lineHeight);
    if (srectNew.size.height  > fMaxHeight) {
        [_ctextViewInput setContentOffset:CGPointMake(0.0f, srectNew.size.height  - fMaxHeight)];
        _ctextViewInput.showsVerticalScrollIndicator = YES;
        return;
    }else {
        _ctextViewInput.showsVerticalScrollIndicator = NO;

        [NSObject cancelPreviousPerformRequestsWithTarget:self.idProtoViewChat selector:@selector(didTextFrameChange:) object:self];
        if ([self.idProtoViewChat respondsToSelector:@selector(didTextFrameChange:)]) {
            [self.idProtoViewChat performSelector:@selector(didTextFrameChange:) withObject:self];
        }
    }
    
    
}

@end
