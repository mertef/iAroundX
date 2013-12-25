//
//  DLTableViewCellConversation.m
//  DLAccessory
//
//  Created by Mertef on 12/25/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLTableViewCellConversation.h"
#import "DLMCConfig.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DLViewIndicator.h"

@implementation DLTableViewCellConversation

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _clableName = [[UILabel alloc] init];
        _clableName.numberOfLines = 2;
        _clableName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self.contentView addSubview:_clableName];
        
        _clableMsgHint = [[UILabel alloc] init];
        _clableMsgHint.numberOfLines = 2;
        _clableMsgHint.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

        [self.contentView addSubview:_clableMsgHint];

        
        _ccViewIndicator = [[DLViewIndicator alloc] init];
        [self.contentView addSubview:_ccViewIndicator];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect srectName = [_clableName.text boundingRectWithSize:CGSizeMake(90.0f, CGRectGetHeight(self.contentView.bounds)) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_clableName.font} context:nil];
    _clableName.frame = srectName;
    
    CGRect srectMsg = CGRectMake(CGRectGetMaxX(srectName),0.0f,CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(srectName) - 40.0f, CGRectGetHeight(srectName));;
    _clableMsgHint.frame = srectMsg;
    NSLog(@"msg hint frame %@", NSStringFromCGRect(srectMsg));
    _ccViewIndicator.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 36.0f  - 2.0f, (CGRectGetHeight(self.contentView.frame) - 36.0f) * 0.5f, 36.0f, 36.0f);
    
}
-(void)feedInfo:(NSDictionary*)acdic {
    self.cdicInfo = acdic;
    NSString* cstrPeerName = [acdic objectForKey:k_chat_from_name];
    NSString* cstrMsg = [[self.cdicInfo[k_chat_list] lastObject] objectForKey:k_chat_msg];
    _ccViewIndicator.cnumberIndicator = @([self.cdicInfo[k_chat_list] count]);
    [_ccViewIndicator setNeedsDisplay];

    _clableName.text = cstrPeerName;
    _clableMsgHint.text = cstrMsg;
}
@end
