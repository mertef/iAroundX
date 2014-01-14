//
//  DLCircle.m
//  DLAccessory
//
//  Created by Mertef on 1/14/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLCircle.h"

@implementation DLCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGMutablePathRef rmutPath = CGPathCreateMutable();
    CGPoint spointCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPathAddArc(rmutPath, NULL, spointCenter.x, spointCenter.y, CGRectGetHeight(rect) * 0.4f, 0.0f, M_PI, true);
    CGContextRef rctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(rctx, rmutPath);
//    CGContextSetFillColorWithColor(rctx, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(rctx, [UIColor redColor].CGColor);
    CGContextStrokePath(rctx);
}


@end
