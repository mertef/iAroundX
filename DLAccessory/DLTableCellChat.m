//
//  DLTableCellChat.m
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLTableCellChat.h"
#import "DLMCConfig.h"
#import "Common.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation DLTableCellChat


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        _cimageViewIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_cimageViewIcon];
        
       

        _cimageViewBg = [[UIImageView alloc] init];
        _cimageViewBg.clipsToBounds = YES;
        [self.contentView addSubview:_cimageViewBg];
        
        _clableMsg = [[UILabel alloc] init];
        _clableMsg.numberOfLines = 0;
        _clableMsg.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:20.0f];
        _clableMsg.lineBreakMode = NSLineBreakByWordWrapping;
        _clableMsg.backgroundColor = [UIColor clearColor];
        
        [_cimageViewBg addSubview:_clableMsg];
        _cimageViewBg.userInteractionEnabled = YES;
        
        
        _clableDate = [[UILabel alloc] init];
        _clableDate.numberOfLines = 1;
        _clableDate.backgroundColor = [UIColor clearColor];
        _clableDate.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] fontWithSize:8.0f];
        _clableDate.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_clableDate];
        
        _cimageViewAudio = [[UIImageView alloc] init];
        _cimageViewAudio.contentMode = UIViewContentModeScaleAspectFit;
        _cimageViewAudio.backgroundColor = [UIColor clearColor];
        _cimageViewAudio.image = [UIImage imageNamed:@"VoiceNodePlaying"];
        _cimageViewAudio.animationImages = @[[UIImage imageNamed:@"VoiceNodePlaying001"],[UIImage imageNamed:@"VoiceNodePlaying002"],[UIImage imageNamed:@"VoiceNodePlaying003"] ];
        _cimageViewAudio.animationDuration = 1.0f;
        _cimageViewAudio.animationRepeatCount = MAXFLOAT;
        _cimageViewAudio.userInteractionEnabled = YES;

        UITapGestureRecognizer* cTapGesPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPlay:)];
        cTapGesPlay.delegate = self;
        [_cimageViewBg addGestureRecognizer:cTapGesPlay];
        
        [_cimageViewBg addSubview:_cimageViewAudio];
        _cimageViewAudio.hidden = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(actionNotiImageThumb:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotiPlaying:) name:k_noti_playing object:nil];
        
    }
    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}


