//
//  WB_Base64Code.h
//  JSwift
//
//  Created by 吕文彬 on 15/11/16.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64Code)
+ (NSString *)stringFromBase64Text:(NSString *)base64Text;
+ (NSString *)stringFromBase64UrlEncodedText:(NSString *)base64UrlEncodedText;
- (NSString *)base64String;
- (NSString *)base64UrlEncodedString;

@end

@interface NSData (Base64Code)
+ (NSData *)dataWithBase64Text:(NSString *)base64Text;
+ (NSData *)dataWithBase64UrlEncodedText:(NSString *)base64UrlEncodedText;
- (NSString *)base64String;
- (NSString *)base64UrlEncodedString;
@end
#define __BASE64(text) [WB_Base64Code base64StringFromText:text]
#define __TEXT(base64) [WB_Base64Code textFromBase64String:base64]
@interface WB_Base64Code : NSObject
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;


+ (NSData *)dataFromBase64Text:(NSString *)base64Text;
+ (NSString *)base64StringFromData:(NSData *)data;
+ (NSString *)base64UrlEncodedStringFromBase64Text:(NSString *)base64Text;
+ (NSString *)base64StringFromBase64UrlEncodedText:(NSString *)base64UrlEncodedText;
@end
