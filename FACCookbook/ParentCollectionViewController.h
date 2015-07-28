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

@interface ParentCollectionViewController : UICollectionViewController <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *recipes;
@property (nonatomic, strong) NSArray *recipeImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

