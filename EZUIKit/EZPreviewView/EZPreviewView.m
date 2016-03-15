//
//  EZPreviewView.m
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/15.
//  Copyright © 2016年 Cactus. All rights reserved.
//
#import "EZPreviewView.h"

@interface UIViewController (EZPreviewView)

+ (UIViewController *)getViewControllerFromEZPreviewView:(UIView *)view;

@end

@implementation UIViewController (EZPreviewView)

+ (UIViewController *)getViewControllerFromEZPreviewView:(UIView *)view;
{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end

@interface EZPreviewTarget : NSObject {
    __weak id _owner;
    SEL _sel;
}

- (id)initWithOwner:(id)owner selector:(SEL)selector;
- (void)update;
@end

@implementation EZPreviewTarget

- (id)initWithOwner:(id)owner selector:(SEL)selector {
    self = [super init];
    if (self){
        _owner = owner;
        _sel = selector;
    }
    return self;
}

- (void)update {
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([(NSObject *)_owner respondsToSelector:_sel]) {
        [_owner performSelector:_sel];
    }
#       pragma clang diagnostic pop
}
@end


@interface EZPreviewView ()
{
    float				_pageControlHeight;
    BOOL                _circleMode;    //Default NO
}
@property (nonatomic, strong) NSMutableArray * reuseTilePool;
@property (nonatomic, strong) NSMutableArray * currentTilePool;
@property (nonatomic, strong) EZPreviewTarget * previewTarget;

- (void)pageControlPageChanged:(id)sender;

@end

@implementation EZPreviewView

- (void)dealloc
{
    _mainScrollView.delegate = nil;
    _mainScrollView = nil;
    _mainPageControl = nil;
}


#pragma mark - Public methods
/**
 *  纯代码初始化控件时一定会走这个方法
 */
- (id)initWithFrame:(CGRect)frame
              style:(EZPreviewViewStyle)style
         circleMode:(BOOL)isCircleMode
optionalCustomDisplayView:(UIView *)customDisplayView
optionalPageControlHeight:(float)height __attribute__ ((warn_unused_result))
{
    return [self initWithFrame:frame style:style circleMode:isCircleMode optionalCustomDisplayView:customDisplayView optionalPageControlHeight:height isAutoPlay:YES autoPlayInterval:10.f];
}


- (id)initWithFrame:(CGRect)frame
              style:(EZPreviewViewStyle)style
         circleMode:(BOOL)isCircleMode
optionalCustomDisplayView:(UIView *)customDisplayView
optionalPageControlHeight:(float)height
         isAutoPlay:(BOOL)isAutoPlay
   autoPlayInterval:(float)autoPlayInterval  __attribute__ ((warn_unused_result)){
    if (self = [super initWithFrame:frame]) {
        
        _style = style;
        _circleMode = isCircleMode;
        
        if (height < 30.0) {
            _pageControlHeight = 30.0f;
        }else {
            _pageControlHeight = height;
        }
        
        _isAutoPlay = isAutoPlay;
        self.autoPlayInterval = autoPlayInterval;
        
        self.reuseTilePool = [NSMutableArray array];
        self.currentTilePool = [NSMutableArray array];
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        if (EZPreviewViewOuterPageControl == self.style) {
            rect = CGRectMake(0, 0, frame.size.width, frame.size.height-_pageControlHeight);
        }
        
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:rect];
        self.mainScrollView.delegate = self;
        self.mainScrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin ;
        [self addSubview:self.mainScrollView];
        
        self.mainPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-_pageControlHeight, frame.size.width, _pageControlHeight)];
        self.mainPageControl.defersCurrentPageDisplay = YES;
        //        self.mainPageControl.enabled = NO;
        self.mainPageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin ;
        //        [self.mainPageControl addTarget:self action:@selector(pageControlPageChanged:) forControlEvents:UIControlEventValueChanged];
        self.mainPageControl.hidesForSinglePage = YES;
        [self addSubview:self.mainPageControl];
        if (style == EZPreviewViewNonePageControl) {
            self.mainPageControl.alpha = 0;
        }
        
        self.customDisplayView = customDisplayView;
        self.customDisplayView.frame = CGRectMake(0, self.frame.size.height-self.customDisplayView.frame.size.height, self.customDisplayView.frame.size.width, self.customDisplayView.frame.size.height);
        self.customDisplayView.autoresizingMask =     UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin ;
        [self insertSubview:self.customDisplayView belowSubview:_mainPageControl];
        
    }
    
    return self;
}

