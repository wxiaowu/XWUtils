//
//  XWBase64EncodingUtil.h
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XWBase64Encoding)
- (NSData *)xw_base64EncodedData; /**< base 64 编码 */
- (NSData *)xw_base64DecodedData; /**< base 64 解码 */
- (NSString *)xw_base64EncodedString; /**< base 64 编码后的字符串 */
- (NSString *)xw_base64DecodedString; /**< base 64 解码后的字符串 */
@end

@interface NSData (XWBase64Encoding)
- (NSString *)xw_base64EncodedString; /**< base 64 编码后的字符串 */
- (NSString *)xw_base64DecodedString; /**< base 64 解码后的字符串 */
- (NSData *)xw_base64EncodedData; /**< base 64 编码后的二进制 */
- (NSData *)xw_base64DecodedData; /**< base 64 解码后的二进制 */
@end
