//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewController.h"

@implementation RecipeViewController

@synthesize recipe = _recipe;
@synthesize recipes = _recipes;
@synthesize name = _name;

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
    // or if you are sure you wanna it always on left:
    // [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
}

- (void)loadRecipe {
    _name.text = _recipe.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRecipe];
}

- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _recipe = nil;
    _recipes = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIScrollView *scrollView = (UIScrollView *) self.view;
//    [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];

//    self.instructions.text = @"";
  
}

- (IBAction)handleRightSwipe:(id)sender {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index > 0) {
        self.recipe = [_recipes objectAtIndex:--index];
        [self loadRecipe];
    }
}

- (IBAction)handleLeftSwipe:(id)sender {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index < [_recipes count]) {
        self.recipe = [_recipes objectAtIndex:++index];
        [self loadRecipe];
    }
}

@end
