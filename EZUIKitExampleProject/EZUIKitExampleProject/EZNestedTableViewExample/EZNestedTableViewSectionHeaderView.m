//
//  EZNestedTableViewSectionHeaderView.m
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableViewSectionHeaderView.h"


#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)



@interface EZNestedTableViewSectionHeaderView ()
@property (assign, nonatomic) BOOL isRotating;

@end


@implementation EZNestedTableViewSectionHeaderView

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.interactionDelegate tappedHeaderFooterView:self atPoint:point];
}

#pragma mark - EZNestedTableViewSectionHeaderProtocol
- (void)nestedTableView:(EZNestedTableView *)nestedTableView tableView:(UITableView *)tableView sectionHeaderView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerView forSection:(NSInteger)section expanded:(BOOL)expanded animated:(BOOL)animated{
    
    
    
    CGAffineTransform  transform = CGAffineTransformIdentity;
    if (expanded) {
        transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0f));
    }
    
    if (animated && !self.isRotating) {
        
        self.isRotating = YES;
        
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear animations:^{
            self.arrowImageView.transform = transform;
        } completion:^(BOOL finished) {
            self.isRotating = NO;
        }];
        
    } else {
        [self.layer removeAllAnimations];
        self.arrowImageView.transform = transform;
        self.isRotating = NO;
    }
    
}

- (void)nestedTableView:(EZNestedTableView *)nestedTableView tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  sectionModel:(NSObject<EZNestedTableViewSectionModelProtocol> *)sectionModel{
    NSArray<EZNestedTableViewCellModelProtocol> * checkedcells = [nestedTableView checkedCellModelsInSection:section];
    NSMutableString *title = [[NSMutableString alloc] init];
    [title appendString:sectionModel.title];
    [title appendString:@" "];
    NSUInteger count = checkedcells.count;
    for (int i = 0; i < count ; i++) {
        NSObject<EZNestedTableViewCellModelProtocol>* cell = checkedcells[i];
        [title appendString:cell.title];
        if (i < count - 1) {
            [title appendString:@", "];
        }
    }
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    

    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(sectionModel.title.length, title.length - sectionModel.title.length)];
    
    
    self.titleLabel.attributedText = AttributedStr;
    
}
@end
