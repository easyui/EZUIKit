//
//  CellModel.h
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EZUIKit/EZNestedTableView.h>

@interface CellModel : NSObject<EZNestedTableViewCellModelProtocol>
@property (nonatomic, assign) BOOL isSubTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL ischecked;
@end
