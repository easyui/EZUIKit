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
