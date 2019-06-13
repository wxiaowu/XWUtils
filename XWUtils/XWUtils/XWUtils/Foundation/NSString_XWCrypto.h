//
//  NSString_XWCrypto.h
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XWCrypto)

#pragma mark - MD5加密 -
- (NSString *)xw_MD5Digest;

#pragma mark - SHA256 -
- (NSString *)xw_sha256Digest;

#pragma mark - DES/3DES/AES加密 -

/**
 DES/3DES/AES加密

 @param key 秘钥
 @param type 加密类型 0：DES；1：3DES；2：AES256
 @return 加密后的base64字符串
 */
- (NSString *)xw_encryptStringWithKey:(NSString *)key type:(NSInteger)type;
#pragma mark - DES/3DES/AES解密 -

/**
 DES/3DES/AES解密

 @param key 秘钥
 @param type 解密类型 0：DES；1：3DES；2：AES256
 @return 解密后的base64字符串
 */
- (NSString *)xw_decryptStringWithKey:(NSString *)key type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
