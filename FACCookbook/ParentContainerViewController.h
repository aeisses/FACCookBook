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



@interface ParentContainerViewController : UICollectionViewController <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *recipeImages;

@end

