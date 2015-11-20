//
//  WB_Base64Code.m
//  JSwift
//
//  Created by 吕文彬 on 15/11/16.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import "WB_Base64Code.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation WB_Base64Code
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:@""]) {
        NSString * key = @"8f92f9c17ea4c4b7ce078632";
       // NSString * key = [[NSBundle mainBundle]bundleIdentifier];
        NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
        data = [self DESEncrypt:data WithKey:key];
        return [self base64StringFromData:data];
        
    }
    else {
        return @"";
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:@""]) {
       // NSString * key = [[NSBundle mainBundle]bundleIdentifier];
              NSString * key = @"8f92f9c17ea4c4b7ce078632";
        NSData * data = [self dataFromBase64Text:base64];
        data = [self DESDecrypt:data WithKey:key];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        return @"";
    }
}
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
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


+(NSString *)base64StringFromBase64UrlEncodedText:(NSString *)base64UrlEncodedText{
    NSString * s = base64UrlEncodedText;
    s = [s stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    s = [s stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    switch (s.length % 4) {
        case 2:
            s = [s stringByAppendingString:@"=="];
            break;
        case 3:
            s = [s stringByAppendingString:@"="];
            break;
        default:
            break;
    }
    return s;
    
}

+(NSString *)base64UrlEncodedStringFromBase64Text:(NSString *)base64Text{
    NSString * s = base64Text;
    s = [s stringByReplacingOccurrencesOfString:@"=" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return s;
}

+(NSData *)dataFromBase64Text:(NSString *)base64Text{
    NSData * data = nil;
    unsigned char * decodedBytes = NULL;
    @try {
#define __ 255
        static char decodingTable[256] = {
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
            __,__,__,__, __,__,__,__, __,__,__,62, __,__,__,63,  // 0x20 - 0x2F
            52,53,54,55, 56,57,58,59, 60,61,__,__, __, 0,__,__,  // 0x30 - 0x3F
            __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
            15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
            __,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,  // 0x60 - 0x6F
            41,42,43,44, 45,46,47,48, 49,50,51,__, __,__,__,__,  // 0x70 - 0x7F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
        };

        base64Text = [base64Text stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSData * encodedData = [base64Text dataUsingEncoding:NSASCIIStringEncoding];
        unsigned char * encodedBytes = (unsigned char *)[encodedData bytes];
        NSUInteger encodedLength = [encodedData length];
        NSUInteger encodedBlocks = (encodedLength +3) >> 2;
        NSUInteger expectedDataLength = encodedBlocks * 3;
        unsigned char decodingBlock[4];
        decodedBytes = malloc(expectedDataLength);
        if (decodedBytes != NULL) {
            NSUInteger i = 0;
            NSUInteger j = 0;
            NSUInteger k = 0;
            unsigned char c;
            while (i < encodedLength) {
                c = decodingTable[encodedBytes[i]];
                i++;
                if (c != __) {
                    decodingBlock[j] = c;
                    j++;
                    if (j == 4) {
                        decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                        decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                        decodedBytes[k+2] = (decodingBlock[2] << 6) | (decodingBlock[3]);
                        j = 0;
                        k += 3;
                    }
                    
                }
            }
            if(j == 3) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                k += 2;
            }else if (j == 2) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                k += 1;
            }
            data = [[NSData alloc]initWithBytes:decodedBytes length:k];
            
        }
        
    }
    @catch (NSException *exception) {
        data = nil;
    }
    @finally {
        if (decodedBytes != NULL) {
            free(decodedBytes);
        }
        
        
    }
    return data;


}



+(NSString *)base64StringFromData:(NSData *)data
{
    NSString * encoding = nil;
    unsigned char * encodingBytes = NULL;
    @try {
        static char  encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = (dataLength * 8) / 24;
        NSUInteger padding = paddingTable[dataLength % 3];
        if (padding > 0) {
            encodedBlocks ++;
        }
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if (encodingBytes != NULL) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            
            unsigned char * rawBytes = (unsigned char *)[data bytes];
            unsigned char rawByte1,rawByte2,rawByte3;
            while (rawBytesToProcess >= 3) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex + 1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F)];
                encodingBytes[encodingBaseIndex + 2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03)];
                encodingBytes[encodingBaseIndex + 3] = encodingTable[(rawByte3 & 0x3F)];
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
                
                
            }
            rawByte2 = 0;
            switch (dataLength - rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex + 1];
                  // break;
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex + 1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F)];
                    encodingBytes[encodingBaseIndex + 2] = encodingTable[((rawByte2 << 2) & 0x3C)];
                    break;
                default:
                    break;
            }
            encodingBaseIndex = encodedLength - padding;
            while (padding-- > 0) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc]initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
    }
    @finally {
        if (encodingBytes != NULL) {
            free(encodingBytes);
        }
    }
    return encoding;
   
}
@end

@implementation NSString (Base64Code)

-(NSString *)base64String
{
    NSData * utf8encoding = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [WB_Base64Code base64StringFromData:utf8encoding];
}
-(NSString *)base64UrlEncodedString
{
    return [WB_Base64Code base64UrlEncodedStringFromBase64Text:[self base64String]];
    
}

+(NSString *)stringFromBase64Text:(NSString *)base64Text
{
    NSData * utf8encoding = [WB_Base64Code dataFromBase64Text:base64Text];
    return [[NSString alloc]initWithData:utf8encoding encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringFromBase64UrlEncodedText:(NSString *)base64UrlEncodedText
{
    return [self stringFromBase64Text:[WB_Base64Code base64StringFromBase64UrlEncodedText:base64UrlEncodedText]];
}


@end


@implementation NSData (Base64Code)

+ (NSData *)dataWithBase64Text:(NSString *)base64Text
{
    return [WB_Base64Code dataFromBase64Text:base64Text];
}

+ (NSData *)dataWithBase64UrlEncodedText:(NSString *)base64UrlEncodedText
{
    return [self dataWithBase64Text:[WB_Base64Code base64StringFromBase64UrlEncodedText:base64UrlEncodedText]];
}

-(NSString *)base64String
{
    return [WB_Base64Code base64StringFromData:self];
}

-(NSString *)base64UrlEncodedString
{
    return [WB_Base64Code base64UrlEncodedStringFromBase64Text:[self base64String]];
}

@end
