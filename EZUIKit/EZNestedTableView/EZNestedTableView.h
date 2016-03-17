//
//  EZNestedTableView.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#pragma mark -
#pragma mark - EZNestedTableViewCellModelProtocol

@protocol EZNestedTableViewCellModelProtocol <NSObject>
@required
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end

#pragma mark - EZNestedTableViewSectionModelProtocol

@protocol EZNestedTableViewSectionModelProtocol <NSObject>
@required
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSMutableArray<EZNestedTableViewCellModelProtocol> *selectedItems;
@property (nonatomic, copy) NSArray<EZNestedTableViewCellModelProtocol> *cellItems;
@end

#pragma mark -
#pragma mark - EZNestedTableViewSectionHeaderInteractionProtocol

@protocol EZNestedTableViewSectionHeaderProtocol;

@protocol EZNestedTableViewSectionHeaderInteractionProtocol <NSObject>
@required
-(void)tappedHeaderFooterView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerFooterView atPoint:(CGPoint)point;

@end

#pragma mark - EZNestedTableViewSectionHeaderProtocol

@protocol EZNestedTableViewSectionHeaderProtocol <NSObject>
@required
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id <EZNestedTableViewSectionHeaderInteractionProtocol> interactionDelegate;

@optional
- (void)tableView:(UITableView *)tableView sectionHeaderView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerView forSection:(NSInteger)section expanded:(BOOL)expanded animated:(BOOL)animated;
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
@end

#pragma mark -
#pragma mark - EZNestedTableViewCellProtocol

@protocol EZNestedTableViewCellProtocol <NSObject>
@required
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@optional
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
- (void)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellMode:(NSObject<EZNestedTableViewCellModelProtocol> *)cell;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cellMode:(NSObject<EZNestedTableViewCellModelProtocol> *)cell;


@end
#pragma mark -
#pragma mark - EZNestedTableView

@interface EZNestedTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) IBInspectable BOOL isSingleExpanedOnly;

@property (nonatomic, copy) IBInspectable NSString * sectionHeaderNibName;
@property (nonatomic, assign) IBInspectable CGFloat  sectionHeaderHeight;

@property (nonatomic, copy) IBInspectable NSString * tableViewCellNibName;

@property (nullable, nonatomic, copy) NSArray<EZNestedTableViewSectionModelProtocol> *sectionModels;



- (BOOL)setExpaned:(BOOL)isExpaned;
- (BOOL)setExpaned:(BOOL)isExpaned inSection:(NSInteger)section;

- (BOOL)setChecked:(BOOL)isChecked;
- (BOOL)setChecked:(BOOL)isChecked inSection:(NSInteger)section;
- (BOOL)setChecked:(BOOL)isChecked atIndexPath:(NSIndexPath *)indexPath;


- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadData;

- (nullable NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;
- (BOOL)hasCheckedInSection:(NSUInteger)index;

- (NSArray<EZNestedTableViewCellModelProtocol> *)checkedCellModels;
- (NSArray<EZNestedTableViewCellModelProtocol> *)checkedCellModelsInSection:(NSUInteger)index;
//private
@property(nullable,nonatomic,strong) UITableView *tableView;

@end
NS_ASSUME_NONNULL_END