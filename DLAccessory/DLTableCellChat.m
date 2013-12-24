//
//  DLTableCellChat.m
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLTableCellChat.h"
#import "DLMCConfig.h"
static NSDateFormatter* g_cdataFormater;

@implementation DLTableCellChat

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cimageViewIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_cimageViewIcon];
        
        _cimageViewBg = [[UIImageView alloc] init];
        [self.contentView addSubview:_cimageViewBg];
        
        _clableMsg = [[UILabel alloc] init];
        _clableMsg.numberOfLines = 0;
        _clableMsg.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        [_cimageViewBg addSubview:_clableMsg];
        
        
        _clableDate = [[UILabel alloc] init];
        _clableDate.numberOfLines = 1;
        _clableDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [self.contentView addSubview:_clableDate];
        
        if (!g_cdataFormater) {
            g_cdataFormater = [[NSDateFormatter alloc] init];
        }


        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat fYOffset = 4.0f;
    CGFloat fHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat fWidth = CGRectGetWidth(self.contentView.bounds);
    
    NSString* cstrFrom = self.cdicInfo[k_chat_from];
    CGSize sSizeImage = _cimageViewIcon.image.size;

    NSString* cstrMsg = self.cdicInfo[k_chat_msg];
    
    CGRect srectBoundMsg = [cstrMsg boundingRectWithSize:CGSizeMake(200.0f, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
    
    if ([cstrFrom isEqualToString:self.cstrPeerFrom]) { //image icon is in left
        _cimageViewIcon.frame = CGRectMake(4.0f, 4.0f + (fHeight - fYOffset - sSizeImage.height) * 0.5f, sSizeImage.width, sSizeImage.height);
        _cimageViewBg.frame = CGRectMake(CGRectGetMaxX(_cimageViewIcon.frame) + 2.0f, 4.0f, srectBoundMsg.size.width, srectBoundMsg.size.height);
        
    }else { //image icon is in right
        _cimageViewIcon.frame = CGRectMake(fWidth - 4.0f - sSizeImage.width, 4.0f + (fHeight - fYOffset - sSizeImage.height) * 0.5f, sSizeImage.width, sSizeImage.height);
        _cimageViewBg.frame = CGRectMake(CGRectGetMinX(_cimageViewIcon.frame) -2.0f - srectBoundMsg.size.width, 4.0f, srectBoundMsg.size.width, srectBoundMsg.size.height);
    }
    _clableDate.frame = CGRectMake(CGRectGetMinX(_cimageViewBg.frame), CGRectGetMaxY(_cimageViewBg.frame) + 2.0f, 100.0f, 20.0f);
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedDictionaryInfo:(NSDictionary*)acdicInfo {
    
    self.cdicInfo = acdicInfo;
    NSString* cstrPeopleHeaderIcon = acdicInfo[k_chat_from_header_icon];
    if (!cstrPeopleHeaderIcon) {
        cstrPeopleHeaderIcon = k_people_icon_default;
    }
#pragma mark - fix me need remote icon
    
    UIImage* cimageIconDefault = [UIImage imageNamed:cstrPeopleHeaderIcon];
    _cimageViewIcon.image = cimageIconDefault;
    
    NSString* cstrMsg = acdicInfo[k_chat_msg];
    NSNumber* cnumberDate = acdicInfo[k_chat_date];
    
    _clableMsg.text = cstrMsg;
    
    
    _clableDate.text = [g_cdataFormater stringFromDate:[NSDate dateWithTimeIntervalSince1970:[cnumberDate doubleValue]]];
    
    
    
}
+(CGFloat)HeightForCell:(NSDictionary*)acdicInfo {
    
    CGFloat fHeight = 20.0f + 8.0f;
    NSString* cstrMsg = acdicInfo[k_chat_msg];

    CGRect srectBoundMsg = [cstrMsg boundingRectWithSize:CGSizeMake(200.0f, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
    fHeight += CGRectGetHeight(srectBoundMsg);
    
    
    return fHeight;
}
@end
