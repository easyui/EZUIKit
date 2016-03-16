//
//  EZNestedTableViewExample.m
//  EZUIKitExampleProject
//
//  Created by yangjun zhu on 16/3/16.
//  Copyright © 2016年 Cactus. All rights reserved.
//

#import "EZNestedTableViewExample.h"
#import "SectionModel.h"
#import "CellModel.h"
@interface EZNestedTableViewExample ()
@property (weak, nonatomic) IBOutlet EZNestedTableView *nestedTableView;

@end

@implementation EZNestedTableViewExample
+(NSArray <EZNestedTableViewSectionModelProtocol > *)buildSectionModel {
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; i++) {
        
        SectionModel *section = [[SectionModel alloc] init];
        section.name = [NSString stringWithFormat:@"section %ld",(long)i];
        
        NSMutableArray *cells = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < 5; j++) {
            
            CellModel *cell = [[CellModel alloc] init];
            cell.title = [NSString stringWithFormat:@"cell %ld",(long)i];
            [cells addObject:cell];
        }

        section.cellItems = [cells copy];
        [sections addObject:section];
    }
    return [sections copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nestedTableView.sectionModels = [EZNestedTableViewExample buildSectionModel];
    [self.nestedTableView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
