//
//  EZNestedTableView.m
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableView.h"


@interface EZNestedTableView ()<EZNestedTableViewSectionHeaderInteractionProtocol>

@end


@implementation EZNestedTableView

#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        [self __commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __commonInit];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __commonInit];
        
    }
    return self;
    
    
}

-(void)awakeFromNib{
    
}

#pragma mark - Life Cycle
- (void)dealloc{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

#pragma mark - private
- (void)__commonInit{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.isSingleExpanedOnly = YES;
    if(!self.tableView){
        self.sectionHeaderHeight = 44.0f;
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:self.tableView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    }
    
}

- (NSObject<EZNestedTableViewSectionModelProtocol> *)__sectionModelAtIndex:(NSUInteger)index{
    if( index < self.sectionModels.count){
        NSObject * model = [self.sectionModels objectAtIndex:index];
        if([model conformsToProtocol:@protocol(EZNestedTableViewSectionModelProtocol)]){
            return ((NSObject<EZNestedTableViewSectionModelProtocol> * )model);
        }
    }
    return nil;
}

- (NSObject<EZNestedTableViewCellModelProtocol> *)__cellModelAtIndex:(NSIndexPath *)indexPath{
    
    if( indexPath.section < self.sectionModels.count){
        NSObject * model = [self.sectionModels objectAtIndex:indexPath.section];
        if([model conformsToProtocol:@protocol(EZNestedTableViewSectionModelProtocol)]){
            NSObject<EZNestedTableViewSectionModelProtocol> *  sectionMode = (NSObject<EZNestedTableViewSectionModelProtocol> * )model;
            if (indexPath.row < sectionMode.cellItems.count) {
                NSObject * cellMode = [sectionMode.cellItems objectAtIndex:indexPath.row];
                if([cellMode conformsToProtocol:@protocol(EZNestedTableViewCellModelProtocol)]){
                    return ((NSObject<EZNestedTableViewCellModelProtocol> * )cellMode);
                }
            }
        }
    }
    return nil;
}


- (NSString *)__sectionHeaderReuseIdentifier {
    return [self.sectionHeaderNibName stringByAppendingString:@"ReuseIdentifier"];
}

- (UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol> *)__headerViewInTableView:(UITableView *)tableView dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if ([view conformsToProtocol:@protocol(EZNestedTableViewSectionHeaderProtocol)]) {
        return (UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol> *)view;
    }
    return nil;
}


-(NSNumber *)__tappedSectionInTableView:(UITableView *)tableView atTouchLocation:(CGPoint)location inHeaderFooterView:(UITableViewHeaderFooterView *)headerView {
    CGPoint point = [tableView convertPoint:location
                                   fromView:headerView];
    
    for (NSInteger i = 0; i < [tableView numberOfSections]; i++) {
        CGRect rect = [tableView rectForHeaderInSection:i];
        if (CGRectContainsPoint(rect, point)) {
            return @(i);
        }
    }
    return nil;
}


