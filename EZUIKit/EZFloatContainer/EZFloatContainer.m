//
//  EZFloatContainer.m
//  ezvideodemo
//
//  Created by yangjun zhu on 16/3/3.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZFloatContainer.h"
#import "EZFloatContainerRootViewController.h"
#define  windowWidth ([UIScreen mainScreen].bounds.size.width)
#define  windowHeight ([UIScreen mainScreen].bounds.size.height)


@interface EZFloatContainer ()

@property (strong, nonatomic) UIWindow * floatWindow;
//@property (weak, nonatomic) UIViewController *rootViewController;
@property (assign, nonatomic) CGRect  frame;//float
@property (assign, nonatomic)BOOL isShow;//float是否显示
@property (assign, nonatomic) EZFloatContainerDirectionTag directionTag;



@property (assign, nonatomic)BOOL isShowKeyBoard;//键盘是否展开
@property (assign, nonatomic)CGSize keyBoardSize;//键盘的尺寸

@end



@implementation EZFloatContainer
#pragma mark - vc life

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.floatWindow = nil;
}


- (instancetype)initWithFrame:(CGRect)frame rootViewController:(EZFloatContainerRootViewController *)rootViewController{
    self = [super init];
    if (self) {
        //        self.rootViewController = rootViewController;
        [self __commonInit];
        rootViewController.floatContainer = self;
        self.frame = frame;
        self.floatWindow = [[UIWindow alloc] initWithFrame:self.frame];
        self.floatWindow.backgroundColor = [UIColor redColor];
        self.floatWindow.windowLevel = UIWindowLevelNormal + 1;
        self.floatWindow.clipsToBounds = YES;
        self.floatWindow.rootViewController = rootViewController;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        /*
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(onDeviceOrientationChange:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
         */
        
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(floatHandlePan:)];
        [self.floatWindow addGestureRecognizer:panGestureRecognizer];
        
        //键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

#pragma mark - UIPanGestureRecognizer
- (void)floatHandlePan:(UIPanGestureRecognizer*)panGestureRecognizer
{
    
    UIView * panView = panGestureRecognizer.view;//now panView is floatWindow;
    [UIView animateWithDuration:0.1 animations:^{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:panView];
            CGFloat   panCenterY = panView.center.y + translation.y;
            if (self.isShowKeyBoard && panCenterY > windowHeight - self.keyBoardSize.height) {
                panCenterY = windowHeight - self.keyBoardSize.height;
            }
            [panView setCenter:(CGPoint){panView.center.x + translation.x, panCenterY}];
            [panGestureRecognizer setTranslation:CGPointZero inView:panView];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self __moveEndWithPanView:panView];
        }
    }];
}





#pragma mark - action

-(void)show{
    
    self.floatWindow.frame =  self.frame;
    //    if( self.delegate && [self.delegate respondsToSelector:@selector(willshowFloatView:)] ){
    //        if (![self.delegate willshowFloatView:self]) {
    //            return;
    //        }
    //    }
    //    [self.castWindow makeKeyAndVisible];
    self.floatWindow.hidden = NO;
    self.isShow =  !self.floatWindow.hidden;
    
}

-(void)hidden{
    //    [self.castWindow resignKeyWindow];
    self.floatWindow.hidden = YES;
    self.isShow =  !self.floatWindow.hidden;
    
}

- (void)addSubview:(UIView *)view{
    [self.floatWindow.rootViewController.view addSubview:view];
    view.frame = self.floatWindow.rootViewController.view.bounds;
}

- (void)addChildViewController:(UIViewController *)childController{
    [self.floatWindow.rootViewController addChildViewController:childController];
}


#pragma mark - Orientation
/*
 #define DegreesToRadians(degrees) (degrees * M_PI / 180)
 
 - (void)onDeviceOrientationChange:(NSNotification *)notification{
 
 self.floatWindow.frame = self.frame;
 NSLog(@"%@",NSStringFromCGRect(self.floatWindow.frame));
 return;
 
 UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
 UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
 switch (interfaceOrientation) {
 case UIInterfaceOrientationPortraitUpsideDown:{
 NSLog(@"第3个旋转方向---电池栏在下");
 self.floatWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
 break;
 
 }
 case UIInterfaceOrientationPortrait:{
 NSLog(@"第0个旋转方向---电池栏在上");
 self.floatWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
 
 break;
 
 
 }
 case UIInterfaceOrientationLandscapeLeft:{
 NSLog(@"第2个旋转方向---电池栏在左");
 self.floatWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
 
 break;
 
 
 }
 case UIInterfaceOrientationLandscapeRight:{
 NSLog(@"第1个旋转方向---电池栏在右");
 self.floatWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
 
 break;
 
 
 }
 default:
 break;
 }
 }
 */

