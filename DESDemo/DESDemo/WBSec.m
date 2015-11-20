//
//  WBSec.m
//  DESDemo
//
//  Created by 吕文彬 on 15/11/17.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//
#define DESKEY @"8f92f9c17ea4c4b7ce078632"
#import "WBSec.h"

@implementation WBSec
+ (NSString *)DEStext:(NSString *)text crypt:(CCOperation)crypt
{
    const void * vplainText;
    size_t plainTextBufferSize;
    if (crypt == kCCDecrypt)
    {
        NSData * EncryptData = [[NSData alloc]initWithBase64EncodedString:text options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else
    {
        NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void * vkey = (const void *)[DESKEY UTF8String];
    ccStatus = CCCrypt(crypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding | kCCOptionECBMode, vkey, kCCKeySize3DES, nil, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    NSString * result;
    if (crypt == kCCDecrypt) {
        result = [[NSString alloc]initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    } else
    {
        NSData * myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [myData base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithLineFeed)];
        
    }
    return result;
}

+ (NSData *)DESEncryptText:(NSString *)text
{
    const void * vplainText;
    size_t plainTextBufferSize;
        NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void * vkey = (const void *)[DESKEY UTF8String];
    ccStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding | kCCOptionECBMode, vkey, kCCKeySize3DES, nil, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);

        NSData * myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
       return [myData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}




@end
