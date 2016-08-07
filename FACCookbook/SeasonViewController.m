//
//  SeasonViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "SeasonViewController.h"
#import "SeasonColors.h"
#import "Utils.h"

@implementation SeasonViewController

@synthesize recipes = _recipes;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"season == %@ or season == %@",[SeasonColors convertToString:[Utils getCurrentSeason]],[SeasonColors convertToString:[Utils getCurrentSeason]].lowercaseString];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Season"];
    _recipes = theFetchedResultsController;
    ((NSFetchedResultsController*)_recipes).delegate = self;
    
    return _recipes;
}

@end