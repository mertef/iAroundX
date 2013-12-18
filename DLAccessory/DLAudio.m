//
//  DLAudio.m
//  DLAccessory
//
//  Created by Mertef on 12/18/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLAudio.h"
@interface DLAudio()  {
    
}
- (UIImage *) partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest orginImage:(UIImage *)originImage;

@end
@implementation DLAudio

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* cimageBg = [UIImage imageNamed:@"mic_n"];
        _cimageviewBg = [[UIImageView alloc] initWithImage:cimageBg];
        [self addSubview:_cimageviewBg];
        
        UIImage* cimageNormal = [UIImage imageNamed:@"mic_center_normal"];
        _cimageviewCenterNormal = [[UIImageView alloc] initWithImage:cimageNormal];
        [self addSubview:_cimageviewCenterNormal];
        UIImage* cimageActive = [UIImage imageNamed:@"mic_center_active"];
        _cimageviewCenterActive = [[UIImageView alloc] initWithImage:cimageActive];
        [self addSubview:_cimageviewCenterActive];
        self.fProgress = 0.4f;
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _cimageviewBg.frame = CGRectMake((CGRectGetWidth(self.bounds) - _cimageviewBg.image.size.width) * 0.5f, (CGRectGetHeight(self.bounds) - _cimageviewBg.image.size.height) * 0.5f, _cimageviewBg.image.size.width, _cimageviewBg.image.size.height);
    
    _cimageviewCenterNormal.center = CGPointMake(_cimageviewBg.center.x, _cimageviewBg.center.y -2.0f);
    
    _cimageviewCenterActive.center =  _cimageviewCenterNormal.center;

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIImage *) partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest orginImage:(UIImage *)originImage {
    const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, originImage.size.width * originImage.scale, originImage.size.height * originImage.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [originImage CGImage]);
    
    int x_origin = vertical ? 0 : width * percentage;
    int y_to = vertical ? height * (1.f -percentage) : height;
    
    for(int y = 0; y < y_to; y++) {
        for(int x = x_origin; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            if (grayscaleRest) {
                // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                
                // set the pixels to gray
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            }
            else {
                rgbaPixel[ALPHA] = 0;
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:originImage.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

-(void)startAnimation {
    
    _c_timer_update = [NSTimer scheduledTimerWithTimeInterval:.2f target:self selector:@selector(actionTimerUpdate:) userInfo:nil repeats:YES];
    
}
-(void)actionTimerUpdate:(NSTimer*)acTimer {
    @autoreleasepool {
        if (_b_should_stop) {
            [_c_timer_update invalidate];
            _c_timer_update = nil;
            return;
        }
//        __weak typeof(self) _self = self;
        [UIView animateWithDuration:.2f animations:^(void){
            UIImage* cimageActive = [UIImage imageNamed:@"mic_center_active"];
            UIImage* cimageActivePartial = [self partialImageWithPercentage:self.fProgress vertical:YES grayscaleRest:NO orginImage:cimageActive];
            
            _cimageviewCenterActive.image = cimageActivePartial;
        } completion:^(BOOL abFinished){
            if (abFinished) {
                self.fProgress += 0.1f;
                if (self.fProgress > 1.0f) {
                    self.fProgress = 0.4f;
                }
            }
            
        }];
    }}
-(void)stopAnimation{
    _b_should_stop = YES;
}

@end
