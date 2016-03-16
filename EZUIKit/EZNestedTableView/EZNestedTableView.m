//
//  EZNestedTableView.m
//  EZUIKit
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableView.h"


@interface EZNestedTableView ()

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
    if(!self.tableView){
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
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



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionModels.count;
}

- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSObject<EZNestedTableViewSectionModelProtocol> * sectionModel = [self __sectionModelAtIndex:section];
    return sectionModel.name;
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
    // Update cell data contents
    cell.textLabel.text = @"Your text here";
    cell.detailTextLabel.text=@"Your detailed text label";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}



#pragma mark - UITableViewDataSource


@end
