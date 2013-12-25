//
//  DLViewIndicator.m
//  DLAccessory
//
//  Created by Mertef on 12/25/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLViewIndicator.h"
#import <QuartzCore/QuartzCore.h>
@implementation DLViewIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cnumberIndicator = @0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef rCtx = UIGraphicsGetCurrentContext();
    NSString* cstrNumber = [self.cnumberIndicator stringValue];
    CGMutablePathRef rmutPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(rmutPath, NULL, rect);
    CGContextAddPath(rCtx, rmutPath);
    CGPathRelease(rmutPath); rmutPath = NULL;
    CGContextClip(rCtx);
    CGContextSetFillColorWithColor(rCtx, [UIColor greenColor].CGColor);
    CGContextFillRect(rCtx, rect);
    CGColorSpaceRef rColorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGFloat farrLocations[3] = {0.5f,0.8f,0.9f};
    CGGradientRef rGradient = CGGradientCreateWithColors(rColorSpace, (__bridge CFArrayRef)@[[UIColor greenColor], [UIColor blueColor], [UIColor orangeColor]], farrLocations);
    
    CGContextDrawRadialGradient(rCtx, rGradient, self.center, 0.0f, self.center, CGRectGetWidth(rect), kCGGradientDrawsBeforeStartLocation);
    CGColorSpaceRelease(rColorSpace);rColorSpace = nil;
    CGGradientRelease(rGradient); rGradient = nil;
    if ([self.cnumberIndicator intValue] > 99) {
        cstrNumber = @"99+";
    }
    CGRect sRectBound = [cstrNumber boundingRectWithSize:CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                                                                            NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                                                                                                                                            
                                                                                                                                                                            } context:nil];
    [cstrNumber drawAtPoint:CGPointMake((CGRectGetWidth(rect) - CGRectGetWidth(sRectBound)) * 0.5f, (CGRectGetHeight(rect) - CGRectGetHeight(sRectBound)) * 0.5f) withAttributes:@{
                                                                                                                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                                                                                 NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}];
                                                                                                                                                                                 
                                                                                                                                                                                 
}


@end
