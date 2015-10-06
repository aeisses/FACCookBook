//
//  PurchasedViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import "PurchasedViewController.h"
#import "PurchasedTableViewCell.h"

@implementation PurchasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchasedTableViewCell" bundle:nil] forCellReuseIdentifier:@"PurchasedCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchasedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchasedCell"];
//    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PurchasedTableViewCell" owner:self options:nil];
        cell = (PurchasedTableViewCell *)[nib objectAtIndex:0];
    }
//    
//    NSString *item = [[_ingredientsDictionary allKeys] objectAtIndex:indexPath.section];
//    NSArray *cellItems = [_ingredientsDictionary objectForKey:item];
//    LocalIngredient *lIngred = [cellItems objectAtIndex:indexPath.row];
//    
//    cell.ingredient.text = lIngred.ingredient;
//    cell.amount.text = lIngred.amount;
//    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Purchasable Items";
}

@end
