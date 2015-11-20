//
//  WB_Base64.h
//  DESDemo
//
//  Created by 吕文彬 on 15/11/16.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _BASE64_(text) [WB_Base64 base64StringFromText:text]
#define _TEXT_(base64) [WB_Base64 textFromBase64String:base64]
@interface WB_Base64 : NSObject
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
@end
