//
//  EZWebViewControllerExample.m
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/1/19.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZWebViewControllerExample.h"
#import <EZUIKit/EZUIKit.h>
@interface EZWebViewControllerExample ()

@end

@implementation EZWebViewControllerExample

-(void)awakeFromNib{
    NSLog(@"ss");
}

-(void)loadView{
    NSLog(@"");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)pushAction1:(UIButton *)sender {
   EZWebViewController *webviewController = [[EZWebViewController alloc] init];
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webviewController];
    webviewController.toolView.toolbarTintColor = [UIColor redColor];
    webviewController.toolView.toolbarBackgroundColor = [UIColor yellowColor];
    
    webviewController.tintColor = [UIColor greenColor];
    
    [self.navigationController  pushViewController:webviewController animated:YES];
    //    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://github.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0]];
    [webviewController loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://github.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0]];
// [UITableView]
    
}


- (IBAction)presentActon1:(id)sender {
    UINavigationController *navigationController = [EZWebViewController navigationControllerWithWebViewController];
    [self presentViewController:navigationController animated:YES completion:^{
        [navigationController.rootEZWebViewController loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://github.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0]];

    }];
}

@end
