//
//  NSData_XWCrypto.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "NSData_XWCrypto.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (XWCrypto)

- (NSData *)xw_encryptDataWithKey:(NSString *)key type:(NSInteger)type {
    return [self cryptWithData:self type:type encryptOrDecrypt:kCCEncrypt key:key];
}

- (NSData *)xw_decryptDataWithKey:(NSString *)key type:(NSInteger)type {
    return [self cryptWithData:self type:type encryptOrDecrypt:kCCDecrypt key:key];
}

// 通用加密
- (NSData *)cryptWithData:(NSData *)data type:(NSInteger)type encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key {
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt) {
        NSData *decryptData = data;
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else {//encrypt
        NSData* encryptData = data;
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    // 偏移向量，Android、iOS、Java需一致，否则无法相互加解密
    NSString *initIv = @"12345678";
    const void *vkey = nil;
    const void *iv = (const void *) [initIv UTF8String];
    
    if (type == 2) {
        iv = NULL;
        char keyPtr[kCCKeySizeAES256+1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        vkey = keyPtr;
    }else {
        vkey = (const void *) [key UTF8String];
    }
    CCCryptorStatus status;
    //CCCrypt函数 加密/解密
    CCAlgorithm algorithm = 0;
    size_t keyLength = 0;
    switch (type) {
        case 0:{ //DES加密
            dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
            algorithm = kCCAlgorithmDES;
            keyLength = kCCKeySizeDES;
            dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
            memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
        }
            break;
        case 1:{ // 3DES加密
            dataOutAvailable = (dataInLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
            algorithm = kCCAlgorithm3DES;
            keyLength = kCCKeySize3DES;
            dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
            memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
        }
            break;
        case 2:{ // AES加密
            dataOutAvailable = dataInLength + kCCBlockSizeAES128;
            algorithm = kCCAlgorithmAES128;
            keyLength = kCCKeySizeAES256;
            dataOut = malloc( dataOutAvailable);
        }
            break;
        default:
            break;
    }
    status = CCCrypt(encryptOperation,//  加密/解密
                     algorithm,//  加密根据哪个标准（des，3des，aes。。。。）
                     kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                     vkey,  //密钥    加密和解密的密钥必须一致
                     keyLength,//   DES 密钥的大小（kCCKeySizeDES=8）
                     iv, //  可选的初始矢量
                     dataIn, // 数据的存储单元
                     dataInLength,// 数据的大小
                     (void *)dataOut,// 用于返回数据
                     dataOutAvailable,
                     &dataOutMoved);
    
    NSData *resultData = nil;
    if (status == kCCSuccess) {
        resultData = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    }
    
    return resultData;
}


@end
