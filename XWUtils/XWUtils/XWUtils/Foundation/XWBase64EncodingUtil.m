//
//  XWBase64EncodingUtil.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "XWBase64EncodingUtil.h"

@implementation NSString (AYBase64Encoding)
- (NSData *)xw_base64EncodedData{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSData *)xw_base64DecodedData{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data xw_base64DecodedData];
}

- (NSString *)xw_base64EncodedString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)xw_base64DecodedString{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:kNilOptions];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end


@implementation NSData (AYBase64Encoding)
- (NSString *)xw_base64DecodedString{
    NSData *data = [[NSData alloc] initWithBase64EncodedData:self options:kNilOptions];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)xw_base64EncodedString{
    NSData *data = [self xw_base64EncodedData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)xw_base64EncodedData{
    return [self base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSData *)xw_base64DecodedData{
    return [[NSData alloc] initWithBase64EncodedData:self options:kNilOptions];
}
@end
