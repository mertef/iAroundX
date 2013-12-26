//
//  Common.h
//  CQTKeyTime
//
//  Created by JoeMhamMertef on 12/19/11.
//  Copyright 2011 swufe. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WHERESTR  "[file %s, line %d]: "
#define WHEREARG  __FILE__, __LINE__
#define DEBUGPRINT2(...)      if(DEBUG) { fprintf(stderr, __VA_ARGS__);}
#define DEBUGPRINT(_fmt, ...)  DEBUGPRINT2(WHERESTR _fmt, WHEREARG, __VA_ARGS__)

#define SafeRelease(pointer) { if(pointer != nil) {[pointer release]; pointer = nil;}}
#define LPLog(_fmt,...) { if(DEBUG) {NSLog(_fmt,__VA_ARGS__);}} 
#define LPLog0(_fmt) { if(DEBUG) {NSLog(_fmt);}} 

//add by sky
#define kUniversalUserUDIDKey            @"universalUserUDID"

typedef enum {
	enum_or,
	enum_and
}T_PREDICATOR;

/*
FOUNDATION_STATIC_INLINE NSMutableString* SetToHexString(NSString *str);
FOUNDATION_STATIC_INLINE NSString *ttpCode(NSString *artist, NSString *title, long lrcId);
FOUNDATION_STATIC_INLINE long Conv(long i);
FOUNDATION_STATIC_INLINE char SingleDecToHex(int dec);
*/
@interface Common : NSObject {

}
+ (NSString *) urlencode: (NSString *) url;
+ (NSString *)urlencodeGB: (NSString *) url;
+ (NSString*)chinseseCurrentDate;
+ (NSString*)md5String: (NSString*)acstrSouceString;

+ (NSDictionary*)decodeJson:(NSString*)cstrJsonString;
+ (NSArray*)decodeJsonArray:(NSString*)cstrJsonString;
+ (NSString*)getTimestamp;
+ (NSString*)getTimestampFileName;
+ (NSString*)currentDeviceVersion;
+ (void)PrintArray:(NSArray*)aarr;

+(NSString *)EncodeUTF8Str:(NSString *)encodeStr;
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr;
+ (NSDictionary*)getAudioInfo:(NSString*)acstrAudioPath;
+(CGSize)ScalelableText:(NSString*)acstrText size:(CGSize)asSizeInput withFont:(UIFont*)acFont;
+(void)ScalelabeLable:(UILabel*)acLable;
+(NSString*)Trim:(NSString*)acstrInput;
+ (NSString *)FlattenHTMLWithNoLine:(NSString *)html;
+ (NSString *)DeleteLineAndSpaces:(NSString *)acstr;
+(NSString*)ConvertColorIntoString:(UIColor*)acColore;
+(UIColor*)ConvertStringIntoColore:(NSString*)acStringColor;
+ (NSString*) GetMacAddress;
+(NSString*)FormatDateLong:(NSTimeInterval)iTimeInterval;
+(CGFloat)getOsVersion;
+(CGImageRef)makeImageGray:(CGImageRef)arImageSource;
+(BOOL)IsBiggerThanIOS7;
+(BOOL)IsBiggerThanIPhone4s;


@end