- (UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol> *)__headerViewInTableView:(UITableView *)tableView forSection:(NSUInteger)section {
    UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *returnValue;
    UITableViewHeaderFooterView *headerFooterView = [tableView headerViewForSection:section];
    if ([headerFooterView conformsToProtocol:@protocol(EZNestedTableViewSectionHeaderProtocol)]) {
        returnValue = (UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerFooterView;
    }
    return returnValue;
}


-(void)__toggleCollapseTableViewSectionAtSection:(NSUInteger)section
                                       withModel:(NSObject<EZNestedTableViewSectionModelProtocol>*)model
                                     inTableView:(UITableView *)tableView
                               usingRowAnimation:(UITableViewRowAnimation)animation
                  forSectionWithHeaderFooterView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerFooterView {
    
    NSArray<NSIndexPath *> *indexPaths = [self __indexPathsForSection:section
                                                       forSectionMode:model];
    if([headerFooterView respondsToSelector:@selector(tableView:sectionHeaderView:forSection:expanded:animated:)]){
        [headerFooterView tableView:tableView sectionHeaderView:headerFooterView forSection:section expanded:model.isExpaned animated:YES];
    }
    if (model.isExpaned) {
        [tableView insertRowsAtIndexPaths:indexPaths
                         withRowAnimation:animation];
    } else {
        [tableView deleteRowsAtIndexPaths:indexPaths
                         withRowAnimation:animation];
    }
    
    
}

-(NSArray<NSIndexPath *> *)__indexPathsForSection:(NSInteger)section forSectionMode:(NSObject<EZNestedTableViewSectionModelProtocol> *)sectionMode {
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSInteger count = sectionMode.cellItems.count;
    NSIndexPath *indexPath;
    for (NSInteger i = 0; i < count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return [indexPaths copy];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionModels.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderHeight;
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    NSObject<EZNestedTableViewSectionModelProtocol> * sectionMode = [self __sectionModelAtIndex:section];
    if ([view conformsToProtocol:@protocol(EZNestedTableViewSectionHeaderProtocol)]) {
        UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol>* headerView = (UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol>*)view;
        if([headerView respondsToSelector:@selector(tableView:sectionHeaderView:forSection:expanded:animated:)]){
            [headerView tableView:tableView sectionHeaderView:headerView forSection:section expanded:sectionMode.isExpaned animated:NO];
        }
    }
}


/*
 - ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 NSObject<EZNestedTableViewSectionModelProtocol> * sectionModel = [self __sectionModelAtIndex:section];
 return sectionModel.name;
 }
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView<EZNestedTableViewSectionHeaderProtocol>* headerView = [self __headerViewInTableView:tableView dequeueReusableHeaderFooterViewWithIdentifier:[self __sectionHeaderReuseIdentifier]];
    headerView.interactionDelegate = self;
    NSObject<EZNestedTableViewSectionModelProtocol> * sectionModel = [self __sectionModelAtIndex:section];
    headerView.titleLabel.text = sectionModel.name;
    return headerView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSObject<EZNestedTableViewSectionModelProtocol> * sectionModel = [self __sectionModelAtIndex:sectionIndex];
    return sectionModel.isExpaned?sectionModel.cellItems.count:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSObject<EZNestedTableViewCellModelProtocol> * cellMode = [self __cellModelAtIndex:indexPath];
    cell.textLabel.text = cellMode.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - EZNestedTableViewSectionHeaderProtocol
-(void)tappedHeaderFooterView:(UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *)headerView atPoint:(CGPoint)point{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSNumber *value = [self __tappedSectionInTableView:self.tableView
                                       atTouchLocation:point
                                    inHeaderFooterView:headerView];
    if (!value) {
        return;
    }
    NSInteger tappedSection = value.integerValue;
    [self.tableView beginUpdates];
    NSUInteger count = self.sectionModels.count;
    for (NSUInteger i = 0; i <= count; i++) {
        NSObject<EZNestedTableViewSectionModelProtocol> * sectionMode = [self __sectionModelAtIndex:i];
        if (!sectionMode) {
            continue;
        }
        
        if (i == tappedSection) {
            sectionMode.isExpaned = !sectionMode.isExpaned;
            [self __toggleCollapseTableViewSectionAtSection:tappedSection
                                                  withModel:sectionMode
                                                inTableView:self.tableView
                                          usingRowAnimation: UITableViewRowAnimationTop
                             forSectionWithHeaderFooterView:headerView];
        }else if(sectionMode.isExpaned && self.isSingleExpanedOnly){
            sectionMode.isExpaned = !sectionMode.isExpaned;
            UITableViewHeaderFooterView <EZNestedTableViewSectionHeaderProtocol> *untappedHeaderFooterView = [self __headerViewInTableView:self.tableView forSection:i];
            
            [self __toggleCollapseTableViewSectionAtSection:i
                                                  withModel:sectionMode
                                                inTableView:self.tableView
                                          usingRowAnimation:(tappedSection > i) ? UITableViewRowAnimationTop : UITableViewRowAnimationBottom
                             forSectionWithHeaderFooterView:untappedHeaderFooterView];
            
        }
        
        
    }
    [self.tableView endUpdates];
    
}


#pragma mark - set get
-(void)setSectionHeaderNibName:(NSString *)sectionHeaderNibName{
    _sectionHeaderNibName = sectionHeaderNibName;
    UINib *nib = [UINib nibWithNibName:_sectionHeaderNibName bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[self __sectionHeaderReuseIdentifier]];
}


@end
