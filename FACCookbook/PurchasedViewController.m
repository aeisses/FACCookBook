//
//  PurchasedViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import "PurchasedViewController.h"
#import "PurchasedTableViewCell.h"
#import "Purchased.h"
#import "Recipe.h"
#import "DataService.h"

@interface PurchasedViewController ()

@property (retain, nonatomic) NSArray *purchasedReciped;

@end

@implementation PurchasedViewController

@synthesize purchasedReciped = _purchasedReciped;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchasedTableViewCell" bundle:nil] forCellReuseIdentifier:@"PurchasedCell"];
    _purchasedReciped = [[DataService sharedInstance] loadPurchasedDataFromCoreData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_purchasedReciped count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchasedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchasedCell"];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PurchasedTableViewCell" owner:self options:nil];
        cell = (PurchasedTableViewCell *)[nib objectAtIndex:0];
    }

    Purchased *purchased = [_purchasedReciped objectAtIndex:indexPath.row];
    Recipe *recipe = (Recipe*)purchased.recipe;
    
    cell.recipeTitle.text = recipe.title;
    cell.season.text = recipe.season;
    cell.purchaseCost.text = @"$0.99";
    [cell addRecipeImage:recipe forCell:YES];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Purchasable Items";
}

@end
