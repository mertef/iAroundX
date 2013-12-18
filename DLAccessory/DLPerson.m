//
//  DLPerson.m
//  DLAccessory
//
//  Created by Mertef on 12/9/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLPerson.h"

@implementation DLPerson

- (void)dealloc
{
    NSLog(@"I am dealloccated!");
}
-(NSString*)description {
    NSMutableString* cstrDesc = [[NSMutableString alloc] initWithFormat:@"%@ %@ %@", _cstrName, _cstrAddress, _cstrTel];
    return cstrDesc;
}
@end
