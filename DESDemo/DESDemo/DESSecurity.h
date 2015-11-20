//
//  DESSecurity.h
//  DESDemo
//
//  Created by 吕文彬 on 15/11/17.
//  Copyright © 2015年 MeiLiZu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BASE64(text) [DESSecurity encryptUseDES:text key:@"8f92f9c17ea4c4b7ce078632"]
@interface DESSecurity : NSObject
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
@end
