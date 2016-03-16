//
//  SectionModel.h
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EZUIKit/EZNestedTableView.h>

@interface SectionModel : NSObject<EZNestedTableViewSectionModelProtocol>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isExpaned;
@property (nonatomic, copy) NSMutableArray<EZNestedTableViewCellModelProtocol> *selectedItems;
@property (nonatomic, copy) NSArray<EZNestedTableViewCellModelProtocol> *cellItems;
@end
