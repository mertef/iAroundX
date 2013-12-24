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


#define k_chat_from @""
#define k_chat_msg  @""
#define k_chat_date @""
#define k_chat_from_header_icon @""

#define k_people_icon_default @"people_icon_default"



typedef NS_ENUM(int32_t, T_PACKAGE_TYPE) {
    enum_package_type_short_msg = 0x300,
    enum_package_type_image,
    enum_package_type_audio,
    enum_package_type_video,
    enum_package_type_stream
};
typedef struct {
       u_int32_t _u_l_package_type;
       u_int32_t _u_l_package_size;
       u_int32_t _u_l_package_length;
       u_int32_t _u_l_current_offset;
}T_PACKAGE_HEADER;

#endif
