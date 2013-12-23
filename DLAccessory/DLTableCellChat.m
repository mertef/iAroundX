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
    
    NSString* cstrFrom = acdicInfo[k_chat_from];
    NSString* cstrMsg = acdicInfo[k_chat_msg];
    NSNumber* cnumberDate = acdicInfo[k_chat_date];
    
    _clableMsg.text = cstrMsg;
    
    
    _clableDate.text = [g_cdataFormater stringFromDate:[NSDate dateWithTimeIntervalSince1970:[cnumberDate doubleValue]]];
                        
    if ([cstrFrom isEqualToString:self.cstrPeerFrom]) { //image icon is in left
        
    }else { //image icon is in right
        
    }
    
}

@end
