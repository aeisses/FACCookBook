//
//  ParentContainerViewController.h
//  FACCookbook
//
//  Created by Kirk MacPhee on 2015-07-22.
//  Copyright (c) 2015 EAC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Recipe.h"

extern NSString       *cellResueIdentifier;

@interface ParentCollectionViewController : UICollectionViewController <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) id recipes;
@property (nonatomic, strong) NSArray *recipeImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (retain, nonatomic) Recipe *selectedRecipe;

@end

