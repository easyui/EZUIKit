//
//  EZNestedTableViewCell.m
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableViewCell.h"

@implementation EZNestedTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellMode:(NSObject<EZNestedTableViewCellModelProtocol> *)cellMode{
    if (cellMode.isSubTitle) {
        self.titleLabel.text = @"";
        self.clearButton.hidden = NO;
        self.checkBoxImageView.hidden = YES;
        return;
    }
    self.titleLabel.text = cellMode.title;
    self.clearButton.hidden = YES;
    self.checkBoxImageView.hidden = !cellMode.ischecked;
    self.titleLabel.textColor = cellMode.ischecked?[UIColor redColor]:[UIColor blackColor];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cellMode:(NSObject<EZNestedTableViewCellModelProtocol> *)cellMode{
    if (cellMode.isSubTitle) {
        return;
    }
    cellMode.ischecked = !cellMode.ischecked;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

}
@end
