//
//  UIImage_Util.m
//  XWUtilsDemo
//
//  Created by xiaowu on 2019/6/12.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "UIImage_Util.h"

@implementation UIImage (Gif)

+ (UIImage *)xw_imageWithGIFData:(NSData *)data{
    if (!data) return nil;
    // 通过文件的 data 数据 来将 gif 文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 获取 gif 文件中的图片个数
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        // 存放所有图片
        NSMutableArray *imageArray = [NSMutableArray array];
        // 定义一个变量记录 gif 播放一轮的时间
        NSTimeInterval duration = 0.0f;
        for(size_t i = 0;i < count; i++){
            // 获取每一张图片
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            [imageArray addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
            // 获取图片信息
            NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            // 获取每一帧动画时长
            NSTimeInterval delayTime = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
            duration += delayTime;
            
            //            CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth]floatValue];
            //            CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight]floatValue];
        }
        animatedImage = [UIImage animatedImageWithImages:imageArray duration:duration];
    }
    
    // 释放Gif图片数据源
    CFRelease(source);
    return animatedImage;
}

+ (void)xw_gifWithUrlString:(NSString *)urlString
       animatedImageHandler:(void(^)(UIImage * animatedImage))animatedImageHandler {
    NSURL *url = [urlString hasPrefix:@"http"] ? [NSURL URLWithString:urlString] : [NSURL fileURLWithPath:urlString];
    if (!url) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *gifData = [NSData dataWithContentsOfURL:url];
        // 刷新UI在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            animatedImageHandler([UIImage xw_imageWithGIFData:gifData]);
        });
    });
}


+ (UIImage *)xw_imageWithGIFNamed:(NSString *)name {
    NSUInteger scale = (NSUInteger)[UIScreen mainScreen].scale;
    return [self xw_gifName:name scale:scale];
}

+ (UIImage *)xw_gifName:(NSString *)name scale:(NSUInteger)scale {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    if  (!imagePath) {
        imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", name] ofType:@"gif"];
    }
    if (!imagePath) {
        (scale + 1 > 3) ? (scale -= 1) : (scale += 1);
        imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    }
    if (imagePath) {
        // 传入图片名(不包含@Nx)
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        return [UIImage xw_imageWithGIFData:imageData];
    } else {
        imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        if (imagePath) {
            // 传入的图片名已包含@Nx or 传入图片只有一张 不分@Nx
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            return [UIImage xw_imageWithGIFData:imageData];
        } else {
            // 不是一张GIF图片(后缀不是gif)
            return [UIImage imageNamed:name];
        }
    }
}


@end

typedef NS_ENUM(NSInteger, XWCodeGeneratorMode) {
    XWCodeGeneratorModeQRCode = 0,
    XWCodeGeneratorModeBarcode
};
@implementation UIImage (CodeGenerator)

// 根据字符串内容生成二维码
+ (UIImage *)xw_generateQRCodeWithString:(NSString *)str withSize:(CGSize)size {
    return [self xw_generateCodeWithString:str withSize:size withMode:XWCodeGeneratorModeQRCode];
    
}

// 根据字符串内容生成条形码
+ (UIImage *)xw_generateBarcodeWithString:(NSString *)str withSize:(CGSize)size {
    return [self xw_generateCodeWithString:str withSize:size withMode:XWCodeGeneratorModeBarcode];
}

+ (UIImage *)xw_generateCodeWithString:(NSString *)str withSize:(CGSize)size withMode:(XWCodeGeneratorMode)mode {
    CIFilter *filter = [CIFilter filterWithName:mode == XWCodeGeneratorModeQRCode ? @"CIQRCodeGenerator" : @"CICode128BarcodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *ciimage = [filter outputImage];
    // 由于filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *image = [self xw_createNonInterpolatedUIImageFormCIImage:ciimage withSize:size];
    
    return image;
}

/// 根据CIImage, 和指定大小, 生成UIImage图片
+ (UIImage *)xw_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    // 上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    // 设置上下文无插值
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    // 设置上下文缩放
    CGContextScaleCTM(bitmapRef, scale, scale);
    // 在上下文中的extent中绘制imageRef
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end


@implementation  UIImage (Utils)

- (UIImage *)xw_circleImage {
    // NO代表透明,图形上下文跟头像一样大小,再往上面画个圆形路径,所以四个角要透明不然默认会有黑色
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect); // 在矩形框里面添加一个椭圆
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
