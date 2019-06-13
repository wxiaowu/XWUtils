//
//  UIView_Util.h
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Util)

@property (nonatomic, assign) CGSize size; /**< 尺寸 */
@property (nonatomic, assign) CGFloat width; /**< 宽度 */
@property (nonatomic, assign) CGFloat height; /**< 高度 */
@property (nonatomic, assign) CGFloat x; /**< 原点坐标x */
@property (nonatomic, assign) CGFloat y; /**< 原点坐标y */

@property (nonatomic, assign) CGFloat centerX; /**< 中心点坐标x */
@property (nonatomic, assign) CGFloat centerY; /**< 中心点坐标y */

- (void)xw_clearSubviews; /**< 清除所有子视图 */
- (__kindof UIViewController *)xw_currentViewController;/**< 获取View所在的controller */
- (UIImage *)xw_snapshot; /**< 截图 */

@end

NS_ASSUME_NONNULL_END
