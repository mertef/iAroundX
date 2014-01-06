//
//  DLMCConfig.h
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#ifndef DLAccessory_DLMCConfig_h
#define DLAccessory_DLMCConfig_h

#define k_service_type @"imusic-mertef"
#define id_table_cell @"id_table_cell"
#define id_table_header @"id_table_header"
#define id_table_footer @"id_table_footer"

#define k_tag_progress_view 0x3001
#define k_peer_id @"peer_id"
#define k_peer_id_name @"peer_id_name"
#define k_show_action @"show_action"

#define k_poput_height 60.0f

#define k_colore_blue [UIColor colorWithRed:0.2627 green:0.3804 blue:0.8000 alpha:1.0f]


#define k_colore_orange  [UIColor colorWithRed:1.0000 green:0.7020 blue:0.4000 alpha:1.0f]
#define k_colore_gradient_green [UIColor colorWithRed:0.7373 green:0.9765 blue:0.2471 alpha:1.0f]
#define k_colore_gradient_pink [UIColor colorWithRed:0.9412 green:0.0941 blue:0.4588 alpha:1.0f]
#define k_colore_gradient_blue  [UIColor colorWithRed:0.3608 green:0.6353 blue:0.9451 alpha:1.0f]

#define k_chat_from @"chat_from"
#define k_chat_from_name @"chat_from_name"
#define k_chat_list @"k_chat_list"
#define k_chat_to @"chat_to"

#define k_chat_msg  @"chat_msg"
#define k_chat_msg_media_url  @"chat_msg_media_url"

#define k_chat_msg_type @"msg_type"
#define k_chat_date @"chat_date"
#define k_chat_from_header_icon @"chat_from_header_icon"

#define k_people_icon_default @"people_icon_default"
#define k_people_icon_default_right @"people_default_r"

#define k_noti_chat_msg @"chat_msg_item"
#define k_noti_chat_msg_increase @"chat_msg_item_increase"
#define k_noti_chat_msg_decrease @"chat_msg_item_decrease"
#define k_msg_cout @"msg_count"
#define k_height_input 44.0f
#define k_text_input_height 36.0f
#define k_height_keyboard 216.0f
#define k_default_recording_path @"s.aac"


#define k_file_type_video @"mov"
#define k_file_type_image @"jpg"


#define k_noti_playing @"noti_playing_item"


#define k_tag_progress_view_chat 0x3533
typedef NS_ENUM(int32_t, T_PACKAGE_TYPE) {
    enum_package_type_short_msg = 0x300,
    enum_package_type_image,
    enum_package_type_audio,
    enum_package_type_video,
    enum_package_type_stream,
    enum_package_type_other
};
typedef struct {
       u_int32_t _u_l_package_type;
       u_int32_t _u_l_package_size;
       u_int32_t _u_l_package_length;
       u_int32_t _u_l_current_offset;
}T_PACKAGE_HEADER;

#endif