- (void)dealloc
{
    _c_aduio_player = nil;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat fYOffset = 4.0f;
//    CGFloat fHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat fWidth = CGRectGetWidth(self.contentView.bounds);
    
    MCPeerID* cPeerIdFrom = [self.cdicInfo objectForKey:k_chat_from];
    
    NSString* cstrFrom = [cPeerIdFrom displayName];
    CGSize sSizeImage = _cimageViewIcon.image.size;
    CGRect srectBoundMsg = CGRectZero;
    
    NSNumber* cnumberMsgType = self.cdicInfo[k_chat_msg_type];
    if ([cnumberMsgType intValue] == enum_package_type_short_msg) {
        srectBoundMsg = [_clableMsg.text boundingRectWithSize:CGSizeMake(150.0f, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _clableMsg.font} context:nil];
        if (srectBoundMsg.size.width < 150.0f) {
            srectBoundMsg.size.width = 150.0f;
        }
    }else if([cnumberMsgType intValue] == enum_package_type_audio) {
        srectBoundMsg = CGRectMake(0.0f, 0.0f, 150.0f, 54.0f);
    }else if([cnumberMsgType intValue] == enum_package_type_image) {
         srectBoundMsg = CGRectMake(0.0f, 0.0f, 150.0f, 110.0f);
    }else if([cnumberMsgType intValue] == enum_package_type_video) {
        srectBoundMsg = CGRectMake(0.0f, 0.0f, 150.0f, 54.0f);

    }
    if (CGRectGetHeight(srectBoundMsg) < 54.0f) {
        srectBoundMsg.size.height = 54.0f;
    }
    
    if ([cstrFrom isEqualToString:self.cstrPeerFrom]) { //image icon is in left
        _cimageViewIcon.frame = CGRectMake(4.0f, 8.0f, sSizeImage.width, sSizeImage.height);
        _cimageViewBg.frame = CGRectMake(CGRectGetMaxX(_cimageViewIcon.frame) + 4.0f, 4.0, srectBoundMsg.size.width + 26, srectBoundMsg.size.height + 14);
        _clableMsg.textAlignment = NSTextAlignmentLeft;
        if([cnumberMsgType intValue] == enum_package_type_short_msg ||
           [cnumberMsgType intValue] == enum_package_type_audio
           ) {
            UIImage* cimageN = [UIImage imageNamed:@"msg_bubble_n"];
           _cimageViewBg.image = [cimageN resizableImageWithCapInsets:UIEdgeInsetsMake(30.0f,30.0f, 24.0f, 24.0f) resizingMode:UIImageResizingModeStretch];
       }
    
        CGRect srectMsg = srectBoundMsg;
        srectMsg.origin.x += 14.0f;
        srectMsg.origin.y += 4.0f;
        _clableMsg.frame = srectMsg;
        if([cnumberMsgType intValue] == enum_package_type_audio) {
            _cimageViewAudio.frame = CGRectMake((CGRectGetWidth(_cimageViewBg.bounds) - _cimageViewAudio.image.size.width) * 0.5f, (CGRectGetHeight(_cimageViewBg.bounds) - _cimageViewAudio.image.size.height) * 0.5f - 4.0f, _cimageViewAudio.image.size.width, _cimageViewAudio.image.size.height);
        }
        
    }else { //image icon is in right
        _cimageViewIcon.frame = CGRectMake(fWidth - 4.0f - sSizeImage.width, 18.0f, sSizeImage.width, sSizeImage.height);
        CGRect srectImageBg = CGRectMake(fWidth - sSizeImage.width * 2.0f - 4.0f - srectBoundMsg.size.width, 4.0 , srectBoundMsg.size.width + 26.0f, srectBoundMsg.size.height + 14);
        _cimageViewBg.frame = srectImageBg;
        _clableMsg.textAlignment = NSTextAlignmentRight;
        if([cnumberMsgType intValue] == enum_package_type_short_msg ||
           [cnumberMsgType intValue] == enum_package_type_audio
           ) {
            UIImage* cimageN = [UIImage imageNamed:@"msg_bubble_r"];
            _cimageViewBg.image = [cimageN resizableImageWithCapInsets:UIEdgeInsetsMake(30.0f,30.0f, 24.0f, 24.0f) resizingMode:UIImageResizingModeStretch];
        }
        CGRect srectMsg = srectBoundMsg;
        srectMsg.origin.x += 4.0f;
        srectMsg.origin.y += 4.0f;
        _clableMsg.frame = srectMsg;
        if([cnumberMsgType intValue] == enum_package_type_audio) {
            _cimageViewAudio.frame = CGRectMake((CGRectGetWidth(_cimageViewBg.bounds) - _cimageViewAudio.image.size.width) * 0.5f, (CGRectGetHeight(_cimageViewBg.bounds) - _cimageViewAudio.image.size.height) * 0.5f - 4.0f, _cimageViewAudio.image.size.width, _cimageViewAudio.image.size.height);
        }
    }
    
    
     if([cnumberMsgType intValue] == enum_package_type_image) {
         self.cimageViewMsgImage.frame = _clableMsg.frame;
    }else if([cnumberMsgType intValue] == enum_package_type_video) {
        self.cimageViewMsgVideoFirstFrame.frame = _clableMsg.frame;
//        NSLog(@"---%@", NSStringFromCGRect(self.cimageViewMsgVideoFirstFrame.frame));
        UIImage* cimageVideo = self.cimageViewMsgVideo.image;
        self.cimageViewMsgVideo.frame = CGRectMake(0.0f , 0.0f, cimageVideo.size.width, cimageVideo.size.height);
        self.cimageViewMsgVideo.center = self.cimageViewMsgVideoFirstFrame.center;
    }
    

    _clableDate.frame = CGRectMake(CGRectGetMinX(_cimageViewBg.frame) + 30.0f, CGRectGetMaxY(_cimageViewBg.frame) - 10.0f, 60.0f, 20.0f);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)feedDictionaryInfo:(NSDictionary*)acdicInfo {
    
    self.cdicInfo = acdicInfo;
//    NSLog(@"%@", [self.cdicInfo description]);
    MCPeerID* cPeerIdFrom = [self.cdicInfo objectForKey:k_chat_from];

    NSNumber* cnumberMsgType = self.cdicInfo[k_chat_msg_type];

    NSString* cstrPeopleHeaderIcon = acdicInfo[k_chat_from_header_icon];
    if (!cstrPeopleHeaderIcon) {
        NSString* cstrFrom = [cPeerIdFrom displayName];
        if ([cstrFrom isEqualToString:self.cstrPeerFrom]) {
            cstrPeopleHeaderIcon = k_people_icon_default;
        }else {
            cstrPeopleHeaderIcon = k_people_icon_default_right;
        }
    }
#pragma mark - fix me need remote icon
    
    UIImage* cimageIconDefault = [UIImage imageNamed:cstrPeopleHeaderIcon];
    _cimageViewIcon.image = cimageIconDefault;
    _cimageViewAudio.hidden = YES;
    _cimageViewBg.image = nil;
    self.cimageViewMsgImage.hidden = YES;
    self.cimageViewMsgVideo.hidden = YES;
    self.cimageViewMsgVideoFirstFrame.hidden = YES;
    if ([cnumberMsgType intValue] == enum_package_type_short_msg) {
        NSLog(@"msg type is msg");
        NSString* cstrMsg = [[NSString alloc] initWithData:acdicInfo[k_chat_msg] encoding:NSUTF8StringEncoding];
        _clableMsg.text = cstrMsg;
        _clableMsg.hidden = NO;

    }else if([cnumberMsgType intValue] == enum_package_type_audio) {
        _cimageViewAudio.hidden = NO;
        NSLog(@"msg type is audio");
        _clableMsg.hidden = YES;
        if (!_c_aduio_player) {
            NSError* cError = nil;
            NSData* cData = self.cdicInfo[k_chat_msg];
            //            NSLog(@"playing ---- data length is %lu", (unsigned long)[cData length]);
            _c_aduio_player = [[AVAudioPlayer alloc] initWithData:cData error:&cError];
            _c_aduio_player.delegate = self;
            if (cError) {
                NSLog(@"can't play audio %@", [cError description]);
            }else if(![_c_aduio_player prepareToPlay]){
                NSLog(@"can't play audio");
            }
        }
        
    }else if([cnumberMsgType intValue] == enum_package_type_image) {
         NSLog(@"msg type is image");
        _clableMsg.hidden = YES;
        if (!self.cimageViewMsgImage) {
            self.cimageViewMsgImage = [[UIImageView alloc] init];
            self.cimageViewMsgImage.contentMode = UIViewContentModeScaleAspectFit;
            self.cimageViewMsgImage.backgroundColor = [UIColor clearColor];

            [self.cimageViewBg addSubview:self.cimageViewMsgImage];
        }
        self.cimageViewMsgImage.hidden = NO;
        NSData* cdata = self.cdicInfo[k_chat_msg];
        UIImage* cimage = [UIImage imageWithData:cdata];
        self.cimageViewMsgImage.image = cimage;
        
    }else if([cnumberMsgType intValue] == enum_package_type_video) {
        _clableMsg.hidden = YES;
        if (!self.cimageViewMsgVideoFirstFrame) {
            self.cimageViewMsgVideoFirstFrame = [[UIImageView alloc] init];
            self.cimageViewMsgVideoFirstFrame.contentMode = UIViewContentModeScaleAspectFit;
//            self.cimageViewMsgVideoFirstFrame.backgroundColor = [UIColor yellowColor];
            [self.cimageViewBg addSubview:self.cimageViewMsgVideoFirstFrame];
        }
        
        if (!self.cimageViewMsgVideo) {
            self.cimageViewMsgVideo = [[UIImageView alloc] init];
            self.cimageViewMsgVideo.contentMode = UIViewContentModeScaleAspectFit;
            self.cimageViewMsgVideo.image = [UIImage imageNamed:@"player"];
            self.cimageViewMsgVideo.backgroundColor = [UIColor clearColor];
            [self.cimageViewMsgVideoFirstFrame addSubview:self.cimageViewMsgVideo];
        }

        
       NSString* cstrTempUrl = [self.cdicInfo objectForKey:k_chat_msg_media_url];
        /*
        if (!_c_movie_player_ctr) {
            _c_movie_player_ctr = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:cstrTempUrl]];
        }else {
            [_c_movie_player_ctr setContentURL:[NSURL fileURLWithPath:cstrTempUrl]];
        }
        [_c_movie_player_ctr play];

        [_c_movie_player_ctr requestThumbnailImagesAtTimes:@[ [NSValue valueWithCMTime:CMTimeMake(0, 0)] ] timeOption:MPMovieTimeOptionNearestKeyFrame];
         */
        
        AVAsset* casset = [AVAsset assetWithURL:[NSURL URLWithString:cstrTempUrl] ];
        /*
        NSArray* carrList = [casset tracks];
        for (AVAssetTrack* cAssetTrack in carrList) {
            NSLog(@"%@:%@", [cAssetTrack mediaType], [[cAssetTrack formatDescriptions] description]);
        }*/
        AVAssetImageGenerator* cAssetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:casset];
        CMTime tTimeActually;
        NSError* cError = nil;
        CGImageRef rImageFirstFrame = [cAssetImageGenerator copyCGImageAtTime:CMTimeMake(1, 1) actualTime:&tTimeActually error:&cError];
        if (!cError) {
            self.cimageViewMsgVideoFirstFrame.image = [UIImage imageWithCGImage:rImageFirstFrame];
            CGImageRelease(rImageFirstFrame);
        }else {
            NSLog(@"%@", [cError description]);
        }
        
        self.cimageViewMsgVideoFirstFrame.hidden = NO;
    }
    NSNumber* cnumberDate = acdicInfo[k_chat_date];
    
    _clableDate.text = [Common FormatDateLong:[cnumberDate doubleValue]];
    
    
}
-(void)actionNotiImageThumb:(NSNotification*)acNoti {
    /*
     serInfo dictionary contains values for the following keys:
     MPMoviePlayerThumbnailImageKey
     MPMoviePlayerThumbnailTimeKey
     If the capture request finished with an error, the userInfo dictionary contains values for the following two keys:
     
     MPMoviePlayerThumbnailErrorKey
     MPMoviePlayerThumbnailTimeKey
    if (acNoti.userInfo && [acNoti.userInfo objectForKey:MPMoviePlayerThumbnailImageKey]) {
        UIImage* cimage = [acNoti.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    }else {
        NSLog(@"generate image error : %@", [[acNoti.userInfo objectForKey:MPMoviePlayerThumbnailErrorKey] description]);
    }
    */
}
-(void)play {

    NSNumber* cnumberMsgType = self.cdicInfo[k_chat_msg_type];

    if ([cnumberMsgType intValue] == enum_package_type_audio) {
        if ([_c_aduio_player isPlaying]) {
            [_c_aduio_player playAtTime:0.0f];
        }else if([_c_aduio_player play]){
            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_playing object:nil userInfo:self.cdicInfo];
        }else {
            NSLog(@"can't play!");
        }
        [self.cimageViewAudio startAnimating];
    }else if([cnumberMsgType intValue] == enum_package_type_video) {
        if ([self.idChatProto respondsToSelector:@selector(didRequestPlayerVideo:)]) {
            [self.idChatProto didRequestPlayerVideo:self.cdicInfo];
        }
    }else if([cnumberMsgType intValue] == enum_package_type_image){
        if ([self.idChatProto respondsToSelector:@selector(didRequestShowImage:)]) {
            [self.idChatProto didRequestShowImage:self.cdicInfo];
        }
        
    }
    

    
}

