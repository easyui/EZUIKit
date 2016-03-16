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
@required
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end
#pragma mark - EZNestedTableViewSectionModelProtocol

@protocol EZNestedTableViewSectionModelProtocol <NSObject>
@required
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSMutableArray<EZNestedTableViewCellModelProtocol> *selectedItems;
@property (nonatomic, copy) NSArray<EZNestedTableViewCellModelProtocol> *cellItems;
@end


#pragma mark - RRNCollapsableTableViewSectionHeaderProtocol

@protocol EZNestedTableViewSectionHeaderProtocol;

@protocol EZNestedTableViewSectionHeaderInteractionProtocol <NSObject>
@required
-(void)tappedHeaderFooterView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerFooterView atPoint:(CGPoint)point;

@end

@protocol EZNestedTableViewSectionHeaderProtocol <NSObject>
@required
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id <EZNestedTableViewSectionHeaderInteractionProtocol> interactionDelegate;

@optional
- (void)tableView:(UITableView *)tableView sectionHeaderView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerView forSection:(NSInteger)section expanded:(BOOL)expanded animated:(BOOL)animated;
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; 
@end


#pragma mark - EZNestedTableView

@interface EZNestedTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) IBInspectable BOOL isSingleExpanedOnly;

@property (nonatomic, copy) IBInspectable NSString * sectionHeaderNibName;
@property (nonatomic, assign) IBInspectable CGFloat  sectionHeaderHeight;


@property (nullable, nonatomic, copy) NSArray<EZNestedTableViewSectionModelProtocol> *sectionModels;



//private
@property(nullable,nonatomic,strong) UITableView *tableView;

@end
NS_ASSUME_NONNULL_END