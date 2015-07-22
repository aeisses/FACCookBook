//
//  FavouriteViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "RecipeViewController.h"

@implementation FavouriteViewController

//@synthesize fetchedResultsController = _fetchedResultsController;
//@synthesize managedObjectContext = _managedObjectContext;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    self.title = @"Favorites";
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (super.fetchedResultsController != nil) {
        return super.fetchedResultsController;
    }

    //NSArray *entities = [NSPersistentStore managedObjectModel];
    //NSArray *entities =
   // NSDictionary* dictionary = [self.managedObjectContext.persistentStoreCoordinator.managedObjectModel entitiesByName]; [dictionary enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) { NSLog(@"%@ = %@", key, obj); }];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    //NSEntityDescription *entity = [NSEntityDescription
           //                        entityForName:@"Popular" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"recipeId" ascending:NO];
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
//                              init];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    [fetchRequest setFetchBatchSize:20];

    // nothing has been favourited yet
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isFavourite == 0"]];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    super.fetchedResultsController = theFetchedResultsController;
    super.fetchedResultsController.delegate = self;
    
    return super.fetchedResultsController;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.fetchedResultsController != nil) {
        Recipe *myRecipe = [super.fetchedResultsController objectAtIndexPath:sender];

        RecipeViewController *recipeViewController = (RecipeViewController *) segue.destinationViewController;
        //recipeViewController.name = myRecipe.title;

        NSIndexPath *path = (NSIndexPath *) sender;
        //recipeViewController.imgPath = [super.recipeImages objectAtIndex:path.row];
    }
}

//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma UICollectioView Data Source
//- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    id  sectionInfo =
//    [[_fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
//}
//
//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}
//
//#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    id info = [_fetchedResultsController objectAtIndexPath:indexPath];
//    NSLog(@"info ");
//    /*
//    cell.textLabel.text = info.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
//                                 info.city, info.state];
// */
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // TODO: Deselect item
//}

@end
#import <Foundation/Foundation.h>
