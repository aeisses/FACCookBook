//
//  SearchItems.h
//  FACCookbook
//
//  Created by Jeremy Wright on 7/22/15.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface SearchItems : NSManagedObject

@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSSet *recipes;
@end

@interface SearchItems (CoreDataGeneratedAccessors)

- (void)addRecipeObject:(NSManagedObject *)value;
- (void)removeRecipeObject:(NSManagedObject *)value;
- (void)addRecipe:(NSSet *)values;
- (void)removeRecipe:(NSSet *)values;

@end