+(CGFloat)HeightForCell:(NSDictionary*)acdicInfo {
    
    CGFloat fHeight = 20.0f + 54.0f + 8.0f;
    NSNumber* cnumberMsgType = acdicInfo[k_chat_msg_type];
    if ([cnumberMsgType intValue] == enum_package_type_short_msg) {
        NSString* cstrMsg = [[NSString alloc] initWithData:acdicInfo[k_chat_msg] encoding:NSUTF8StringEncoding];
        
        CGRect srectBoundMsg = [cstrMsg boundingRectWithSize:CGSizeMake(150.0f, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:20.0f]} context:nil];
        if (CGRectGetHeight(srectBoundMsg) > 54.0f) {
            fHeight += (CGRectGetHeight(srectBoundMsg) - 54.0f);
        }
        if (srectBoundMsg.size.width < 150.0f) {
            srectBoundMsg.size.width = 150.0f;
        }
    }else if ( [cnumberMsgType intValue] == enum_package_type_audio){
       
    }else if ( [cnumberMsgType intValue] == enum_package_type_image){
        fHeight += 60.0f;
    }else if ( [cnumberMsgType intValue] == enum_package_type_video){
        
    }
   
    
    
    return fHeight;
}

-(void)actionPlay:(UITapGestureRecognizer*)acTapGes {
    NSLog(@"action play");
    [self play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_cimageViewAudio stopAnimating];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error  {
    NSLog(@"%@", [error description]);
}



/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [player pause];
    [_cimageViewAudio stopAnimating];
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    [player play];
    [_cimageViewAudio startAnimating];

}
-(void)actionNotiPlaying:(NSNotification*)acNoti {
    if (![acNoti.userInfo isEqual:self.cdicInfo]) {
        if (_c_aduio_player) {
            [_c_aduio_player stop];
            [_cimageViewAudio stopAnimating];
        }
    }
}

@end
