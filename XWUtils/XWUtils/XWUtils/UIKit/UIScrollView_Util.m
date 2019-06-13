//
//  UIScrollView_Util.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "UIScrollView_Util.h"

@implementation UIScrollView (Util)

- (void)xw_longSnapshot:(CGFloat)limitedHeight complete:(void (^)(UIImage *snapshot))completeHandle {
    // 1. 获取当前 scrollview 的偏移量，以便截图结束后还原现场
    CGPoint beforeSnapOffset = self.contentOffset;
    
    // 2. 将 scrollview 按照实际内容高度分页
    CGSize fullPageSize = self.contentSize;
    CGSize screenSize = self.bounds.size;
    if (limitedHeight != 0) {
        if (limitedHeight < fullPageSize.height) {
            fullPageSize.height = limitedHeight;
        }
    }
    NSInteger page = ceil(fullPageSize.height / screenSize.height);
    
//    [SVProgressHUD show];
    self.userInteractionEnabled = NO;
    
    // 开启绘图上下文
    /**
     * 开启画图上下文，大小为 webView 的 scrollView 的大小
     * @param size : size是指绘图上下文的宽高，可以理解为要绘制图形的画布的大小
     * @param opaque ： 是否透明，如果传YES，画布的背景色为黑色，NO的时候，画布背景色是白色
     * @param scale：指的是绘制出来的图片的像素比，决定了绘图图片的清晰度，一般填0.0，默认屏幕缩放比
     */
    UIGraphicsBeginImageContextWithOptions(fullPageSize, YES, 0);
    
    [self screenshotWithView:self index:0 numberOfPage:page andCompletion:^{
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setContentOffset:beforeSnapOffset];
        
        self.userInteractionEnabled = YES;
//        [SVProgressHUD dismiss];
        completeHandle(snapshot);
    }];
}

/**
 * 递归调用的截图方法
 * @param view 被绘制的 View
 * @param index 当前截图的页数
 * @param page 截图的总页数
 * @param completion 截图完成的回调
 */
- (void)screenshotWithView:(UIView *)view index:(NSInteger)index numberOfPage:(NSInteger)page andCompletion:(dispatch_block_t)completion {
    CGRect splitFrame = CGRectMake(0, index * CGRectGetHeight(view.bounds), view.bounds.size.width, view.frame.size.height);
    CGRect frame = self.frame;
    frame.origin.y = (index * self.frame.size.height);
    [self setContentOffset:frame.origin];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        if (index < page) {
            [self screenshotWithView:view index:index + 1 numberOfPage:page andCompletion:completion];
        } else {
            completion();
        }
    });
}

@end
