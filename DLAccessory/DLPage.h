//
//  DLPage.h
//  DLAccessory
//
//  Created by Mertef on 1/21/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLPage : NSObject
@property(assign, nonatomic) NSUInteger uiCount;
@property(assign, nonatomic) NSUInteger uiCurrentPage;
@property(assign, nonatomic) NSUInteger uiAllPage;
@property(assign, nonatomic) NSUInteger uiOffset;
@property(assign, nonatomic) NSUInteger uiLimit;
@property(assign, nonatomic) BOOL bIsLoading;
@property(assign, nonatomic) BOOL bIsAllLoaded;

-(void)reset;
@end
