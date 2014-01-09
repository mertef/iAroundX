//
//  Common.m
//  CQTKeyTime
//
//  Created by JoeMhamMertef on 12/19/11.
//  Copyright 2011 swufe. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
//#import "ZipArchive.h"
#import "SBJSON.h"
#import <AudioToolbox/AudioToolbox.h>

#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <sys/sysctl.h>
#include <net/if.h>





@implementation Common


+ (NSString *)urlencode: (NSString *) url{
	
	[url retain];
	NSString* escapedUrlString =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//CQTLog(@"%@", escapedUrlString);
	[url release];
    return escapedUrlString;
}

+ (NSString *)urlencodeGB: (NSString *) url {
	
	[url retain];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);	
	NSString* escapedUrlString =[url stringByAddingPercentEscapesUsingEncoding:enc];
	[url release];
    return escapedUrlString;
}

+ (NSString*)md5String: (NSString*)acstrSouceString {
	const char* cpStrSrc = [acstrSouceString UTF8String];
	unsigned char pucMd5Buffer[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cpStrSrc, (CC_LONG)strlen(cpStrSrc), pucMd5Buffer);
	NSMutableString* cmuttrMd5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[cmuttrMd5 appendFormat:@"%02x", pucMd5Buffer[i]];
	}
	return cmuttrMd5;
}

