//
//  FavouriteViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "ParentContainerViewController.h"
#import "AppDelegate.h"
#import "Recipe.h"


@implementation ParentContainerViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize recipeImages = _recipeImages;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _managedObjectContext = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RecipeCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RecipeCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];

    _recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UICollectionViewCell *cell =
    [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    Recipe *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    //cell.

    //cell.textLabel.text = info.title;

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, cell.bounds.size.width, 40)];
    title.tag = 200;
    [cell.contentView addSubview:title];

    title.text = info.title;

    UIImage *image = [UIImage imageNamed:[_recipeImages objectAtIndex:indexPath.row]];

    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.image = image;

    [[cell contentView] addSubview:imageView];
   // cell.imgPath = [super.recipeImages objectAtIndex:path.row];

    // Set up the cell...
//    [self configureCell:cell atIndexPath:indexPath];

    return cell;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


        //cell.textLabel.text = info.title;
        [self performSegueWithIdentifier:@"recipe" sender:indexPath];
    NSLog(@"info ");




    /*
     cell.textLabel.text = info.name;
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
     info.city, info.state];
     */
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

@end
#import <Foundation/Foundation.h>
