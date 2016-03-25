//
//  EZFloatContainerRootViewController.m
//  ezvideodemo
//
//  Created by yangjun zhu on 16/3/3.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZFloatContainerRootViewController.h"
#import "EZFloatContainer.h"

@implementation EZFloatContainerRootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}


/*fixed ios8 rootViewController.view.bounds is wrong.
 -[UIWindow viewForFirstBaselineLayout]: unrecognized selector sent to instance 0x61600008d080
 */
-(void)viewDidLayoutSubviews{
    if([[UIDevice currentDevice].systemVersion doubleValue] < 9.0){
        self.view.frame = self.view.window.bounds;
    }
}

-(BOOL)shouldAutorotate
{
    return self.floatContainer.shouldAutorotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.floatContainer.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.floatContainer.preferredStatusBarStyle;
}

-(BOOL)prefersStatusBarHidden{
    return self.floatContainer.prefersStatusBarHidden;
}


@end
