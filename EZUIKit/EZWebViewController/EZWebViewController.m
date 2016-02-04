//
//  EZWebViewController.m
//  EZUIKit
//
//  Created by yangjun zhu on 16/1/19.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZWebViewController.h"
#import "EZWebViewToolView.h"
@interface EZWebViewController ()<EZWebViewToolViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)  EZWebViewToolView *toolView;
@property (nonatomic, assign) BOOL isShowToolView;

@property (nonatomic, strong)  NSLayoutConstraint *toolViewHeightConstraint;
@property (nonatomic, assign) CGFloat defaultToolViewHeight ;//default 44
@property (nonatomic, assign) BOOL interactivePopGestureRecognizerEnabled ;



@end

@implementation EZWebViewController


+ (UINavigationController *)navigationControllerWithWebViewController{
   return  [EZWebViewController navigationControllerWithWebViewControllerWithConfiguration:nil];
}
+ (UINavigationController *)navigationControllerWithWebViewControllerWithConfiguration:(WKWebViewConfiguration *)configuration{
    EZWebViewController *webViewController = nil;
    if (configuration) {
        webViewController = [[EZWebViewController alloc] initWithConfiguration:configuration];
    }else{
        webViewController = [[EZWebViewController alloc] init];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonPressed:)];
    [webViewController.navigationItem setRightBarButtonItem:doneButton];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    return navigationController;

}
#pragma mark - init

- (instancetype)init{
    self = [super init];
    if(self){
        [self __commonInitWithConfiguration:nil];
    }
    return self;
}

- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self){
        [self __commonInitWithConfiguration:configuration];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self __commonInitWithConfiguration:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self __commonInitWithConfiguration:nil];
    }
    return self;
}


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.toolView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolView]-0-|" options:0 metrics:nil views:@{@"toolView": self.toolView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolView]-0-|" options:0 metrics:nil views:@{@"toolView": self.toolView}]];
    self.toolViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.toolView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.toolViewHeight];
    [self.toolView addConstraint:self.toolViewHeightConstraint];
    
    
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView": self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-0-[webView]-0-[toolView]|" options:0 metrics:nil views:@{@"webView": self.webView, @"toolView": self.toolView, @"topGuide": self.topLayoutGuide}]];
    
    if (self.isShowToolView) {
        [self showToolViewWithAnimated:NO];
    }
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://github.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0]];
    
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.interactivePopGestureRecognizerEnabled = self.navigationController.interactivePopGestureRecognizer.enabled;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = self.interactivePopGestureRecognizerEnabled;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (void)dealloc{
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
    [self.webView removeObserver:self forKeyPath:@"title"];


}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object != self.webView) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        if (self.progressIndicatorStyle & EZWebViewControllerProgressIndicatorStyleProgressView) {
            [self __progressChanged:[(NSNumber *)change[NSKeyValueChangeNewKey] floatValue]];
        }
    }else if([keyPath isEqualToString:@"title"] && object == self.webView){
        if (self.styleInNavigationBar == EZWebViewControllerPageTitleInNavigationBar) {
            self.title = self.webView.title;
        }
        if([self.delegate respondsToSelector:@selector(webViewController:newTitle:)]) {
            [self.delegate webViewController:self newTitle:self.webView.title];
        }
    
    }else if([keyPath isEqualToString:@"URL"] && object == self.webView){
        if (self.styleInNavigationBar == EZWebViewControllerPageURLInNavigationBar) {
            self.title = [self.webView.URL absoluteString];
        }
        if([self.delegate respondsToSelector:@selector(webViewController:newURL:)]) {
            [self.delegate webViewController:self newURL:self.webView.URL];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - EZWebViewToolViewDelegate

- (void)toolView:(EZWebViewToolView *)toolView didBackButtonItem:(UIBarButtonItem *)backButtonItem{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}
- (void)toolView:(EZWebViewToolView *)toolView didForwardButtonItem:(UIBarButtonItem *)backButtonItem{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}
- (void)toolView:(EZWebViewToolView *)toolView didRefreshButtonItem:(UIBarButtonItem *)backButtonItem{
    [self.webView reload];
}
- (void)toolView:(EZWebViewToolView *)toolView didStopButtonItem:(UIBarButtonItem *)backButtonItem{
    [self.webView stopLoading];
}

#pragma mark - WKNavigationDelegate
//与页面导航加载相关

/**
 *  在发送请求之前，决定是否跳转。通常用于处理跨域的链接能否导航，WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。但是，对于Safari是允许跨域的，不用这么处理。所以可以把跨域url跳到Safari去
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
    //    decisionHandler(WKNavigationActionPolicyCancel);
}

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self __showLoading:YES];
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    // 允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    // 不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
}


/**
 *  当内容开始返回时调用。Invoked when content starts arriving for the main frame（也就是在页面内容加载到达mainFrame时会回调此API。如果我们要在mainFrame中注入什么JS，也可以在此处添加）。
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}



/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self __showLoading:NO];
    if(self.interactivePopGestureRecognizerEnabled && self.allowsBackForwardNavigationGestures){
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.webView.canGoBack;
    }
}

/////////////////////////分割线/////////////
/**
 *  加载失败时调用(Invoked when an error occurs during a committed main frame
 navigation.)
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self __showLoading:NO];

}


/**
 *  加载失败时调用(Invoked when an error occurs while starting to load data for
 the main frame.)
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    [self __showLoading:NO];

}


/**
 *  接收到服务器跳转请求之后调用（重定向）
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}





/**
 *  如果我们的请求要求授权、证书等，我们需要处理下面的代理方法，以提供相应的授权处理等：
 *
 */
/*
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler{
    
}
*/



/**
 *  当我们终止页面加载时，我们会可以处理下面的代理方法，如果不需要处理，则不用实现之：
 *
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    
}

#pragma mark - WKUIDelegate
//与JS交互时的ui展示相关，比较JS的alert、confirm、prompt

/**
 *  Creates a new web view.
 *
 */
/*
 - (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
 }
 */

/**
 *  Notifies your app that the DOM window object's close() method completed successfully.
 *
 */
- (void)webViewDidClose:(WKWebView *)webView{
    
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"EZOK", @"OK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    //  js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"EZOK", @"OK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"EZCancel", @"Cancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt
                                                                             message:defaultText
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
       
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"EZOK", @"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   UITextField *textField = alertController.textFields.firstObject;
                                   completionHandler(textField.text);
                                   
                                 
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKScriptMessageHandler
//与js交互相关，通常是ios端注入名称，js端通过window.webkit.messageHandlers.{NAME}.postMessage()来发消息到ios端
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - public
- (void)showToolViewWithAnimated:(BOOL)animated{
    self.isShowToolView = YES;
    [self __updateToolViewHeightWithAnimated:animated];
}


- (void)hideToolViewWithAnimated:(BOOL)animated{
    self.isShowToolView = NO;
    [self __updateToolViewHeightWithAnimated:animated];
}


- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}


- (void)loadHTMLString:(NSString *)HTMLString {
    [self.webView loadHTMLString:HTMLString baseURL:nil];
}

#pragma mark - action

- (void)doneButtonPressed:(id)sender {
    if([self.delegate respondsToSelector:@selector(webViewControllerWillDismiss:)]) {
        [self.delegate webViewControllerWillDismiss:self];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(webViewControllerDidDismiss:)]) {
            [self.delegate webViewControllerWillDismiss:self];
        }
    }];
}
#pragma mark - private
- (void)__commonInitWithConfiguration:(WKWebViewConfiguration *)configuration{
    if(configuration) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    }else {
        self.webView = [[WKWebView alloc] init];
    }
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.toolView = [[EZWebViewToolView alloc] init];
    self.toolView.delegate = self;
    self.toolView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.allowsBackForwardNavigationGestures = self.webView.allowsBackForwardNavigationGestures;
    self.styleInNavigationBar = EZWebViewControllerPageTitleInNavigationBar;
    self.defaultToolViewHeight = 44.0;
    self.isShowToolView = YES;
    self.progressIndicatorStyle = EZWebViewControllerProgressIndicatorStyleProgressView;
}

