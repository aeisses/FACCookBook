//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewController.h"

@interface RecipeViewController()
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGuesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGesture;

- (void)swipeRight;
- (void)swipeLeft;
- (void)swipeHandler:(id)sender;

@end

@implementation RecipeViewController

@synthesize recipe = _recipe;
@synthesize recipes = _recipes;
@synthesize name = _name;
@synthesize swipeLeftGesture = _swipeLeftGesture;
@synthesize swipeRightGuesture = _swipeRightGuesture;

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
    
    __weak RecipeViewController *wSelf = self;
    RecipeViewController *sSelf = wSelf;
    _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:sSelf action:@selector(swipeHandler:)];
    _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:_swipeLeftGesture];
    
    _swipeRightGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:sSelf action:@selector(swipeHandler:)];
    _swipeRightGuesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeRightGuesture];
}

- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view removeGestureRecognizer:_swipeRightGuesture];
    [self.view removeGestureRecognizer:_swipeLeftGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark local methods
- (void)swipeRight {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index > 0) {
        self.recipe = [_recipes objectAtIndex:--index];
        [self loadRecipe];
    }
}

- (void)swipeLeft {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index < [_recipes count]-1) {
        self.recipe = [_recipes objectAtIndex:++index];
        [self loadRecipe];
    }
}

- (void)swipeHandler:(id)sender {
    UISwipeGestureRecognizer *gestureRecognizer = (UISwipeGestureRecognizer*)sender;
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self swipeRight];
    } if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self swipeLeft];
    }
}

@end
