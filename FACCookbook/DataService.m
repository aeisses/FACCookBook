//
//  DataService.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

#import "DataService.h"
#import "AppDelegate.h"
#import "Direction.h"
#import "Ingredient.h"
#import "Recipe.h"
#import "Location.h"
#import "Note.h"
#import "Popular.h"
#import "Information.h"
#import "SearchItems.h"
#import "Categories.h"
#import "Featured.h"

static int kPopularId = 1001;
static int kFeaturedId = 1002;

@interface DataService()

@property (retain, nonatomic) AFHTTPRequestOperationManager *httpManager;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *popularArray;
@property (strong, nonatomic) NSArray *featuredArray;

- (void)processRecipesData:(NSDictionary*)jsonData;
- (void)processRecipeData:(NSDictionary*)recipe;

@end

@implementation DataService

+ (NSString *)protocol {
    return @"https";
}

+ (NSString *)domain {
    return @"dl.dropboxusercontent.com";
}

// XXX: For querying testdata dropbox does not set the content-type header properly so we can't use
// built-in json serialization.
// Once the server is up and gtg it should be sending valid content-types and we can cut out manual serialization.

+ (NSString *)allRecipiesEndpoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/recipies.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)newRecipiesEndpoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/recipies.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)featuredEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/featured.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)locationEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/location.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)popularEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/popular.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)purchasedEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/purchased.json", [DataService protocol], [DataService domain]];
}

@synthesize httpManager = _httpManager;
@synthesize managedObjectContext = _managedObjectContext;

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _httpManager = [AFHTTPRequestOperationManager manager];
        [[self httpManager] setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [[self httpManager] setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        _managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return self;
}


- (void)loadInformation:(NSDictionary*)information {
    // TODO: Check if information exists
    Information *informationDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    informationDataObject.version = (NSString*)[information objectForKey:@"version"];
    informationDataObject.season = (NSNumber*)[information objectForKey:@"season"];
    NSError *error = nil;
    [_managedObjectContext save:&error];
    // TODO: Handle error
}

- (void)loadPopular:(NSArray*)popular {
    // TODO: Check if popular exists
    Popular *popularDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    NSMutableOrderedSet *popularSet = [NSMutableOrderedSet new];
    for (NSNumber *item in popular) {
        Recipe *recipe = [self loadRecipeFromCoreData:item];
        recipe.popular = popularDataObject;
        [popularSet addObject:recipe];
    }
    NSError *error = nil;
    [_managedObjectContext save:&error];
    // TODO: Handle error
}

- (void)processLocationData:(NSDictionary*)location {
    // TODO: Check if location exists
    Location *locationDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    locationDataObject.email = (NSString*)[location objectForKey:@"email"];
    locationDataObject.address = (NSString*)[location objectForKey:@"address"];
    locationDataObject.latitude = (NSNumber*)[location objectForKey:@"latitude"];
    locationDataObject.longitude = (NSNumber*)[location objectForKey:@"longitude"];
    locationDataObject.phone = (NSString*)[location objectForKey:@"phone"];
    locationDataObject.story = (NSString*)[location objectForKey:@"story"];
    locationDataObject.type = (NSString*)[location objectForKey:@"type"];
    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error :%@",[error description]);
    }
    else{
        [self loadLocationFromCoreData:[NSNumber numberWithInt:1]];
    }
    // TODO: Handle error
}

- (void)processSearchItems:(NSArray *)items recipe:(Recipe *)recipe {
    NSMutableSet *recipeSearchItems = [NSMutableSet setWithSet:recipe.searchItems];
    NSEntityDescription *searchItems = [NSEntityDescription entityForName:@"SearchItems" inManagedObjectContext:_managedObjectContext];
    
    for (NSString *item in items) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"item == %@", item];
        fetchRequest.entity = searchItems;
        NSArray *fetchedObject = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];

        if(![fetchedObject count]) {
            SearchItems *newSearchItem = [NSEntityDescription insertNewObjectForEntityForName:@"SearchItems" inManagedObjectContext:_managedObjectContext];
            newSearchItem.item = item;
            newSearchItem.recipes = [NSSet setWithObject:recipe];

            [recipeSearchItems addObject:newSearchItem];
        } else {
            SearchItems *foundSearchItem = fetchedObject[0];
            [recipeSearchItems addObject:foundSearchItem];

            NSMutableSet *recipes = [NSMutableSet setWithSet:foundSearchItem.recipes];
            [recipes addObject:recipe];

            foundSearchItem.recipes = recipes;
        }
    }

    recipe.searchItems = recipeSearchItems;
}

