//
//  EZFloatContainer.h
//  ezvideodemo
//
//  Created by yangjun zhu on 16/3/3.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, EZFloatContainerDirectionTag) {
    EZFloatContainerDirectionTagLeft     = 1 << 0,
    EZFloatContainerDirectionTagTop    = 1 << 1,
    EZFloatContainerDirectionTagRight    = 1 << 2,
    EZFloatContainerDirectionTagBottom    = 1 << 3,
};
@class  EZFloatContainerRootViewController;
@interface EZFloatContainer : NSObject
@property (assign, nonatomic,readonly)BOOL isShow;

@property (assign, nonatomic) CGFloat attractionsGapForTopOrBottom;
@property (assign, nonatomic,readonly) EZFloatContainerDirectionTag directionTag;
@property (assign, nonatomic) CGFloat panAnimateDuration;//default 0.1



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
