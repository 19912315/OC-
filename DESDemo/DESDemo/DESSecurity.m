//
//  DESSecurity.m
//  DESDemo
//
//  Created by 吕文彬 on 15/11/17.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import "DESSecurity.h"
#import <CommonCrypto/CommonCryptor.h>
static Byte iv[] = {1,2,3,4,5,6,7,8};
@implementation DESSecurity
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString * ciphertext = nil;
    const char * textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,kCCAlgorithmDES,kCCOptionPKCS7Padding,[key UTF8String],kCCKeySizeDES,iv,textBytes,dataLength,buffer,1024,&numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithCarriageReturn)];
        
        
    }
    return ciphertext;
}


@end
