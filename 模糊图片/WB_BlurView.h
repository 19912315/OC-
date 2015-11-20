//
//  WB_BlurView.h
//  WBTools
//
//  Created by LV on 15/9/18.
//  Copyright (c) 2015年 MeiLiZu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WB_BlurView : NSObject

// 模糊文字
+ (void)blurLabel:(UILabel * )label;

// 模糊视图
+ (void)blurView:(UIView *)view withBlur:(CGFloat)blur;

// 模糊图片
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