/**
 *  通过xib初始化控件时一定会走这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        //        [self setup];
    }
    
    return self;
}


- (__kindof EZPreviewTile *)dequeueReusableTileWithIdentifier:(NSString *)identifier
{
    EZPreviewTile *reuseTile = nil;
    for (EZPreviewTile * tile in self.reuseTilePool) {
        if ([tile.reuseIdentifier isEqualToString:identifier]) {
            if (![self.currentTilePool containsObject:tile]) {
                [self.currentTilePool addObject:tile];
            }
            reuseTile = tile;
            break;
        }
    }
    [self.reuseTilePool removeObject:reuseTile];
    return reuseTile;
}

- (void)reloadData
{
    UIViewController * controller = [UIViewController getViewControllerFromEZPreviewView:self];
    if ([controller respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        controller.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self __stopAutoPlayPreview];
    self.mainScrollView.delegate = nil;
    [self cleanAllPages];
    
    NSInteger count = [self.delegate numberOfRowsForPreviewView:self];
    self.mainPageControl.numberOfPages = count;
    
    if (_circleMode) {
        if (count > 1) {
            count += 2;
        }
    }
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width*count, 0);
    
    for (NSInteger i = 0; i < count; i++) {
        NSInteger targetIndex = i;
        if (_circleMode) {
            if (count > 1) {
                if (0 == i) {
                    targetIndex = count - 3;
                }else if (count - 1 == i) {
                    targetIndex = 0;
                }else {
                    targetIndex = i - 1;
                }
            }
        }
        EZPreviewTile * tile = [self.delegate previewView:self tileAtIndex:targetIndex];
        tile.frame = CGRectMake(i*self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
        
        [self.mainScrollView addSubview:tile];
        
        if (![self.currentTilePool containsObject:tile]) {
            [self.currentTilePool addObject:tile];
        }
    }
    
    self.mainScrollView.delegate = self;
    
    /*
     if (_circleMode) {
     if (0 == self.mainScrollView.contentOffset.x) {
     if (count > 1) {
     [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width, 0) animated:NO];
     }else {
     [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
     }
     }
     }
     
     if (count > 1) {
     [self scrollViewDidScroll:self.mainScrollView];
     }
     */
    [self scrollToIndex:self.mainPageControl.currentPage animated:NO];
    
    //#warning message
    //    if ([self.delegate respondsToSelector:@selector(previewView:focusAtIndex:)]){
    //        [self.delegate previewView:self focusAtIndex:self.mainPageControl.currentPage];
    //    }
    
    [self __refreshAutoPlay];
    
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    NSInteger count = [self.delegate numberOfRowsForPreviewView:self];
    if (index >= 0 || index < count) {
        float offsetX = self.mainScrollView.frame.size.width*index;
        if (_circleMode) {
            offsetX = self.mainScrollView.frame.size.width*(index + 1);
        }
        [self.mainScrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}

- (void)cleanAllPages
{
    for (EZPreviewTile * view in self.mainScrollView.subviews) {
        if ([view isKindOfClass:[EZPreviewTile class]]) {
            [self.reuseTilePool addObject:view];
            [view removeFromSuperview];
        }
    }
    [self.currentTilePool removeAllObjects];
}

#pragma mark - override methods
-(void)setIsAutoPlay:(BOOL)isAutoPlay{
    _isAutoPlay = isAutoPlay;
    [self __refreshAutoPlay];
}

-(void)setFrame:(CGRect)newFrame{
    super.frame = newFrame;
    
    CGRect rect;
    if (EZPreviewViewOuterPageControl == self.style) {
        rect = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height-_pageControlHeight);
    }else {
        rect = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    }
    _mainScrollView.frame = rect;
    
    _mainPageControl.frame = CGRectMake(0, newFrame.size.height-_pageControlHeight, newFrame.size.width, _pageControlHeight);
    
    self.customDisplayView.frame = CGRectMake(0, self.frame.size.height-self.customDisplayView.frame.size.height, self.customDisplayView.frame.size.width, self.customDisplayView.frame.size.height);
    
    [self scrollToIndex:self.mainPageControl.currentPage animated:NO];
    [self reloadData];
}

