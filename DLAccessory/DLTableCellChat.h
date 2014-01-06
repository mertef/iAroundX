//
//  DLTableCellChat.h
//  DLAccessory
//
//  Created by Mertef on 12/23/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//@class MPMoviePlayerController;
@protocol DLTableCellChatProto <NSObject>

@optional
-(void)didRequestPlayerVideo:(NSDictionary*)acdicInfo;
-(void)didRequestShowImage:(NSDictionary*)acdicInfo;
@end
@interface DLTableCellChat : UITableViewCell<AVAudioPlayerDelegate, UIGestureRecognizerDelegate> {
    AVAudioPlayer* _c_aduio_player;
//    MPMoviePlayerController* _c_movie_player_ctr;
    
}
@property(strong, nonatomic) UIImageView* cimageViewIcon;
@property(strong, nonatomic) UIImageView* cimageViewBg;
@property(strong, nonatomic) UIImageView* cimageViewAudio;
@property(strong, nonatomic) UIImageView* cimageViewMsgImage;
@property(strong, nonatomic) UIImageView* cimageViewMsgVideo;
@property(strong, nonatomic) UIImageView* cimageViewMsgVideoFirstFrame;
@property(assign, nonatomic) id<DLTableCellChatProto> idChatProto;

@property(strong, nonatomic) UILabel* clableMsg;
@property(strong, nonatomic) UILabel* clableDate;
@property(strong, nonatomic) NSDictionary* cdicInfo;
@property(copy, nonatomic) NSString* cstrPeerFrom;
-(void)feedDictionaryInfo:(NSDictionary*)acdicInfo;
+(CGFloat)HeightForCell:(NSDictionary*)acdicInfo;

-(void)play;
-(void)actionNotiImageThumb:(NSNotification*)acNoti;

@end
