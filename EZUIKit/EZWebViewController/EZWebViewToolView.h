//
//  EZWebViewToolbar.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/1/19.
//  Copyright © 2016年 Cactus. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EZWebViewToolViewDelegate;
@interface EZWebViewToolView : UIView
@property (nonatomic, strong)  UIToolbar *toolBar;
@property (nonatomic, strong)  UIBarButtonItem *backButtonItem;
@property (nonatomic, strong)  UIBarButtonItem *forwardButtonItem;
@property (nonatomic, strong)  UIBarButtonItem *refreshButtonItem;
@property (nonatomic, strong)  UIBarButtonItem *stopButtonItem;
@property (nonatomic, strong)  UIBarButtonItem *flexibleSpace;

@property (nullable, nonatomic, weak) id <EZWebViewToolViewDelegate> delegate;

@property (nonatomic, strong)  UIColor *toolbarTintColor;
@property (nonatomic, strong)  UIColor *toolbarBackgroundColor;
@property (nonatomic, assign)  BOOL toolbarTranslucent;



- (void)updateButtonState:(WKWebView *)webView;
@end



@protocol EZWebViewToolViewDelegate <NSObject>
@optional
- (void)toolView:(EZWebViewToolView *)toolView didBackButtonItem:(UIBarButtonItem *)backButtonItem;
- (void)toolView:(EZWebViewToolView *)toolView didForwardButtonItem:(UIBarButtonItem *)backButtonItem;
- (void)toolView:(EZWebViewToolView *)toolView didRefreshButtonItem:(UIBarButtonItem *)backButtonItem;
- (void)toolView:(EZWebViewToolView *)toolView didStopButtonItem:(UIBarButtonItem *)backButtonItem;


@end
NS_ASSUME_NONNULL_END
