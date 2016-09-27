//
//  DataService.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "FICImageCache.h"

@interface DataService : NSObject <FICImageCacheDelegate>

+ (instancetype)sharedInstance;
+ (NSString*)imageFormat:(BOOL)isCell;
+ (NSString*)urlForResources;

- (void)fetchData;

- (Recipe*) loadRecipeFromCoreData:(NSNumber*)recipeId;
- (NSArray*)loadRecipeFromCoreData;
- (NSArray *)loadLocationsFromCoreData;
- (NSArray*)loadPurchasedDataFromCoreData;
- (void)updateFavouite:(Recipe*)recipe;

@end
