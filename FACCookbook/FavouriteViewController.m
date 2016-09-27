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

@synthesize recipes = _recipes;

- (void)viewDidAppear:(BOOL)animated {
    _recipes = nil;
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
}

- (id)recipes {
    if (_recipes != nil) {
        return _recipes;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"recipeId" ascending:NO];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavourite == YES"];
    [fetchRequest setFetchBatchSize:20];

    _recipes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return _recipes;
}

@end
