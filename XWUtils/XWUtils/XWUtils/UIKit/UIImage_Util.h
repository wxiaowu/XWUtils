//
//  UIImage_Util.h
//  XWUtilsDemo
//
//  Created by xiaowu on 2019/6/12.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gif)

/**
 解析GIF图片data数据，返回GIF image对象
 
 @param data GIF图片数据
 @return GIF image对象
 */
+ (UIImage *)xw_imageWithGIFData:(NSData *)data;

/** 根据一个GIF图片的URL,回调GIF image对象,支持http协议和file协议
 * @param urlString : GIF资源URL地址
 * @param animatedImageHandler : GIF image回调
 */
+ (void)xw_gifWithUrlString:(NSString *)urlString
       animatedImageHandler:(void(^)(UIImage * animatedImage))animatedImageHandler;

/**
 根据本地GIF图片名,返回GIF image对象
 
 @param name 本地GIF图片名
 @return GIF image对象
 */
+ (UIImage *)xw_imageWithGIFNamed:(NSString *)name;


@end

@interface UIImage (CodeGenerator)

/**
 根据二维码信息生成图片
 
 @param  str 二维码信息
 @param  size 图片大小
 @return 返回UIImage
 */
+ (UIImage *)xw_generateQRCodeWithString:(NSString *)str withSize:(CGSize)size;


/**
 根据条形码信息生成图片
 
 @param  str 条形码信息
 @param  size 图片大小
 @return 返回UIImage
 */
+ (UIImage *)xw_generateBarcodeWithString:(NSString *)str withSize:(CGSize)size;


@end


@interface UIImage (Utils)

/**
 *  返回圆形图片
 */
- (UIImage *)xw_circleImage;

@end

