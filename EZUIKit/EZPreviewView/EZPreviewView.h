//
//  EZPreviewView.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/15.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief Preview view pagecontrol style.
 */
typedef enum
{
    EZPreviewViewOuterPageControl      = 0, /*!< Pagecontrol outer */
    EZPreviewViewInnerPageControl,          /*!< PageControl inner */
    EZPreviewViewNonePageControl,
}EZPreviewViewStyle;

@class EZPreviewTile;
@protocol EZPreviewViewDelegate;
@interface EZPreviewView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<EZPreviewViewDelegate> delegate;

/**
 *	@brief	Main scrollview instance.
 */
@property (nonatomic, strong) UIScrollView		 * mainScrollView;

/**
 *	@brief	Main pagecontrol instance.
 */
@property (nonatomic, strong) UIPageControl		 * mainPageControl;

/**
 *	@brief	is Auto Play
 */
@property (nonatomic, assign) IBInspectable BOOL isAutoPlay;


/**
 *	@brief	Auto Play next page interval.
 Default is 10.0s.
 */
@property (nonatomic, readwrite) IBInspectable CGFloat   autoPlayInterval;

/**
 *	@brief	Init preview view style.
 */
@property (nonatomic, readonly) IBInspectable EZPreviewViewStyle style;

/**
 *	@brief Front layer, is used to display information
 */
@property (nonatomic, strong) UIView * customDisplayView;


/**
 *	@brief	Init preview view method.
 *
 *	@param 	frame 	The frame for init view.
 *	@param 	height 	The height for pagecontrol view. The height minimum value is 30.
 *	@param 	style 	Preview view pagecontrol display style.
 *	@param 	isCircleMode 	Whether need circle scroll.
 *
 *	@return	Return init instance.
 */

- (id)initWithFrame:(CGRect)frame
              style:(EZPreviewViewStyle)style
         circleMode:(BOOL)isCircleMode
optionalCustomDisplayView:(UIView *)customDisplayView
optionalPageControlHeight:(float)height;

- (id)initWithFrame:(CGRect)frame
              style:(EZPreviewViewStyle)style
         circleMode:(BOOL)isCircleMode
optionalCustomDisplayView:(UIView *)customDisplayView
optionalPageControlHeight:(float)height
         isAutoPlay:(BOOL)isAutoPlay
   autoPlayInterval:(float)autoPlayInterval;

//- (void)updateViewFrame:(CGRect)newFrame;

- (__kindof EZPreviewTile *)dequeueReusableTileWithIdentifier:(NSString *)identifier;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

/**
 *	@brief	Clean all pages and stop play preview.
 */
//- (void)cleanAllPages;
@end

@protocol EZPreviewViewDelegate <NSObject>
@required
- (NSInteger)numberOfRowsForPreviewView:(EZPreviewView *)previewView;
- (EZPreviewTile *)previewView:(EZPreviewView *)previewView tileAtIndex:(NSInteger)index;
@optional
- (void)previewView:(EZPreviewView *)previewView willfocusFromIndex:(NSInteger)fromIndex;
- (void)previewView:(EZPreviewView *)previewView didfocusToIndex:(NSInteger)toIndex;

@end

@interface EZPreviewTile : UIView

@property (nonatomic, strong) NSString * reuseIdentifier;

@end