+ (NSString*)chinseseCurrentDate {
	NSString* cstrDate = nil;
	NSDate* cdateCurrent = [NSDate date];
	NSDateFormatter *cdateFormatter = [[NSDateFormatter alloc] init];
	[cdateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[cdateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSLocale *localeChina = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[cdateFormatter setLocale:localeChina];
    [localeChina release]; localeChina = nil;
	cstrDate = [cdateFormatter stringFromDate:cdateCurrent];    [cdateFormatter release];
    return cstrDate;
}
+ (NSString*)getTimestamp {
	NSString* cstrDate = nil;
	NSDate* cdateCurrent = [NSDate date];
	NSDateFormatter *cdateFormatter = [[NSDateFormatter alloc] init];
	[cdateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
	cstrDate = [cdateFormatter stringFromDate:cdateCurrent];    [cdateFormatter release];
    return cstrDate;
	
}

+ (NSString*)getTimestampFileName {
	NSString* cstrDate = nil;
	NSDate* cdateCurrent = [NSDate date];
	NSDateFormatter *cdateFormatter = [[NSDateFormatter alloc] init];
	[cdateFormatter setDateFormat: @"yyyy_MM_dd_HH_mm_ss"];
	cstrDate = [cdateFormatter stringFromDate:cdateCurrent];    [cdateFormatter release];
    return cstrDate;
	
}

+ (NSMutableArray*)Array: (NSMutableArray*)aArray filterObjectsByConditionV0: (NSMutableDictionary*)aCondition andPredicator: (T_PREDICATOR)aPredicator {
	
	[aArray retain];
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];;
	NSMutableArray* objs = [[NSMutableArray alloc] initWithCapacity:16];	
	NSPredicate* p = nil;
    BOOL flag0 , flag1;
	flag0 = flag1 = NO;
	NSObject* value = nil;
	NSObject* keyValue = nil;
	
	for (NSDictionary* dic  in aArray) {
		
		for (NSString* key in aCondition.allKeys) {
			
			value = [dic objectForKey:key];
			keyValue = [aCondition valueForKey:key];
			if(aPredicator == enum_or) {
				
				p = [NSPredicate predicateWithFormat:@"SELF like [cd]  %@", value];
				if ([value isKindOfClass:[NSString class]] == YES) {
					
					if ([p  evaluateWithObject:value] == YES) {
						
						[objs addObject: dic];
                        //						CQTLog(@"%@",  dic);
						flag0 = YES;
						break;
					}
				}
			}
			else if(aPredicator == enum_or)  {	
				p = [NSPredicate predicateWithFormat:@"SELF   [cd]  %@", value];
				if ([value isKindOfClass:[NSString class]] == YES) {
					
					if ([p  evaluateWithObject:keyValue] == YES) {
						
						flag1 = YES;
					}
					else {
						
						flag1 = NO;
						break;
					}
				}
			}
		}
		if (flag1 == YES) {
			
			[objs addObject: dic];
		}
		
	}
	for (NSDictionary* dic  in objs) {
		
        //		CQTLog(@"%@", dic);
	}
	[pool release];
	[aArray release];
	return [objs autorelease];
}


+ (NSDictionary*)decodeJson:(NSString*)cstrJsonString {
    NSDictionary* cdicJson = nil;
	SBJSON* cjsonParser = [[SBJSON alloc] init];
	NSError* cerror = nil;
	cdicJson = [cjsonParser objectWithString:cstrJsonString error:&cerror];
	if (cerror != nil) {
		//NSLog(@"%s, %s , decodeJson Error(%@)", __FILE__, __FUNCTION__, [cerror description]);
	}
    [cjsonParser release];
	return cdicJson;
}

+ (NSArray*)decodeJsonArray:(NSString*)cstrJsonString {
    NSArray* carrRs = nil;
	SBJSON* cjsonParser = [[SBJSON alloc] init];
	NSError* cerror = nil;
	carrRs = [cjsonParser objectWithString:cstrJsonString error:&cerror];
	if (cerror != nil) {
		//NSLog(@"%s, %s , decodeJson Error(%@)", __FILE__, __FUNCTION__, [cerror description]);
	}
    [cjsonParser release];
	return carrRs;
}

+ (NSString*)currentDeviceVersion {
    return @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20100101 Firefox/10.0.2";
	/*
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *strDeviceVersion = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	
    //	CQTKeyTimeLog(@"strDeviceVersion= %@", strDeviceVersion);	
    //    if (strDeviceVersion != nil) {
    //        
    //        if ([strDeviceVersion isEqualToString:@"i386"] || [strDeviceVersion isEqualToString:@"x86_64"]) {
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceSimulator];
    //        }else if([strDeviceVersion isEqualToString:@"iPod1,1"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPodTouch];
    //        } 
    //        else if([strDeviceVersion isEqualToString:@"iPod2,1"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPodTouch3];
    //        }
    //        else if([strDeviceVersion isEqualToString:@"iPhone1,1"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone2];
    //        }
    //        else if([strDeviceVersion isEqualToString:@"iPhone1,2"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone3];
    //        }
    //        else if([strDeviceVersion isEqualToString:@"iPhone2,1"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone3GS];
    //        }
    //        else if([strDeviceVersion isEqualToString:@"iPhone3,1"]){
    //              
    //        }
    //        else if([strDeviceVersion isEqualToString:@"iPad1,1"]){
    //            
    //            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPad1];
    //        }else {
    //            
    //            strDeviceVersion = @"Other Device";
    //        }
    //    }else {
    //        
    //        strDeviceVersion = @"unknow device";
    //    }
	
	if ([strDeviceVersion rangeOfString:@"iPhone"].location != NSNotFound || [strDeviceVersion rangeOfString:@"iPod"].location != NSNotFound) {
		
		strDeviceVersion = [NSString stringWithFormat:@"iphone"];
		
	}else if([strDeviceVersion rangeOfString:@"iPad"].location != NSNotFound) {
		
		strDeviceVersion = [NSString stringWithFormat:@"ipad"];
	}else {
        
        strDeviceVersion = [NSString stringWithFormat:@"iphone"];
    }
    
    return strDeviceVersion;*/
}

+ (void)PrintArray:(NSArray*)aarr {
   for (NSDictionary* cdic in aarr) {
	   //NSLog(@"%@", cdic);
   }
}

+ (NSDictionary*)getAudioInfo:(NSString*)acstrAudioPath {
	NSMutableDictionary* cmutdicAudioInfo = [[NSMutableDictionary alloc] init];

	AudioFileID fileID  = nil;
	OSStatus err        = noErr;
	err = AudioFileOpenURL( (CFURLRef) [NSURL fileURLWithPath:acstrAudioPath], kAudioFileReadPermission, 0, &fileID );	
	if( err != noErr ) {
		//NSLog( @"get audtion duration  failed !" );
	}else {		
        UInt32 uint32Size = sizeof(cmutdicAudioInfo);
		err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &uint32Size, &cmutdicAudioInfo );
		if( err != noErr ) {
			//NSLog( @"AudioFileGetProperty failed for property info dictionary" );
		}
		AudioFileClose(fileID);
	}
//	//NSLog(@"%@", cmutdicAudioInfo);
	return [cmutdicAudioInfo autorelease];
}

#pragma mark - 
#pragma mark Encode Chinese to ISO8859-1 in URL 
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr{ 
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");         
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8);         
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease]; 
    [preprocessedString release]; 
    return newStr;         
} 
#pragma mark - 
#pragma mark Encode Chinese to GB2312 in URL 
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr{ 
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");         
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);         
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease]; 
    [preprocessedString release]; 
    return newStr;         
}

