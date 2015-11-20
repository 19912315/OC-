//
//  WB_BlurView.m
//  WBTools
//
//  Created by LV on 15/9/18.
//  Copyright (c) 2015年 MeiLiZu. All rights reserved.
//

#import "WB_BlurView.h"
#import <Accelerate/Accelerate.h>
@implementation WB_BlurView

+ (void)blurLabel:(UILabel * )label{
    
    CATextLayer * textLayer = [CATextLayer layer];
    textLayer.frame = label.bounds;
    [label.layer addSublayer:textLayer];
    textLayer.foregroundColor = label.textColor.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    
    CFStringRef fontname = (__bridge CFStringRef)label.font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontname);
    textLayer.font = fontRef;
    textLayer.fontSize = label.font.pointSize;
    CGFontRelease(fontRef);
    textLayer.string = label.text;
    textLayer.contentsScale = 0.1;
    UIView * view = [[UIView alloc]initWithFrame:label.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.88;
    [label addSubview:view];
}

+ (void)blurView:(UIView *)view withBlur:(CGFloat)blur{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 2.将view的所有内容渲染到图形上下文中
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    // 3.取得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImage * blurImage = [self blurryImage:image withBlurLevel:blur];
    UIImageView * blurImageView = [[UIImageView alloc]initWithFrame:view.bounds];
    blurImageView.alpha = 0.6;
    blurImageView.image = blurImage;
   
    UIView * view1 = [[UIView alloc]initWithFrame:view.bounds];
    view1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    [view addSubview:view1];
 
    [view addSubview:blurImageView];
  
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    if (blur<0 || blur >1) {
        blur = 0.5;
    }
    NSInteger boxSize = (NSInteger)(100*blur);
    boxSize = boxSize - (boxSize % 2)+1;
    CGImageRef img = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)].CGImage;
    vImage_Buffer inBuffer,outBuffer,rgbOutBuffer;
    vImage_Error error;
    void * pixelBuffer, * convertBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    convertBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    rgbOutBuffer.width = CGImageGetWidth(img);
    rgbOutBuffer.height = CGImageGetHeight(img);
    rgbOutBuffer.rowBytes = CGImageGetBytesPerRow(img);
    rgbOutBuffer.data = convertBuffer;
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img)*CGImageGetHeight(img));
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    void * rgbConvertBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    vImage_Buffer outRGBBuffer;
    outRGBBuffer.width = CGImageGetWidth(img);
    outRGBBuffer.height = CGImageGetHeight(img);
    outRGBBuffer.rowBytes = 3;
    outRGBBuffer.data = rgbConvertBuffer;
   
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld",error);
    }
    const uint8_t mask[] = {2,1,0,3};
    vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, kvImageNoFlags);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(rgbOutBuffer.data, rgbOutBuffer.width, rgbOutBuffer.height, 8,rgbOutBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage * returnImage = [[UIImage imageWithCGImage:imageRef] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    CGContextRelease(ctx);
    free(pixelBuffer);
    free(convertBuffer);
    free(rgbConvertBuffer);
    
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
    
}


@end