- (void)processCategories:(NSArray *)categories recipe:(Recipe *)recipe {
    if ([categories isKindOfClass:[NSNull class]]) {
        return;
    }

    NSMutableSet *recipeCategories = [NSMutableSet setWithSet:recipe.categories];
    NSEntityDescription *lookupCategories = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:_managedObjectContext];

    for (NSString *category in categories) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
        fetchRequest.entity = lookupCategories;
        NSArray *fetchedObject = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];

        if(![fetchedObject count]) {
            Categories *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Categories" inManagedObjectContext:_managedObjectContext];
            newCategory.category = category;
            newCategory.recipes = [NSSet setWithObject:recipe];

            [recipeCategories addObject:newCategory];
        } else {
            SearchItems *foundCategory = fetchedObject[0];
            [recipeCategories addObject:foundCategory];

            NSMutableSet *recipes = [NSMutableSet setWithSet:foundCategory.recipes];
            [recipes addObject:recipe];

            foundCategory.recipes = recipes;
        }
    }

    recipe.categories = recipeCategories;
}

- (void)processRecipesData:(NSDictionary*)jsonData {
    NSArray *recipes = [jsonData objectForKey:@"recipes"];
    // Temporary quick fix:
    if([recipes count] != [[self loadRecipeFromCoreData] count]){
        for (NSDictionary *recipe in recipes) {
            [self processRecipeData:recipe];
        }
    }
    [self processPopularData];
    [self processFeaturedData];
}

- (void)processRecipeData:(NSDictionary*)recipe {
    // TODO: Check if recipe exists
    Recipe *recipeDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM:dd:YYYY"];
    recipeDataObject.addDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"addedDate"]];
    recipeDataObject.updateDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"updatedDate"]];
    recipeDataObject.title = (NSString*)[recipe objectForKey:@"title"];
    recipeDataObject.season = (NSString*)[recipe objectForKey:@"season"];
    recipeDataObject.recipeId = (NSNumber*)[recipe objectForKey:@"recipeId"];
    recipeDataObject.type = (NSString*)[recipe objectForKey:@"type"];
    recipeDataObject.isFavourite = 0;

    [self processSearchItems:[recipe objectForKey:@"searchItems"] recipe:recipeDataObject];
    [self processCategories:[recipe objectForKey:@"category"] recipe:recipeDataObject];

    NSArray *directions = (NSArray*)[recipe objectForKey:@"directions"];
    NSMutableOrderedSet *directionSet = [NSMutableOrderedSet new];
    for (NSDictionary *direction in directions) {
        Direction *directionDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Direction" inManagedObjectContext:_managedObjectContext];
        directionDataObject.direction = (NSString*)[direction objectForKey:@"direction"];
        directionDataObject.recipe = recipeDataObject;
        [directionSet addObject:directionDataObject];
    }
    recipeDataObject.directions = directionSet;
    
    NSArray *ingredients = (NSArray*)[recipe objectForKey:@"ingredients"];
    NSMutableOrderedSet *ingredientSet = [NSMutableOrderedSet new];
    for (NSDictionary *ingredient in ingredients) {
        Ingredient *ingredientDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:_managedObjectContext];
        ingredientDataObject.amount = (NSString*)[ingredient objectForKey:@"amount"];
        ingredientDataObject.ingredient = (NSString*)[ingredient objectForKey:@"ingredient"];
        ingredientDataObject.recipe = recipeDataObject;
        [ingredientSet addObject:ingredientDataObject];
    }
    recipeDataObject.ingredients = ingredientSet;
    
    NSArray *notes = (NSArray*)[recipe objectForKey:@"notes"];
    NSMutableOrderedSet *noteSet = [NSMutableOrderedSet new];
    for (NSDictionary *note in notes) {
        Note *noteDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:_managedObjectContext];
        noteDataObject.note = (NSString*)[note objectForKey:@"note"];
        noteDataObject.recipe = recipeDataObject;
        [noteSet addObject:noteDataObject];
    }
    recipeDataObject.notes = noteSet;
    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }
    // TODO: Handle error
}


