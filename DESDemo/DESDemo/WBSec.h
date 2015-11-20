//
//  WBSec.h
//  DESDemo
//
//  Created by 吕文彬 on 15/11/17.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SEC(text) [WBSec DEStext:text crypt:kCCEncrypt]
#define DESec(text) [WBSec DEStext:text crypt:kCCDecrypt]
#import <CommonCrypto/CommonCryptor.h>

@interface WBSec : NSObject
+ (NSString *)DEStext:(NSString *)text crypt:(CCOperation)crypt;
@end
