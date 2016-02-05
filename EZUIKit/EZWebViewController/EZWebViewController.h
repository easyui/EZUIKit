//
//  EZWebViewController.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/1/19.
//  Copyright © 2016年 Cactus. All rights reserved.
//
#define EZWebViewController_Version @"1.0.0"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class  EZWebViewToolView;
@protocol  EZWebViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, EZWebViewControllerProgressIndicatorStyle) {
    EZWebViewControllerProgressIndicatorStyleActivityIndicator     = 1 << 0,
    EZWebViewControllerProgressIndicatorStyleProgressView    = 1 << 1,
};


typedef NS_ENUM(NSInteger, EZWebViewControllerStyleInNavigationBar) {
    EZWebViewControllerNone,
    EZWebViewControllerPageTitleInNavigationBar,
    EZWebViewControllerPageURLInNavigationBar,
};



@interface EZWebViewController : UIViewController

@property (nonatomic, assign) CGFloat toolViewHeight ;//default 44
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures;//default WKWebView's allowsBackForwardNavigationGestures
@property (nonatomic, assign, readonly) BOOL isShowToolView; //default YES

@property (nonatomic, assign) EZWebViewControllerProgressIndicatorStyle progressIndicatorStyle;//default EZWebViewControllerProgressIndicatorStyleProgressView
@property (nonatomic, assign) EZWebViewControllerStyleInNavigationBar styleInNavigationBar;//default EZWebViewControllerPageTitleInNavigationBar




@property (nonatomic, strong,readonly)  EZWebViewToolView *toolView;


@property (nonatomic, strong)  UIColor *tintColor;
@property (nonatomic, strong)  UIColor *barTintColor;


@property (nullable, nonatomic, weak) id <EZWebViewControllerDelegate> delegate;



+ (UINavigationController *)navigationControllerWithWebViewController;
+ (UINavigationController *)navigationControllerWithWebViewControllerWithConfiguration:( nullable WKWebViewConfiguration *)configuration NS_AVAILABLE_IOS(8_0);


- (instancetype)init;// NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration   NS_AVAILABLE_IOS(8_0);//NS_DESIGNATED_INITIALIZER


- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)HTMLString;

- (void)showToolViewWithAnimated:(BOOL)animated;
- (void)hideToolViewWithAnimated:(BOOL)animated;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler;
@end


@protocol EZWebViewControllerDelegate <NSObject>

@optional
- (void)webViewControllerWillDismiss:(EZWebViewController *)viewController;
- (void)webViewControllerDidDismiss:(EZWebViewController *)viewController;



- (void)webViewController:(EZWebViewController *)viewController newURL:(NSURL * __nullable)newURL;
- (void)webViewController:(EZWebViewController *)viewController newTitle:(NSString * __nullable)newTitle;


- (void)webViewController:(EZWebViewController *)webBrowser didStartLoadingURL:(NSURL *)URL;
- (void)webViewController:(EZWebViewController *)webBrowser didFinishLoadingURL:(NSURL *)URL;
- (void)webViewController:(EZWebViewController *)webBrowser didFailToLoadURL:(NSURL *)URL error:(NSError *)error;



@end

NS_ASSUME_NONNULL_END
