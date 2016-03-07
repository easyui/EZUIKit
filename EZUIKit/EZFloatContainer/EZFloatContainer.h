//
//  EZFloatContainer.h
//  ezvideodemo
//
//  Created by yangjun zhu on 16/3/3.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class  EZFloatContainerRootViewController;
@interface EZFloatContainer : NSObject
@property (assign, nonatomic,readonly)BOOL isShow;


#pragma mark - Autorotation
@property (assign, nonatomic)  BOOL shouldAutorotate;//default: YES
@property (assign, nonatomic)  UIInterfaceOrientationMask supportedInterfaceOrientations;//default: iPhone(UIInterfaceOrientationMaskPortrait) iPad(UIInterfaceOrientationMaskLandscape)

#pragma mark - StatusBar
@property (assign, nonatomic)  BOOL prefersStatusBarHidden;//default: NO
@property (assign, nonatomic)  UIStatusBarStyle preferredStatusBarStyle;//default: UIStatusBarStyleDefault

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame rootViewController:(EZFloatContainerRootViewController *)rootViewController  ;//NS_DESIGNATED_INITIALIZER;
#pragma mark - action

- (void)show;
- (void)hidden;
- (void)addSubview:(UIView *)view;
- (void)addChildViewController:(UIViewController *)childController;




@end
NS_ASSUME_NONNULL_END
