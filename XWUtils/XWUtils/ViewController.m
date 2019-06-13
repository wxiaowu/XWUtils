//
//  ViewController.m
//  XWUtilsDemo
//
//  Created by xiaowu on 2019/6/12.
//  Copyright © 2019年 xiaowu. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "UIImage_Util.h"
#import "UIViewController_Util.h"
#import "UIView_Util.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    
    self.imageView.image = [UIImage xw_imageWithGIFNamed:@"test"];
    //    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3344278533,3219749555&fm=26&gp=0.jpg"]];
    //    self.imageView.image = [UIImage xw_imageWithGIFData:imgData];
    [self.imageView sizeToFit];
    self.imageView.center = self.view.center;
    
    //    [UIImage xw_gifWithUrlString:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3344278533,3219749555&fm=26&gp=0.jpg" animatedImageHandler:^(UIImage *animatedImage) {
    //        self.imageView.image = animatedImage;
    //        [self.imageView sizeToFit];
    //        self.imageView.center = self.view.center;
    //    }];
    
    
    // 二维码
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage xw_generateQRCodeWithString:@"https://www.jianshu.com/u/6091a95881e7" withSize:CGSizeMake(200, 200)]];
    // 条形码
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage xw_generateBarcodeWithString:@"1192998575" withSize:CGSizeMake(350, 350)]];
    //    self.imageView.center = self.view.center;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    [vc2 setXw_onControllerResult:^(UIViewController *controller, NSUInteger resultCode, NSDictionary *data) {
        if (resultCode == 1) {
            // deal with data..
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:vc2 animated:YES completion:nil];
    
    
}


@end
