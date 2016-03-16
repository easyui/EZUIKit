//
//  EZNestedTableView.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#pragma mark - EZNestedTableViewCellModelProtocol

@protocol EZNestedTableViewCellModelProtocol <NSObject>
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end
#pragma mark - EZNestedTableViewSectionModelProtocol

@protocol EZNestedTableViewSectionModelProtocol <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSMutableArray<EZNestedTableViewCellModelProtocol> *selectedItems;
@property (nonatomic, copy) NSArray<EZNestedTableViewCellModelProtocol> *cellItems;
@end


#pragma mark - RRNCollapsableTableViewSectionHeaderProtocol

@protocol EZNestedTableViewSectionHeaderProtocol;

@protocol EZNestedTableViewSectionHeaderInteractionProtocol <NSObject>

-(void)TappedHeaderFooterView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerFooterView atPoint:(CGPoint)point;

@end

@protocol RRNCollapsableTableViewSectionHeaderProtocol <NSObject>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id <EZNestedTableViewSectionHeaderInteractionProtocol> interactionDelegate;

-(void)openAnimated:(BOOL)animated;
-(void)closeAnimated:(BOOL)animated;

@end


#pragma mark - EZNestedTableView

@interface EZNestedTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) IBInspectable BOOL isSingleExpanedOnly;
@property (nullable, nonatomic, copy) NSArray<EZNestedTableViewSectionModelProtocol> *sectionModels;



//private
@property(nonatomic,strong) UITableView *tableView;

@end
NS_ASSUME_NONNULL_END