+(CGSize)ScalelableText:(NSString*)acstrText size:(CGSize)asSizeInput withFont:(UIFont*)acFont{
    //    //NSLog(@"before %@", NSStringFromCGSize(asSizeInput));
    CGSize sSize = CGSizeZero;
    sSize = [acstrText boundingRectWithSize:CGSizeMake(asSizeInput.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:acFont} context:nil].size;
    return sSize;
}

+(void)ScalelabeLable:(UILabel*)acLable {
    CGRect sRectTitle = CGRectZero;
    CGSize sSizeScalelabe = [Common ScalelableText:acLable.text size:acLable.frame.size withFont:acLable.font];
    sRectTitle = acLable.frame;
    sRectTitle.size = sSizeScalelabe;
    //    //NSLog(@"after scalable %@", NSStringFromCGRect(sRectTitle));
    
    acLable.frame = sRectTitle;
}

+(NSString*)Trim:(NSString*)acstrInput {
    if (acstrInput == nil) {
        return @"";
    }
    acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet  illegalCharacterSet]];
    acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet  decimalDigitCharacterSet]];
    
    acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];	
    acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet  punctuationCharacterSet]];	
    acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"0123456789、。。‘｛｝｜*＆……￥＃＠～·％-——＋＝[]"]];	

    return acstrInput;
}

