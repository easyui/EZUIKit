//
//  EZWebViewToolbar.m
//  EZUIKit
//
//  Created by yangjun zhu on 16/1/19.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZWebViewToolView.h"


@interface EZWebViewToolView ()


@end


@implementation EZWebViewToolView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        [self __commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __commonInit];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __commonInit];
    }
    return self;
    
    
}

#pragma mark - Life Cycle
- (void)layoutSubviews{
    [super layoutSubviews];
    if(!self.toolBar){
        self.toolBar = [[UIToolbar alloc] init];
        
        self.toolBar.tintColor = self.toolbarTintColor;
        self.toolBar.backgroundColor = self.toolbarBackgroundColor;
        self.toolBar.translucent = self.toolbarTranslucent;
        
        self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.toolBar];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolBar]-0-|" options:0 metrics:nil views:@{@"toolBar": self.toolBar}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolBar]-0-|" options:0 metrics:nil views:@{@"toolBar": self.toolBar}]];
        NSArray<UIBarButtonItem *> *items = @[self.backButtonItem,self.forwardButtonItem,self.flexibleSpace,self.refreshButtonItem] ;
        [self.toolBar setItems:items animated:NO];
        
    }
}


#pragma mark - action
- (void)goBack:(UIBarButtonItem *)barButtonItem {
    if([self.delegate respondsToSelector:@selector(toolView:didBackButtonItem:)]) {
        [self.delegate toolView:self didBackButtonItem:barButtonItem];
    }
}

- (void)goForward:(UIBarButtonItem *)barButtonItem {
    if([self.delegate respondsToSelector:@selector(toolView:didForwardButtonItem:)]) {
        [self.delegate toolView:self didForwardButtonItem:barButtonItem];
    }
}

- (void)refresh:(UIBarButtonItem *)barButtonItem{
    if([self.delegate respondsToSelector:@selector(toolView:didRefreshButtonItem:)]) {
        [self.delegate toolView:self didRefreshButtonItem:barButtonItem];
    }
}


- (void)stop:(UIBarButtonItem *)barButtonItem{
    if([self.delegate respondsToSelector:@selector(toolView:didBackButtonItem:)]) {
        [self.delegate toolView:self didBackButtonItem:barButtonItem];
    }
}


#pragma mark - public
- (void)updateButtonState:(WKWebView *)webView{
    self.backButtonItem.enabled = webView.canGoBack;
    self.forwardButtonItem.enabled = webView.canGoForward;
    NSArray<UIBarButtonItem *> *items ;
    if (webView.isLoading) {
        items = @[self.backButtonItem,self.forwardButtonItem,self.flexibleSpace,self.stopButtonItem];
    }else{
        items = @[self.backButtonItem,self.forwardButtonItem,self.flexibleSpace,self.refreshButtonItem];
    }
    [self.toolBar setItems:items animated:YES];
}


#pragma mark - private
- (void)__commonInit{
    self.toolbarTranslucent = YES;
    
}
#pragma mark - get
- (UIBarButtonItem *)backButtonItem{
    if (!_backButtonItem) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u25C0\uFE0E" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
        _backButtonItem.enabled = NO;
    }
    return _backButtonItem;
}

- (UIBarButtonItem *)forwardButtonItem{
    if (!_forwardButtonItem) {
        _forwardButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u25B6\uFE0E" style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
        _forwardButtonItem.enabled = NO;
    }
    return _forwardButtonItem;
}

- (UIBarButtonItem *)refreshButtonItem{
    if (!_refreshButtonItem) {
        _refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    }
    return _refreshButtonItem;
}

- (UIBarButtonItem *)stopButtonItem{
    if (!_stopButtonItem) {
        _stopButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
    }
    return _stopButtonItem;
}

- (UIBarButtonItem *)flexibleSpace{
    if (!_flexibleSpace) {
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _flexibleSpace;
}

- (void)setToolbarTintColor:(UIColor *)toolbarTintColor{
    _toolbarTintColor = toolbarTintColor;
    self.toolBar.tintColor = _toolbarTintColor;
}

- (void)setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor{
    _toolbarBackgroundColor = toolbarBackgroundColor;
    self.toolBar.backgroundColor = _toolbarBackgroundColor;
}

- (void)setToolbarTranslucent:(BOOL)toolbarTranslucent{
    _toolbarTranslucent = toolbarTranslucent;
    self.toolBar.translucent = toolbarTranslucent;
}
@end

