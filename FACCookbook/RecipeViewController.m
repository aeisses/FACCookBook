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
  
  
  self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
  /*
  UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:100];
  recipeImageView.image = [UIImage imageNamed:self.imgPath];
   */
  
  NSLog(@"View has loaded");
}

@end
