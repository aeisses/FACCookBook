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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.fetchedResultsController != nil) {
        Recipe *myRecipe = [super.fetchedResultsController objectAtIndexPath:sender];

        RecipeViewController *recipeViewController = (RecipeViewController *) segue.destinationViewController;
        //recipeViewController.name = myRecipe.title;

//        NSIndexPath *path = (NSIndexPath *) sender;
//        //recipeViewController.image = UIImage [super.recipeImages objectAtIndex:path.row];
//
//        UIImage *image = [UIImage imageNamed:[super.recipeImages objectAtIndex:path.row]];
//
//        UIImageView *imageView =  [[UIImageView alloc] initWithFrame:];
//        recipeViewController.image = imageView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    UICollectionViewCell *cell =
    [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    Recipe *info = [super.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.

    //cell.textLabel.text = info.title;

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, cell.bounds.size.width, 40)];
    title.tag = 200;
    [cell.contentView addSubview:title];

    title.text = info.title;

    UIImage *image = [UIImage imageNamed:[super.recipeImages objectAtIndex:indexPath.row]];

    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.image = image;

    [[cell contentView] addSubview:imageView];
    // cell.imgPath = [super.recipeImages objectAtIndex:path.row];

    // Set up the cell...
    //    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

@end
