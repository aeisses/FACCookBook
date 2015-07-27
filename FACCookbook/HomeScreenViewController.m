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

static NSString *cellResueIdentifier = @"Cell";

@interface HomeScreenViewController () {
    NSArray *recipeImages;
}
@end

@implementation HomeScreenViewController

@synthesize collectionView = _collectionView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@", error);
        exit(-1);
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:@"RecipeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellResueIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // TODO -- get featured
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"addDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    self.fetchedResultsController = theFetchedResultsController;
    __weak typeof(self) wSelf = self;
    _fetchedResultsController.delegate = wSelf;
    return _fetchedResultsController;
}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0) {
        [cell addRecipeImage:nil forCell:NO];
    } else {
        [cell addRecipeImage:nil forCell:YES];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //RecipeViewController *recipeViewController = [[RecipeViewController alloc] init];
    //recipeViewController.imgPath = [recipeImages objectAtIndex:indexPath.row];
    
    // RecipeViewController *recipeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"recipeViewController"];
    // TODO -- real name
    //recipeViewController.name = @"Cool Recipe";
    //[self.navigationController pushViewController:recipeViewController animated:YES];
    
    [self performSegueWithIdentifier:@"recipe" sender:indexPath];
    
    NSLog(@"Pushed new View Controller");
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"Screen Size %f %f", screenRect.size.width, screenRect.size.height);
    
    CGSize retval;
    if (indexPath.row == 0) {
        retval = [Utils getSmallStandardSize];
    } else {
        retval = [Utils getSmallCellSize];
    }
    
    return retval;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeViewController *recipeViewController = (RecipeViewController *) segue.destinationViewController;
    
    NSIndexPath *path = (NSIndexPath *) sender;
    recipeViewController.recipe = [_fetchedResultsController objectAtIndexPath:path];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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
