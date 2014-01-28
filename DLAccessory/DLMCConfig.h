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
#define k_peer_status @"peer_status"

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

#define k_chat_msg_id  @"chat_msg_id"
#define k_chat_msg  @"chat_msg"
#define k_chat_msg_length  @"chat_msg_length"
#define k_chat_msg_size  @"chat_msg_size"
#define k_chat_msg_current_size  @"chat_msg_current_size"
#define k_chat_msg_finished @"msg_finished"


#define k_chat_msg_media_url  @"chat_msg_media_url"

#define k_chat_msg_type @"msg_type"
#define k_chat_date @"chat_date"
#define k_chat_from_header_icon @"chat_from_header_icon"
#define k_people_icon_default @"people_icon_default"
#define k_people_icon_default_right @"people_default_r"

#define k_noti_chat_msg @"chat_msg_item"
#define k_noti_chat_msg_receive_progress @"chat_msg_receive_progress"

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
#define k_url_invliad @"file://invliad"

#define k_tag_progress_view_chat 0x3533

#define k_tag_chat_progress 0x33313

#define k_login_left_icon @"loing_left_icon"
#define k_login_name @"login_name"
#define k_login_value @"value"
#define k_login_place_holder @"login_name_placeholder"
#define k_name @"name"
#define k_pwd @"pwd"

#define k_color_gray0 [UIColor colorWithRed:0.9059f green:0.9059f blue:0.9059f alpha:1.0f]
#define k_color_gray1 [UIColor colorWithRed:0.3451f green:0.3451f blue:0.3451f alpha:1.0f]
#define k_color_green [UIColor colorWithRed:121.0f/255.0f green:165.0f/255.0f blue:25.0f/255.0f alpha:1.0f]
#define k_color_white [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
#define k_color_pink [UIColor colorWithRed:236.0f/255.0f green:0.0f/255.0f blue:140.0f/255.0f alpha:1.0f]



#define k_image_url @"image_url"
#define k_image_url_type @"url_type"

#define k_peer_user_name @"k_peer_user_name"

#define k_file_attr @"k_file_attr"

#define k_cell_id_music @"DLTableviewCellFolderMusic"
#define k_cell_id_picture @"DLTableviewCellFolderPicture"
#define k_cell_id_movie @"DLTableviewCellFolderMovie"
#define k_cell_id_folder @"DLTableViewCellFolderDirectory"

#define k_cell_id_general @"DLTableViewCellFolder"

#define k_table_file_item @"FileItem"
#define k_ds_store @".DS_Store"
#define db_name @"file_node.sqlite"

#define k_user_login @"user_login"
#define k_user_register @"user_register"
#define k_noti_register_success @"register_success"
#define k_noti_login_success @"login_success"

#define k_table_name_msg_item @"MsgItem"

#define k_session  @"k_session"
#define k_session_left_peer_id  @"left_peer_id"
#define k_session_right_peer_id @"right_peer_id"
typedef NS_ENUM(int32_t, T_PACKAGE_TYPE) {
    enum_package_type_short_msg = 0x300,
    enum_package_type_image,
    enum_package_type_audio,
    enum_package_type_video,
    enum_package_type_stream,
    enum_package_type_location,
    enum_package_type_music,
    enum_package_type_other
};
typedef struct {
       u_int32_t _u_l_package_type;
       u_int32_t _u_l_package_size;
       u_int32_t _u_l_package_length;
       u_int32_t _u_l_current_offset;
       u_int32_t _u_l_msg_id;
       int8_t    _i8_msg_finished;
}T_PACKAGE_HEADER;

typedef NS_ENUM(NSUInteger, enum_scroll_view_image_url_type) {
    enum_scroll_view_image_url_file = 0x400,
    enum_scroll_view_image_url_network,
    enum_scroll_view_image_url_app
};

typedef NS_ENUM(NSUInteger, enum_folder_cell_option) {
    enum_folder_cell_option_save_to_phone = 0x800,
    enum_folder_cell_option_delete,
    enum_folder_cell_option_rescanning,
    enum_folder_cell_option_create_dir
};

typedef NS_ENUM(NSUInteger, enum_peer_status) {
    enum_peer_status_connected = 0x800,
    enum_peer_status_not_connected,
    enum_peer_status_connecting,
    enum_peer_status_try_connecting
};
#endif
