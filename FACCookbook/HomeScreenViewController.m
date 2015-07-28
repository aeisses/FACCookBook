//
//  HomeScreenViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "Utils.h"
#import "Featured.h"

static NSString *cellResueIdentifier = @"Cell";

@interface HomeScreenViewController ()

@property (retain, nonatomic) Recipe *selectedRecipe;

@end

@implementation HomeScreenViewController

@synthesize recipes = _recipes;
@synthesize featuredRecipes = _featuredRecipes;

- (NSFetchedResultsController *)recipes {
    if (_recipes != nil) {
        return _recipes;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"addDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    _recipes = theFetchedResultsController;
    __weak typeof(self) wSelf = self;
    _recipes.delegate = wSelf;
    return _recipes;
}

- (NSArray*)featuredRecipes {
    if (_featuredRecipes) {
        return _featuredRecipes;
    }
    
    _featuredRecipes = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedFeaturedArea = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (fetchedFeaturedArea && [fetchedFeaturedArea count] == 1)
    {
        Featured *featured = [fetchedFeaturedArea firstObject];
        _featuredRecipes = [featured.recipes array];
    }
    return _featuredRecipes;
}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.featuredRecipes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];

    Recipe *recipe = [_featuredRecipes objectAtIndex:indexPath.row];
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
