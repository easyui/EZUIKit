//
//  EZNestedTableViewSectionHeaderView.h
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZUIKit/EZNestedTableView.h>

@interface EZNestedTableViewSectionHeaderView : UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol>
@property (weak, nonatomic) IBOutlet UIView *sectionBackgroundView;



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@property (weak, nonatomic) id <EZNestedTableViewSectionHeaderInteractionProtocol> interactionDelegate;


@end
