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
        _clableName.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:15.0f];
        _clableName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_clableName];
        
        _cviewSeparator = [[UIView alloc] init];
        _cviewSeparator.backgroundColor = k_colore_gradient_pink;
        [self.contentView addSubview:_cviewSeparator];
        
        
        _clableMsgHint = [[UILabel alloc] init];
        _clableMsgHint.numberOfLines = 2;
        _clableMsgHint.backgroundColor = [UIColor clearColor];
        _clableMsgHint.textAlignment = NSTextAlignmentCenter;
        _clableMsgHint.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        [self.contentView addSubview:_clableMsgHint];

        
        _ccViewIndicator = [[DLViewIndicator alloc] init];
        [self.contentView addSubview:_ccViewIndicator];
        
        _cimageViewMsgType = [[UIImageView alloc] init];
        _cimageViewMsgType.backgroundColor = [UIColor clearColor];
        _cimageViewMsgType.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_cimageViewMsgType];

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
    
    self.contentView.frame = CGRectMake(2.0f, 2.0f, CGRectGetWidth(self.contentView.bounds) - 4.0f, CGRectGetHeight(self.contentView.frame) - 4.0f);
    CGRect srectName = [_clableName.text boundingRectWithSize:CGSizeMake(100.0f, CGRectGetHeight(self.contentView.bounds)) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_clableName.font} context:nil];
    srectName.origin.y = (CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(srectName)) * 0.5f;
    _clableName.frame = srectName;
    
    _cviewSeparator.frame = CGRectMake(CGRectGetMaxX(_clableName.frame) + 4.0f, CGRectGetHeight(self.contentView.frame) * 0.25f, 2.0f, CGRectGetHeight(self.contentView.frame) * 0.5f);
    
    NSDictionary* cdicItem = [self.cdicInfo[k_chat_list] lastObject];
    NSNumber* cnumberMsgType = [cdicItem objectForKey:k_chat_msg_type];
    switch ([cnumberMsgType intValue]) {
        case enum_package_type_audio:
        {
            _cimageViewMsgType.frame = CGRectMake(CGRectGetMaxX(_cviewSeparator.frame) + 4.0f, (CGRectGetHeight(self.contentView.frame) - _cimageViewMsgType.image.size.height) * 0.5f, _cimageViewMsgType.image.size.width, _cimageViewMsgType.image.size.height);
        }
            break;
        case enum_package_type_image:
            break;
        case enum_package_type_short_msg:
        {
            CGRect srectMsg = CGRectMake(CGRectGetMaxX(_cviewSeparator.frame) + 4.0f,0.0f,CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(_cviewSeparator.frame) - 32.0f - 8.0f,  CGRectGetHeight(self.contentView.frame) - 4.0f);
            srectMsg.origin.y = (CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(srectMsg)) * 0.5f;
            
            _clableMsgHint.frame = srectMsg;
        }
            break;
        case enum_package_type_stream:
            break;
        case enum_package_type_video:
            break;
        default:
            break;
    }

    
    
//    NSLog(@"msg hint frame %@", NSStringFromCGRect(srectMsg));
    _ccViewIndicator.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 32.0f  - 2.0f, (CGRectGetHeight(self.contentView.frame) - 32.0f) * 0.5f, 32.0f, 32.0f);
    
}
-(void)feedInfo:(NSDictionary*)acdic {
    self.cdicInfo = acdic;
    NSString* cstrPeerName = [acdic objectForKey:k_chat_from_name];
    _clableName.text = cstrPeerName;
    _clableMsgHint.hidden = YES;
    NSDictionary* cdicItem = [self.cdicInfo[k_chat_list] lastObject];
    NSNumber* cnumberMsgType = [cdicItem objectForKey:k_chat_msg_type];
    _cimageViewMsgType.hidden = YES;
    switch ([cnumberMsgType intValue]) {
        case enum_package_type_audio:
            _cimageViewMsgType.hidden = NO;
            _cimageViewMsgType.image = [UIImage imageNamed:@"audio"];
        break;
        case enum_package_type_image: {
            _cimageViewMsgType.hidden = NO;
        }
        break;
        case enum_package_type_short_msg:
        {
            _cimageViewMsgType.hidden = YES;
            _clableMsgHint.hidden = NO;
            NSString* cstrMsg =  [[NSString alloc] initWithData:cdicItem[k_chat_msg] encoding:NSUTF8StringEncoding];
            _clableMsgHint.text = cstrMsg;
        }
            break;
        case enum_package_type_stream: {
            _cimageViewMsgType.hidden = NO;
        }
        break;
        case enum_package_type_video: {
            _cimageViewMsgType.hidden = NO;
        }
        break;
        default:
            break;
    }
    
  
    _ccViewIndicator.cnumberIndicator = @([self.cdicInfo[k_chat_list] count]);
    [_ccViewIndicator setNeedsDisplay];

}
@end
