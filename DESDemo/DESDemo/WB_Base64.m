//
//  WB_Base64.m
//  DESDemo
//
//  Created by 吕文彬 on 15/11/16.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import "WB_Base64.h"
#import <CommonCrypto/CommonCryptor.h>
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
@implementation WB_Base64

+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:@""]) {
    //    NSString * key = [[NSBundle mainBundle]bundleIdentifier];
        NSString * key = @"8f92f9c17ea4c4b7ce078632";
        NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
        data = [self DESEncrypt:data withKey:key];
        return [self base64EncodedStringFrom:data];
    }
    else{
        return @"";
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:@""]) {
      //  NSString * key = [[NSBundle mainBundle]bundleIdentifier];
        NSString * key = @"8f92f9c17ea4c4b7ce078632";
        NSData * data = [self dataWithBase64EncodedString:base64];
        data = [self DESDecrypt:data withKey:key];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    else{
        return @"";
    }
}


+ (NSData *)DESEncrypt:(NSData *)data withKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)DESDecrypt:(NSData *)data withKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil) {
        [NSException raise:NSInvalidArgumentException format:nil];
    }
    if ([string length] == 0) {
        return [NSData data];
    }
    static char * decodingTable = NULL;
    if (decodingTable == NULL) {
        decodingTable = malloc(256);
        if (decodingTable == NULL) {
            return nil;
        }
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64 ; i++) {
            decodingTable[(short)encodingTable[i]] = i;
        }
    }
    const char * characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL) {
        return nil;
    }
    char * bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL) {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    while (YES) {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++) {
            if (characters[i] == '\0') {
                break;
            }
            if (isspace(characters[i]) || characters[i] == '=') {
                continue;
            }
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX) {
                free(bytes);
                return nil;
                
            }
        }
        if (bufferLength == 0) {
            break;
        }
        if (bufferLength == 1) {
            free(bytes);
            return nil;
        }
        
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2) {
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        }
        
        if (bufferLength > 3) {
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
    
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0) {
        return @"";
    }
    char * characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL) {
        return nil;
    }
    NSUInteger length = 0;
    NSUInteger i = 0;
    while (i < [data length]) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length]) {
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        }
            characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
            characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >>4)];
            if (bufferLength > 1) {
                characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
                
            }else{
                characters[length++] = '=';
            }
            if (bufferLength > 2) {
                characters[length++] = encodingTable[buffer[2] & 0x3F];
            }else{
                characters[length++] = '=';
            }
        }
    return [[NSString alloc]initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
@end
