//
//  HomeScreenViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "AppDelegate.h"
#import "RecipeViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "Utils.h"
#import "Featured.h"

static NSString *cellResueIdentifier = @"Cell";

@interface HomeScreenViewController () {
    NSArray *recipeImages;
}

@property (retain, nonatomic) Recipe *selectedRecipe;

@end

@implementation HomeScreenViewController

@synthesize collectionView = _collectionView;
@synthesize recipes = _recipes;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize featuredRecipes = _featuredRecipes;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self recipes] performFetch:&error]) {
        NSLog(@"Unresolved error %@", error);
        exit(-1);
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:@"RecipeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellResueIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
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

//#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeViewController* vc = (RecipeViewController*)segue.destinationViewController;
    [vc setRecipe:_selectedRecipe];
    [vc setRecipes:[_recipes fetchedObjects]];
}

//#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRecipe =  [_featuredRecipes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"recipe" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    // [self.collectionView beginUpdates];
    NSLog(@"CONTROLLER WILL CHANGE CONTENT!!");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSLog(@"Did change object");
    
//    UICollectionView *collectionView = self.collectionView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            // [collectionView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            /*
             [tableView deleteRowsAtIndexPaths:[NSArray
             arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
             [tableView insertRowsAtIndexPaths:[NSArray
             arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
             */
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"did change section");
    /*
     switch(type) {
     
     case NSFetchedResultsChangeInsert:
     [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
     break;
     
     case NSFetchedResultsChangeDelete:
     [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
     break;
     }
     */
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    // [self.tableView endUpdates];
    NSLog(@"The content has finished changing");
}

@end