#pragma mark - private

- (void)__commonInit{
    self.shouldAutorotate = YES;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        self.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    }else {
        self.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    }
    self.prefersStatusBarHidden = NO;
    self.preferredStatusBarStyle = UIStatusBarStyleDefault;
    
    self.attractionsGapForTopOrBottom = -1;
    
}

- (void)__moveEndWithPanView:(UIView*)panView
{
    CGFloat movedSpaceHeight = windowHeight;
    if(self.isShowKeyBoard){
        movedSpaceHeight -= self.keyBoardSize.height;
    }
    if (self.attractionsGapForTopOrBottom < 0) {
        self.attractionsGapForTopOrBottom = panView.bounds.size.height/2;
    }
    if (panView.frame.origin.y <= self.attractionsGapForTopOrBottom) {
        if (panView.frame.origin.x < 0) {
            //left-top
            self.directionTag = EZFloatContainerDirectionTagTop|EZFloatContainerDirectionTagLeft;
            [panView setCenter:(CGPoint){panView.frame.size.width/2,panView.frame.size.height/2}];
        }else if (panView.frame.origin.x + panView.frame.size.width > windowWidth) {
            //right-top
            self.directionTag = EZFloatContainerDirectionTagTop|EZFloatContainerDirectionTagRight;
            [panView setCenter:(CGPoint){windowWidth - panView.frame.size.width/2,panView.frame.size.height/2}];
        }else
        {
            //top
            self.directionTag = EZFloatContainerDirectionTagTop;
            [panView setCenter:(CGPoint){panView.center.x,panView.frame.size.height/2}];
        }
    }else if (panView.frame.origin.y + panView.frame.size.height >= movedSpaceHeight - self.attractionsGapForTopOrBottom)
    {
        if (panView.frame.origin.x < 0) {
            //left-bottom
            self.directionTag = EZFloatContainerDirectionTagBottom|EZFloatContainerDirectionTagLeft;
            [panView setCenter:(CGPoint){panView.frame.size.width/2,movedSpaceHeight - panView.frame.size.height/2}];
        }else if (panView.frame.origin.x + panView.frame.size.width > windowWidth) {
            //right-bottom
            self.directionTag = EZFloatContainerDirectionTagBottom|EZFloatContainerDirectionTagRight;
            [panView setCenter:(CGPoint){windowWidth - panView.frame.size.width/2,movedSpaceHeight - panView.frame.size.height/2}];
        }else
        {
            //bottom
            self.directionTag = EZFloatContainerDirectionTagBottom;
            [panView setCenter:(CGPoint){panView.center.x,movedSpaceHeight - panView.frame.size.height/2}];
        }
    }else
    {
        if (panView.frame.origin.x + panView.frame.size.width/2 < windowWidth/2) {
            self.directionTag = EZFloatContainerDirectionTagLeft;
            if (panView.frame.origin.x !=0) {
                [panView setCenter:(CGPoint){panView.frame.size.width/2,panView.center.y}];
            }
        }else
        {
            self.directionTag = EZFloatContainerDirectionTagRight;
            if (panView.frame.origin.x + panView.frame.size.width != windowWidth) {
                [panView setCenter:(CGPoint){windowWidth - panView.frame.size.width/2,panView.center.y}];
            }
        }
    }
}


#pragma mark - KeyBoard Notification
-(void)keyboardFrameWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    self.keyBoardSize = kbSize;
    self.isShowKeyBoard = YES;
    [UIView animateWithDuration:[duration floatValue] delay:0 options:[curve intValue] animations:^{
        if (self.floatWindow.frame.origin.y + self.floatWindow.frame.size.height > windowHeight - kbSize.height) {
            [self.floatWindow setFrame:CGRectMake(self.floatWindow.frame.origin.x, windowHeight - kbSize.height - self.floatWindow.frame.size.height, self.floatWindow.bounds.size.width, self.floatWindow.bounds.size.height)];
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardFrameWillHide:(NSNotification *)notification
{
    self.isShowKeyBoard = NO;
    if (self.floatWindow.frame.origin.y + self.floatWindow.frame.size.height >= windowHeight - self.keyBoardSize.height) {
        NSDictionary* info = [notification userInfo];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration floatValue] delay:0 options:[curve intValue] animations:^{
            [self.floatWindow setCenter:(CGPoint){self.floatWindow.center.x,windowHeight  - self.floatWindow.frame.size.height/2}];        } completion:^(BOOL finished) {
                
            }];}
}

@end