- (void)processPopularData{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *popularEntity = [NSEntityDescription entityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:popularEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Add a predicate later.
    Popular *popular;
    if([results count]){
        popular = [results lastObject];
    }
    else{
        popular = [NSEntityDescription insertNewObjectForEntityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    }

    NSMutableOrderedSet *popularSet = [NSMutableOrderedSet new];
    for(NSNumber *number in _popularArray){
        Recipe *recipe = [self loadRecipeFromCoreData:number];
        recipe.popular = popular;
        [popularSet addObject:recipe];
    }

    [popular setRecipes:popularSet];
    [popular setPopularId:[NSNumber numberWithInt:kPopularId]];

    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }
}

- (void)processFeaturedData{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *featuredEntity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:featuredEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Add a predicate later.
     Featured *featured;
    if([results count]){
        featured = [results lastObject];
    }
    else{
        featured = [NSEntityDescription insertNewObjectForEntityForName:@"Featured" inManagedObjectContext:_managedObjectContext];
    }

    NSMutableOrderedSet *featuredSet = [NSMutableOrderedSet new];
    for(NSNumber *number in _featuredArray){
        Recipe *recipe = [self loadRecipeFromCoreData:number];
        recipe.featured = featured;
        [featuredSet addObject:recipe];
    }
    
    [featured setRecipes:featuredSet];
    [featured setFeaturedId:[NSNumber numberWithInt:kFeaturedId]];

    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }
}

- (void)fetchRecipeData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }
        NSLog(@"Recipe JSON :%@",responseDict);
        [self processRecipesData:responseDict];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    [[self httpManager] GET:[DataService allRecipiesEndpoint] parameters:nil success:success failure:failure];
}

- (void)fetchLocationData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }

        // Add data processer here!
        NSLog(@"Location response :%@",responseDict);
        [self processLocationData:responseDict];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    [[self httpManager] GET:[DataService locationEndPoint] parameters:nil success:success failure:failure];
}


- (void)fetchFeaturedData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }

        // Add data processer here!
        _featuredArray = [NSArray arrayWithArray:(NSArray*)responseDict];

    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    [[self httpManager] GET:[DataService featuredEndPoint] parameters:nil success:success failure:failure];
}

- (void)fetchPopularData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }
        // Add data processer here!
        _popularArray = [NSArray arrayWithArray:(NSArray*)responseDict];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    [[self httpManager] GET:[DataService popularEndPoint] parameters:nil success:success failure:failure];
}

- (void)fetchPurchasedData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }
        // Add data processer here!
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    [[self httpManager] GET:[DataService purchasedEndPoint] parameters:nil success:success failure:failure];
}


- (Recipe*)loadRecipeFromCoreData:(NSNumber*)recipeId {
    // Fetch Request
    NSFetchRequest *recipeFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipeEntity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    [recipeFetchRequest setEntity:recipeEntity];

    NSPredicate *recipeIdPredicate = [NSPredicate predicateWithFormat:@"recipeId = %@",recipeId];
    [recipeFetchRequest setPredicate:recipeIdPredicate];
    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:recipeFetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        return  (Recipe*)[results lastObject];
    }

    return nil;
}


- (NSArray*)loadRecipeFromCoreData {
    // Fetch Request
    NSFetchRequest *recipeFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipeEntity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    [recipeFetchRequest setEntity:recipeEntity];

    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:recipeFetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        NSLog(@"Recipe results :%@",results);

        return  results;
    }

    return nil;
}

- (Location*)loadLocationFromCoreData:(NSNumber*)locationId{
    NSFetchRequest *locationRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    [locationRequest setEntity:entity];

    NSError *error = nil;
    NSArray *results = [_managedObjectContext executeFetchRequest:locationRequest error:&error];
    if(error){
        NSLog(@"error :%@",[error description]);
    }
    else{
        NSLog(@"Results :%@",results);
        return (Location*)[results lastObject];
    }

    return nil;
}

- (Popular*)loadPopularDataFromCoreData:(NSNumber*)popularId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"popularId = %@",popularId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        return  (Popular*)[results lastObject];
    }

    return nil;
}

- (Featured*)loadFeaturedDataFromCoreData:(NSNumber*)featuredId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"featuredId = %@",featuredId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        return  (Featured*)[results lastObject];
    }

    return nil;
}

@end
