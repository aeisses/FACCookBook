//
//  FavouriteViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "ParentCollectionViewController.h"
#import "RecipeViewController.h"
#import "FavouriteViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "Utils.h"
#import "RecipeCell.h"
#import "Featured.h"

NSString *cellResueIdentifier = @"Cell";
static NSString *nibName = @"RecipeCell";
static NSString *segueIdentifier = @"recipe";

@interface ParentCollectionViewController()
@property NSMutableArray *sectionChanges;
@property NSMutableArray *itemChanges;
@end

@implementation ParentCollectionViewController

@synthesize recipes = _recipes;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize recipeImages = _recipeImages;
@synthesize collectionView = _collectionView;

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error;
    if ([self.recipes isKindOfClass:[NSFetchedResultsController class]]) {
        if (![[self recipes] performFetch:&error]) {
            NSLog(@"Unresolved error %@", error);
            exit(-1);
        }
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellResueIdentifier];
    
    [self.collectionView setBackgroundColor:[SeasonColors backgroundColor:[Utils getCurrentSeason]]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.recipes = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    RecipeViewController* vc = (RecipeViewController*)segue.destinationViewController;
    if ([((UITabBarController*)[navigationController topViewController]).selectedViewController isKindOfClass:[SearchViewController class]] ||
        [((UITabBarController*)[navigationController topViewController]).selectedViewController isKindOfClass:[FavouriteViewController class]]) {
        [vc setShowNavigationBar:YES];
    }
    [vc setRecipe:_selectedRecipe];
    if ([self.recipes isKindOfClass:[NSArray class]]) {
        [vc setRecipes:self.recipes];
    } else {
        [vc setRecipes:[self.recipes fetchedObjects]];
    }
}

#pragma UICollectioView Data Source
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ([self.recipes isKindOfClass:[NSArray class]]) {
        return [self.recipes count];
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.recipes sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object;
    if ([self.recipes isKindOfClass:[NSArray class]]) {
        object = [self.recipes objectAtIndex:indexPath.row];
    } else {
        object = [self.recipes objectAtIndexPath:indexPath];
    }
    if ([object isKindOfClass:[Featured class]]) {
        _selectedRecipe = (Recipe*)((Featured*)object).recipe;
    } else {
        _selectedRecipe = (Recipe*)object;
    }
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    Recipe *recipe;
    if ([self.recipes isKindOfClass:[NSArray class]]) {
        recipe = [self.recipes objectAtIndex:indexPath.row];
    } else {
        recipe = [[self.recipes fetchedObjects] objectAtIndex:indexPath.row];
    }
    [cell addRecipeImage:recipe forCell:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils getSmallCellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat cellWidth = [Utils getSmallCellSize].width;
    CGFloat screenWidth = [[self view] frame].size.width;
    CGFloat cellSpacing = (screenWidth - (cellWidth*2))/3;
    return UIEdgeInsetsMake(5, cellSpacing, 5, cellSpacing);
}

#pragma mark FetchResultsController Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [_sectionChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    default:
                        break;
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
        _sectionChanges = nil;
        _itemChanges = nil;
    }];
}

@end
