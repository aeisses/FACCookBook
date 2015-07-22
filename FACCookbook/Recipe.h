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

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *addDate;
@property (nonatomic, retain) NSNumber *recipeId;
@property (nonatomic, retain) NSString *season;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSSet *searchItems;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSDate *updateDate;
@property (nonatomic, retain) NSNumber *isFavourite;

@property (nonatomic, retain) NSOrderedSet *directions;
@property (nonatomic, retain) NSOrderedSet *ingredients;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) NSOrderedSet *information;
@property (nonatomic, retain) NSManagedObject *popular;
@property (nonatomic, retain) NSManagedObject *featured;

@end
