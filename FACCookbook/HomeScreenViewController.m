//
//  HomeScreenViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "RecipeViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "Utils.h"
#import "Featured.h"

//static NSString *cellResueIdentifier = @"Cell";

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

@synthesize recipes = _recipes;

- (NSFetchedResultsController *)recipes {
    if (_recipes != nil) {
        return _recipes;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    _recipes = theFetchedResultsController;
    __weak typeof(self) wSelf = self;
    _recipes.delegate = wSelf;
    return _recipes;
}

#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeViewController* vc = (RecipeViewController*)segue.destinationViewController;
    [vc setRecipe:self.selectedRecipe];
    NSMutableArray *recipes = [NSMutableArray new];
    for (Featured *featured in [_recipes fetchedObjects]) {
        [recipes addObject:featured.recipe];
    }
    [vc setRecipes:recipes];}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.recipes sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];

    Recipe *recipe = [[_recipes fetchedObjects] objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [cell addRecipeImage:recipe forCell:NO];
    } else {
        [cell addRecipeImage:recipe forCell:YES];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    if (indexPath.row == 0) {
        retval = [Utils getSmallStandardSize];
    } else {
        retval = [Utils getSmallCellSize];
    }
    
    return retval;
}

@end
