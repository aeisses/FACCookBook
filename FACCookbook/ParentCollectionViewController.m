//
//  FavouriteViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "ParentCollectionViewController.h"
#import "RecipeViewController.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "Utils.h"
#import "RecipeCell.h"

static NSString *cellResueIdentifier = @"Cell";

@interface ParentCollectionViewController()
@property (retain, nonatomic) Recipe *selectedRecipe;
@end

@implementation ParentCollectionViewController

@synthesize recipes = _recipes;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize recipeImages = _recipeImages;
@synthesize collectionView = _collectionView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self recipes] performFetch:&error]) {
        NSLog(@"Unresolved error %@", error);
        exit(-1);
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:@"RecipeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellResueIdentifier];
}

- (void)viewDidUnload {
    self.recipes = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeViewController* vc = (RecipeViewController*)segue.destinationViewController;
    [vc setRecipe:_selectedRecipe];
    [vc setRecipes:[_recipes fetchedObjects]];
}

#pragma UICollectioView Data Source
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.recipes sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRecipe =  [self.recipes objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"recipe" sender:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    Recipe *recipe = [[_recipes fetchedObjects] objectAtIndex:indexPath.row];
    [cell addRecipeImage:recipe forCell:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils getSmallCellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
