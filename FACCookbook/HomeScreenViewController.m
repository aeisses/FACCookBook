//
//  HomeScreenViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewController.h"

#import "RecipeViewController.h"

@interface HomeScreenViewController () {
  NSArray *recipeImages;
}

@end

@implementation HomeScreenViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
  
  recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
  return recipeImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"recipe";
  UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
  recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
  
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
    retval = CGSizeMake(screenRect.size.width - 50, 150);
  } else {
    retval = CGSizeMake((screenRect.size.width - 50) / 2, 150);
  }
  
  return retval;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  RecipeViewController *recipeViewController = (RecipeViewController *) segue.destinationViewController;
  recipeViewController.name = @"HELLO";
  
  NSIndexPath *path = (NSIndexPath *) sender;
  recipeViewController.imgPath = [recipeImages objectAtIndex:path.row];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