- (void)__progressChanged:(float)progress{
    if(!self.progressView){
        self.progressView = [[UIProgressView alloc] init];
        self.progressView.tintColor = self.tintColor;

        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.progressView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[progressView]-0-|" options:0 metrics:nil views:@{@"progressView": self.progressView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-0-[progressView(2)]" options:0 metrics:nil views:@{@"progressView": self.progressView,  @"topGuide": self.topLayoutGuide}]];
    }
    NSLog(@"%f",progress);
    self.progressView.alpha = 1;
    self.progressView.progress = progress;
    if (self.progressView.progress >= 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.progressView.alpha = 0;
        } completion:^(BOOL finished) {
            self.progressView.progress = 0;

        }];
    }
}

- (void)__showLoading:(BOOL)isShow{
    [self.toolView updateButtonState:self.webView];
    if (self.progressIndicatorStyle & EZWebViewControllerProgressIndicatorStyleActivityIndicator) {
        if (isShow) {
            [self.activityIndicatorView startAnimating];
        }else{
            [self.activityIndicatorView stopAnimating];
        }
    }
}

- (void)__updateToolViewHeightWithAnimated:(BOOL)animated{
    if (self.toolViewHeightConstraint) {
        self.toolViewHeightConstraint.constant = self.toolViewHeight;
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [self.view layoutIfNeeded];
        }
        
    }
}


#pragma mark - get set

- (UIActivityIndicatorView *)activityIndicatorView{

    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _activityIndicatorView.tintColor = self.tintColor;
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_activityIndicatorView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[activityIndicator]-0-|" options:0 metrics:nil views:@{@"activityIndicator": _activityIndicatorView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-0-[activityIndicator]-0-[toolView]|" options:0 metrics:nil views:@{@"activityIndicator": _activityIndicatorView, @"toolView": self.toolView,  @"topGuide": self.topLayoutGuide}]];
    }
    
    return _activityIndicatorView;
}


- (void)setIsShowToolView:(BOOL)isShowToolView{
    _isShowToolView = isShowToolView;
    if (_isShowToolView) {
        self.toolViewHeight = self.toolViewHeight?self.toolViewHeight:self.defaultToolViewHeight;
    }else{
        self.defaultToolViewHeight = self.toolViewHeight;
        self.toolViewHeight = 0;
    }
}


- (BOOL)allowsBackForwardNavigationGestures{
    return self.webView.allowsBackForwardNavigationGestures;
}

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures{
    self.webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
}


- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    _activityIndicatorView.tintColor = _tintColor;
    _progressView.tintColor = _tintColor;
    self.navigationController.navigationBar.tintColor = _tintColor;
    self.toolView.toolbarTintColor = _tintColor;
}

- (void)setBarTintColor:(UIColor *)barTintColor{
    self.navigationController.navigationBar.tintColor = _barTintColor;
    self.toolView.toolbarTintColor = _barTintColor;
}
@end
