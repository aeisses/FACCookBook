//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewController.h"

@implementation RecipeViewController

- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
}

- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
  
  self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
  self.recipeNameLabel.text = self.name;
  self.recipeImage.image = [UIImage imageNamed:self.imgPath];
  /*
  UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:100];
  recipeImageView.image = [UIImage imageNamed:self.imgPath];
   */
  
  NSLog(@"View has loaded");
}

@end