#pragma mark - private methods
- (void)__refreshAutoPlay{
    if (self.isAutoPlay) {
        [self __startAutoPlayPreview];
    }else{
        [self __stopAutoPlayPreview];
    }
    
}

- (void)__startAutoPlayPreview
{
    if (!self.previewTarget) {
        self.previewTarget = [[EZPreviewTarget alloc] initWithOwner:self selector:@selector(switchToNextPage)];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self.previewTarget selector:@selector(update) object:nil];
    [self.previewTarget performSelector:@selector(update) withObject:nil afterDelay:_autoPlayInterval];
}

- (void)__stopAutoPlayPreview
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.previewTarget selector:@selector(update) object:nil];
}

#pragma mark - action methods

- (void)pageControlPageChanged:(id)sender
{
    [self scrollToIndex:self.mainPageControl.currentPage animated:YES];
}


- (void)switchToNextPage
{
    [self __stopAutoPlayPreview];
    
    NSInteger itemCount = [self.delegate numberOfRowsForPreviewView:self];
    
    if (itemCount > 1) {
        
        if (_circleMode) {
            itemCount = [self.delegate numberOfRowsForPreviewView:self] + 2;
        }
        
        if (self.mainPageControl.numberOfPages) {
            NSInteger index = (self.mainPageControl.currentPage + 1)%itemCount;
            [self scrollToIndex:index animated:YES];
        }
        
    }
    
    [self __startAutoPlayPreview];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float targetX = scrollView.contentOffset.x;
    
    NSInteger itemCount = [self.delegate numberOfRowsForPreviewView:self];
    if (_circleMode) {
        itemCount = [self.delegate numberOfRowsForPreviewView:self] + 2;
        if (itemCount>=3) {
            //大于最后一个，回到第一个
            if (targetX >= self.mainScrollView.frame.size.width * (itemCount -1)) {
                targetX = self.mainScrollView.frame.size.width;
                [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
            }else if(targetX <= 0){
                //小于第一个，回到最后一个
                targetX = self.mainScrollView.frame.size.width *(itemCount - 2);
                [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
            }
        }
    }
    NSInteger page = (scrollView.contentOffset.x + self.mainScrollView.frame.size.width/2.0) / self.mainScrollView.frame.size.width;
    
    if (_circleMode) {
        if (itemCount > 1) {
            page --;
            if (page >= self.mainPageControl.numberOfPages) {
                page = 0;
            }else if(page <0) {
                page = self.mainPageControl.numberOfPages -1;
            }
        }
    }
    
    BOOL didChanged = page != self.mainPageControl.currentPage;
    if (didChanged) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(previewView:willfocusFromIndex:)]){
            [self.delegate previewView:self willfocusFromIndex:self.mainPageControl.currentPage];
        }
    }
    
    self.mainPageControl.currentPage = page;
    [self.mainPageControl updateCurrentPageDisplay];
    if (didChanged) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(previewView:didfocusToIndex:)]){
            [self.delegate previewView:self didfocusToIndex:page];
        }
    }
}

/*
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
 if (!decelerate){
 int itemCount = [self.delegate numberOfRowsForPreviewView:self];
 if (_circleMode) {
 if (itemCount > 1) {
 CGFloat targetX = scrollView.contentOffset.x + scrollView.frame.size.width;
 int targetIndex = (int)(targetX/self.mainScrollView.frame.size.width);
 [self scrollToIndex:targetIndex animated:YES];
 }
 }
 }
 }
 */

@end


@implementation EZPreviewTile



@end