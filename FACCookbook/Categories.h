//
//  Categories.h
//  FACCookbook
//
//  Created by Jeremy Wright on 7/22/15.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSSet *recipes;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addRecipesObject:(NSManagedObject *)value;
- (void)removeRecipesObject:(NSManagedObject *)value;
- (void)addRecipes:(NSSet *)values;
- (void)removeRecipes:(NSSet *)values;

@end
