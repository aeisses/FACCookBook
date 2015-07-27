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
        // TODO: change this to a try/catch or something...
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"recipeId" ascending:NO];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
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

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    //    return [sectionInfo numberOfObjects];
    return 10;
}

@end
