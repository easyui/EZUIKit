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
#define  windowHight ([UIScreen mainScreen].bounds.size.height)


@interface EZFloatContainer ()

@property (strong, nonatomic) UIWindow * floatWindow;
//@property (weak, nonatomic) UIViewController *rootViewController;
@property (assign, nonatomic) CGRect  frame;

@property (assign, nonatomic)BOOL isShow;

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
        //        self.castWindow.windowLevel = 3000;
        self.floatWindow.windowLevel = UIWindowLevelNormal + 1;
        self.floatWindow.clipsToBounds = YES;
        //        [self.castWindow makeKeyAndVisible];
        self.floatWindow.rootViewController = rootViewController;
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDeviceOrientationChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(floatHandlePan:)];
        [self.floatWindow addGestureRecognizer:panGestureRecognizer];
        
    }
    return self;
}


- (void)floatHandlePan:(UIPanGestureRecognizer*)panGestureRecognizer
{
    
    UIView * moveView = panGestureRecognizer.view;
    [UIView animateWithDuration:0.1 animations:^{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:moveView];
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:moveView];
            //            [self setImgaeNameWithMove:YES];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            if (self.floatWindow.frame.origin.y + self.floatWindow.frame.size.height > windowHight - _keyBoardSize.height) {
//                if (_showKeyBoard) {
//                    if (moveView.frame.origin.x < 0) {
//                        [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - _keyBoardSize.height - self.floatWindow.frame.size.height/2}];
//                    }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth)
//                    {
//                        [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - _keyBoardSize.height - self.floatWindow.frame.size.height/2}];
//                    }else
//                    {
//                        [moveView setCenter:(CGPoint){moveView.center.x,windowHight - _keyBoardSize.height - self.floatWindow.frame.size.height/2}];
//                    }
//                    _showKeyBoardWindowRect = CGRectMake(self.floatWindow.frame.origin.x, windowHight - moveView.frame.size.height, 60, 60);
//                    _locationTag = kLocationTag_bottom;
//                }else
//                {
//                    [self moveEndWithMoveView:moveView];
//                    _showKeyBoardWindowRect = _boardWindow.frame;
//                }
//            }else
//            {
//                [self moveEndWithMoveView:moveView];
//                _showKeyBoardWindowRect = _boardWindow.frame;
//            }
//            [self setImgaeNameWithMove:NO];
            [self moveEndWithMoveView:moveView];

        }
    }];
}


- (void)moveEndWithMoveView:(UIView*)moveView
{
    if (moveView.frame.origin.y <= 40) {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_top;
        }
    }else if (moveView.frame.origin.y + moveView.frame.size.height >= windowHight - 40)
    {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,windowHight - moveView.frame.size.height/2}];
//            _locationTag = kLocationTag_bottom;
        }
    }else
    {
        if (moveView.frame.origin.x + moveView.frame.size.width/2 < windowWidth/2) {
            if (moveView.frame.origin.x !=0) {
                [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.center.y}];
            }
//            _locationTag = kLocationTag_left;
        }else
        {
            if (moveView.frame.origin.x + moveView.frame.size.width != windowWidth) {
                [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.center.y}];
            }
//            _locationTag = kLocationTag_right;
        }
    }
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
#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (void)onDeviceOrientationChange:(NSNotification *)notification{
    
    //    self.floatWindow.frame = self.frame;
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
    
}
@end
