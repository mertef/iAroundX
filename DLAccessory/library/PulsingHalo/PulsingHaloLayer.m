//
//  PulsingHaloLayer.m
//  https://github.com/shu223/PulsingHalo
//
//  Created by shuichi on 12/5/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//
//  Inspired by https://github.com/samvermette/SVPulsingAnnotationView


#import "PulsingHaloLayer.h"


@interface PulsingHaloLayer ()
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@end


@implementation PulsingHaloLayer

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.radius = 60;
        self.animationDuration = 1;
        self.pulseInterval = 0;
        self.backgroundColor = [[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] CGColor];
        [self setupAnimationGroup];

        
    }
    return self;
}

- (void)setRadius:(CGFloat)radius {

    _radius = radius;
    
    CGPoint tempPos = self.position;

    CGFloat diameter = self.radius * 2;

    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
//    NSLog(@"duration is %f", self.animationGroup.duration);
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@0.45, @0.45, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
}

-(void)startAnimation {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        if(self.pulseInterval != INFINITY) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self addAnimation:self.animationGroup forKey:@"pulse"];
            });
        }
    });
}
-(void)stopAnimation {
    [self removeAnimationForKey:@"pulse"];
}
@end
