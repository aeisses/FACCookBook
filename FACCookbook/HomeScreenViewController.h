//
//  HomeScreenViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HomeScreenViewLayout.h"

@interface HomeScreenViewController : UICollectionViewController <UICollectionViewDataSource>

@property(nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
