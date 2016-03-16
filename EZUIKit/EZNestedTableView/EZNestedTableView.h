//
//  EZNestedTableView.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@protocol EZNestedTableViewCellModelProtocol <NSObject>
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end

@protocol EZNestedTableViewSectionModelProtocol <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSMutableArray<EZNestedTableViewCellModelProtocol> *selectedItems;
@property (nonatomic, copy) NSArray<EZNestedTableViewCellModelProtocol> *cellItems;
@end


@interface EZNestedTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) IBInspectable BOOL isSingleExpanedOnly;
@property (nullable, nonatomic, copy) NSArray<EZNestedTableViewSectionModelProtocol> *sectionModels;



//private
@property(nonatomic,strong) UITableView *tableView;

@end
NS_ASSUME_NONNULL_END