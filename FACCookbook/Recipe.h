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

@property (nonatomic, retain) NSDate *addDate;
@property (nonatomic, retain) NSString *recipeId;
@property (nonatomic, retain) NSString *searchElements;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *updateDate;

@property (nonatomic, retain) NSOrderedSet *directions;
@property (nonatomic, retain) NSOrderedSet *ingredients;
@property (nonatomic, retain) NSOrderedSet *notes;

@end
