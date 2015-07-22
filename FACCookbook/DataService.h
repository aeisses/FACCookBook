//
//  DataService.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface DataService : NSObject

+ (instancetype)sharedInstance;
- (void)fetchRecipeData;
- (void)fetchLocationData;
- (void)fetchFeaturedData;
- (void)fetchPopularData;
- (void)fetchPurchasedData;
- (Recipe*) loadRecipeFromCoreData:(NSNumber*)recipeId;
- (NSArray*)loadRecipeFromCoreData;
@end