+ (NSString *)FlattenHTMLWithNoLine:(NSString *)html {
    NSScanner *thescanner;
    NSString *text = nil;
    thescanner = [NSScanner scannerWithString:html];
    
    while ([thescanner isAtEnd] == NO) {
        
        // find start of tag
        [thescanner scanUpToString:@"<" intoString:nil] ; 
        
        // find end of tag
        [thescanner scanUpToString:@">" intoString:&text] ;
        //        //NSLog(@"%@", text);
        if ([text isEqualToString:@"<br"]) {
            html = [html stringByReplacingOccurrencesOfString:
                    [ NSString stringWithFormat:@"%@>", text]
                                                   withString:@" "];
        }else {        
            html = [html stringByReplacingOccurrencesOfString:
                    [ NSString stringWithFormat:@"%@>", text]
                                                   withString:@""];
        }
        
    } // while // 
    
    return html;
    
}
+ (NSString *)DeleteLineAndSpaces:(NSString *)acstr {
    NSString* cstrFiltered = nil;
    NSScanner* cscanner = [[NSScanner alloc] initWithString:acstr];
    NSMutableString* cmutstrFiltered = [[NSMutableString alloc] init];
    while (cscanner.isAtEnd == NO) {
        [cscanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\t"] intoString:&cstrFiltered];
        [cscanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\t"]  intoString:nil];
        [cmutstrFiltered appendString:cstrFiltered];        
    }    
    [cscanner release];
    return [cmutstrFiltered autorelease];
}
+(NSString*)ConvertColorIntoString:(UIColor*)acColore {
    if (acColore == nil) {
        return nil;
    }
    CGFloat fRed = 0.0f;
    CGFloat fBlue = 0.0f;
    CGFloat fGreen = 0.0f;
    CGFloat fAlpha = 0.0f;
    [acColore getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
    NSString* cstrColor = [NSString stringWithFormat:@"%f,%f,%f,%f", fRed, fGreen,fBlue, fAlpha];
    return cstrColor;
}

+(UIColor*)ConvertStringIntoColore:(NSString*)acStringColor{
    if (acStringColor == nil) {
        return [UIColor blackColor];
    }
    NSArray* carrRgba = [acStringColor componentsSeparatedByString:@","];
    if (acStringColor == nil || ([carrRgba count] != 4) ) {
        return [UIColor blackColor];
    }
    CGFloat fRed = 0.0f;
    CGFloat fBlue = 0.0f;
    CGFloat fGreen = 0.0f;
    CGFloat fAlpha = 0.0f;
    fRed = [[carrRgba objectAtIndex:0] floatValue];
    fGreen = [[carrRgba objectAtIndex:1] floatValue];
    fBlue = [[carrRgba objectAtIndex:2] floatValue];
    fAlpha = [[carrRgba objectAtIndex:3] floatValue];
    UIColor* cColorConverted = [UIColor colorWithRed:fRed green:fGreen blue:fBlue alpha:fAlpha];        
    return cColorConverted;
}

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
//+ (NSString*) GetMacAddress {
//    
//    int                 mgmtInfoBase[6];
//    char                *msgBuffer = NULL;
//    size_t              length;
//    unsigned char       macAddress[6];
//    struct if_msghdr    *interfaceMsgStruct;
//    struct sockaddr_dl  *socketStruct;
//    NSString            *errorFlag = NULL;
//    
//    // Setup the management Information Base (mib)
//    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
//    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
//    mgmtInfoBase[2] = 0;              
//    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
//    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
//    
//    // With all configured interfaces requested, get handle index
//    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
//        errorFlag = @"if_nametoindex failure";
//    else
//    {
//        // Get the size of the data available (store in len)
//        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
//            errorFlag = @"sysctl mgmtInfoBase failure";
//        else
//        {
//            // Alloc memory based on above call
//            if ((msgBuffer = malloc(length)) == NULL)
//                errorFlag = @"buffer allocation failure";
//            else
//            {
//                // Get system information, store in buffer
//                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
//                    errorFlag = @"sysctl msgBuffer failure";
//            }
//        }
//    }
//    
//    // Befor going any further...
//    if (errorFlag != NULL)
//    {
//        NSLog(@"Error: %@", errorFlag);
//        return errorFlag;
//    }
//    
//    // Map msgbuffer to interface message structure
//    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
//    
//    // Map to link-level socket structure
//    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
//    
//    // Copy link layer address data in socket structure to an array
//    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
//    
//    // Read from char array into a string object, into traditional Mac address format
//    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
//                                  macAddress[0], macAddress[1], macAddress[2], 
//                                  macAddress[3], macAddress[4], macAddress[5]];
//    //NSLog(@"Mac Address: %@", macAddressString);
//    
//    // Release the buffer memory
//    free(msgBuffer);
//    
//    return macAddressString;
//}

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
// Modify by sky
+ (NSString*)GetMacAddress {
    
    NSString *macAddressString = [[NSUserDefaults standardUserDefaults] objectForKey:kUniversalUserUDIDKey];
    if (macAddressString == nil || [macAddressString length]==0) {
        
        int                 mgmtInfoBase[6];
        char                *msgBuffer = NULL;
        size_t              length;
        unsigned char       macAddress[6];
        struct if_msghdr    *interfaceMsgStruct;
        struct sockaddr_dl  *socketStruct;
        NSString            *errorFlag = NULL;
        
        // Setup the management Information Base (mib)
        mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK;        // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
        
        // With all configured interfaces requested, get handle index
        if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
            errorFlag = @"if_nametoindex failure";
        else
        {
            // Get the size of the data available (store in len)
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
                errorFlag = @"sysctl mgmtInfoBase failure";
            else
            {
                // Alloc memory based on above call
                if ((msgBuffer = malloc(length)) == NULL)
                    errorFlag = @"buffer allocation failure";
                else
                {
                    // Get system information, store in buffer
                    if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                        errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
        
        // Befor going any further...
        if (errorFlag != NULL)
        {
            NSLog(@"Error: %@", errorFlag);
            return errorFlag;
        }
        
        // Map msgbuffer to interface message structure
        interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2],
                                      macAddress[3], macAddress[4], macAddress[5]];
        //NSLog(@"Mac Address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
    }
    
    return macAddressString;
}


+(NSString*)FormatDateLong:(NSTimeInterval)iTimeInterval {
    NSString* cstrDay = nil;
    //NSlog(@"%@", acstrTime);
    NSDateFormatter* cdateFormatter = [[NSDateFormatter alloc] init];
    [cdateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [cdateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    NSDate* cdate = [NSDate dateWithTimeIntervalSince1970:iTimeInterval];

    
    NSCalendar *cCalendarGregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone* ctimeZone = [NSTimeZone defaultTimeZone];    
    [cCalendarGregorian setTimeZone:ctimeZone];

    
    
        
    NSDateComponents* cDateComponents = [cCalendarGregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:cdate];
    
    NSDate* cdateToday = [NSDate date];
    
    
    NSDateComponents* cDateComponentsToday = [cCalendarGregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:cdateToday];
    
    [cCalendarGregorian release]; cCalendarGregorian = nil;

    if ([cDateComponentsToday day] == [cDateComponents day]) {
        if ([cDateComponents hour] == [cDateComponentsToday hour]) {
            long iMinutesOffset = [cDateComponentsToday minute] - [cDateComponents minute];
            if ( iMinutesOffset <= 5) {
                cstrDay = @"刚刚";
            }else {
                cstrDay = [NSString stringWithFormat:@"%2ld分钟前",(long)iMinutesOffset];
            }
        }else {
            cstrDay = [NSString stringWithFormat:@"今天 %02ld:%02ld", (long)[cDateComponents hour], (long)[cDateComponents minute]];
        }
    }else if([cDateComponentsToday day] == [cDateComponents day] -1 ) {
        cstrDay = [NSString stringWithFormat:@"昨天 %02ld:%02ld", (long)[cDateComponents hour],  (long)[cDateComponents minute]];
    }else if([cDateComponentsToday day] == [cDateComponents day]  - 2) {
        cstrDay = [NSString stringWithFormat:@"前天 %2ld:%02ld",  (long)[cDateComponents hour],  (long)[cDateComponents minute]];
    }else {
        cstrDay = [NSString stringWithFormat:@"%02ld-%2ld %02ld:%02ld", (long)[cDateComponents month], (long)[cDateComponents day], (long)[cDateComponents hour],  (long)[cDateComponents minute]];
    }
    [cdateFormatter release];
    //    //NSlog(@"%@", cstrDay);
    return cstrDay;
}
+(CGFloat)getOsVersion{
    CGFloat fOsVersion = 0.0f;
    NSString* cstrModel = [UIDevice currentDevice].model;
    fOsVersion = [cstrModel floatValue];
    return fOsVersion;
}

+(CGImageRef)makeImageGray:(CGImageRef)arImageSource{
    size_t width = CGImageGetWidth(arImageSource);
    size_t height = CGImageGetHeight(arImageSource);
    
    // Create a gray scale context and render the input image into that
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8,
                                                 4*width, colorspace, kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(context, CGRectMake(0,0, width,height), arImageSource);
    
    // Get an image representation of the grayscale context which the input
    //    was rendered into.
    CGImageRef outputImage = CGBitmapContextCreateImage(context);
    
    // Cleanup
    CGContextRelease(context);
    CGColorSpaceRelease(colorspace);
    
    return (CGImageRef)[(id)outputImage autorelease];
}
static int g_b_is_bigger_than_ios7 = -1;
+(BOOL)IsBiggerThanIPhone4s{
    BOOL bIsBiggerThanIos7 = NO;
    if (g_b_is_bigger_than_ios7 == -2) {
        bIsBiggerThanIos7 = NO;
    }else if(g_b_is_bigger_than_ios7 > 0) {
        bIsBiggerThanIos7 = YES;
    }else if (g_b_is_bigger_than_ios7 == -1) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *cstrDeviceInfo = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        if ([cstrDeviceInfo rangeOfString:@"iPhone4"].location != NSNotFound ||
            [cstrDeviceInfo rangeOfString:@"iPhone5"].location != NSNotFound ||
            [cstrDeviceInfo rangeOfString:@"iPhone6"].location != NSNotFound) {
            g_b_is_bigger_than_ios7 = 1;
            bIsBiggerThanIos7 = YES;
        }else {
            g_b_is_bigger_than_ios7 = -2;
            bIsBiggerThanIos7 = NO;
        }
    }
    return bIsBiggerThanIos7;
}
static int g_b_is_bigger_than_iphone = -1;

+(BOOL)IsBiggerThanIOS7 {
    BOOL bIsBiggerThanIos7 = NO;
    if (g_b_is_bigger_than_iphone > 0) {
        bIsBiggerThanIos7 = YES;
    }else if(g_b_is_bigger_than_iphone == -2){
        bIsBiggerThanIos7 = NO;
    }else if (g_b_is_bigger_than_iphone == -1) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            g_b_is_bigger_than_iphone = -2;
            bIsBiggerThanIos7 = NO;
        } else {
            // Load resources for iOS 7 or later
            g_b_is_bigger_than_iphone = 1;
            bIsBiggerThanIos7 = YES;
        }
    }
    return bIsBiggerThanIos7;
}

@end
