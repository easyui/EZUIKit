//
//  EZNestedTableViewCell.m
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableViewCell.h"
#import <EZUIKit/EZNestedTableView.h>
@interface EZNestedTableViewCell ()
@property (weak, nonatomic) EZNestedTableView * nestedTableView;

@end



@implementation EZNestedTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clearSectionButtonTap:(UIButton *)sender {
    if(!self.nestedTableView){
        return;
    }
    
    NSInteger section = [self.nestedTableView indexPathForCell:self].section;
    [self.nestedTableView setChecked:NO inSection:section];
    [self.nestedTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellMode:(NSObject<EZNestedTableViewCellModelProtocol> *)cellMode{
    if (cellMode.isSubTitle) {
        self.titleLabel.text = @"";
        self.checkBoxImageView.hidden = YES;
        self.clearButton.hidden = NO;
       BOOL hasCheck = [self.nestedTableView hasCheckedInSection:indexPath.section];
        self.clearButton.enabled = hasCheck;
        [self.clearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
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

- (EZNestedTableView *)nestedTableView{
    if (!_nestedTableView) {
        id view = [self superview];
        while (view && [view isKindOfClass:[EZNestedTableView class]] == NO) {
            view = [view superview];
        }
        if (view) {
            _nestedTableView = view;
        }
    }
    return _nestedTableView;
}
@end
