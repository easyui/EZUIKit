//
//  EZNestedTableViewCell.h
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZUIKit/EZNestedTableView.h>

@interface EZNestedTableViewCell : UITableViewCell<EZNestedTableViewCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end
