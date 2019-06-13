//
//  ViewController2.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "ViewController2.h"
#import "UIViewController_Util.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.xw_onControllerResult(self, 1, @{});
}


@end
