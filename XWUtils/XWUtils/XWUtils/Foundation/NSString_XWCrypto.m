//
//  NSString_XWCrypto.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "NSString_XWCrypto.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData_XWCrypto.h"
#import "XWBase64EncodingUtil.h"

@implementation NSString (XWCrypto)

#pragma mark - MD5加密 -
- (NSString *)xw_MD5Digest {
    // 转成utf-8字符串
    const char *cStr = self.UTF8String;
    // 设置一个接收数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 对密码进行加密
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    // 转成32字节的16进制
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str.uppercaseString;
}

#pragma mark - SHA256 -
- (NSString *)xw_sha256Digest {
    const char* str = self.UTF8String;
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


#pragma mark - DES/3DES/AES加密 -
- (NSString *)xw_encryptStringWithKey:(NSString *)key type:(NSInteger)type {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data xw_encryptDataWithKey:key type:type];
    return [encryptData xw_base64EncodedString];
}
#pragma mark - DES/3DES/AES解密 -
- (NSString *)xw_decryptStringWithKey:(NSString *)key type:(NSInteger)type {
    NSData *data = [self xw_base64DecodedData];
    NSData *decryptData = [data xw_decryptDataWithKey:key type:type];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end
