//
//  UIScrollView_Util.h
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Util)

/**
 长截图

 @param limitedHeight 高度限制，为0表示截取整个scrollview的内容
 @param completeHandle 完成回调
 */
- (void)xw_longSnapshot:(CGFloat)limitedHeight complete:(void (^)(UIImage *snapshot))completeHandle;

@end

NS_ASSUME_NONNULL_END
