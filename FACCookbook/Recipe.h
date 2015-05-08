//
//  Recipe.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-06.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber *recipeId;
@property (nonatomic, retain) NSNumber *season;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *searchItems;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *updateDate;
@property (nonatomic, retain) NSNumber *isFavourite;

@property (nonatomic, retain) NSOrderedSet *directions;
@property (nonatomic, retain) NSOrderedSet *ingredients;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) NSOrderedSet *information;
@property (nonatomic, retain) NSManagedObject *popular;
@property (nonatomic, retain) NSManagedObject *featured;

@end
