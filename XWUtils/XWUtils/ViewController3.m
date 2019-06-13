//
//  ViewController3.m
//  XWUtils
//
//  Created by xiaowu on 2019/6/13.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "ViewController3.h"
#import "UIScrollView_Util.h"
#import "UIViewController_Util.h"

@interface ViewController3 ()
@property (nonatomic, strong) UIWebView *webview;

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/u/6091a95881e7"]]];
    [self.view addSubview:webview];
    self.webview = webview;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btn setTitle:@"截图" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)btn {
    [self.webview.scrollView xw_longSnapshot:2000 complete:^(UIImage * _Nonnull snapshot) {
        self.xw_onControllerResult(self, 1, @{@"image":snapshot});
    }];
}



@end
