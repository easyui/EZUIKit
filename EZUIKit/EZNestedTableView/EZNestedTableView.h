//
//  EZNestedTableView.h
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@protocol EZNestedTableViewSectionModelProtocol <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSArray *selectedItems;
@property (nonatomic, copy) NSArray *items;//isSubTitle ,title,ischecked
@end

@protocol EZNestedTableViewCellModelProtocol <NSObject>
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end


@interface EZNestedTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) IBInspectable BOOL isSingleExpanedOnly;
@property (nonatomic, copy) NSArray<EZNestedTableViewSectionModelProtocol> * sectionModels;

@end
NS_ASSUME_NONNULL_END