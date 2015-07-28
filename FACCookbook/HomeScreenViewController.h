//
//  HomeScreenViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewLayout.h"
#import "ParentCollectionViewController.h"

@interface HomeScreenViewController : ParentCollectionViewController

@property (nonatomic, retain) NSFetchedResultsController *recipes;
@property (nonatomic, retain) NSArray *featuredRecipes;

@end
