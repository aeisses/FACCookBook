//
//  DataService.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

#import "DataService.h"
#import "Utils.h"
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
#import "Purchased.h"

static int kPopularId = 1001;
static int kPurchasedId = 1003;

static NSString *FCBFormaCellSmall = @"FCBCellSmall";
static NSString *FCBFormatCellMedium = @"FCBCellMedium";
static NSString *FCBFormatCellLarge = @"FCBCellLarge";
static NSString *FCBFormatStandardSmall = @"FCBStandardSmall";
static NSString *FCBFormatStandardMedium = @"FCBStandardMedium";
static NSString *FCBFormatStandardLarge = @"FCBStandardLarge";

static NSString *FCBFormatFamilyCell = @"FCBFamilyCell";
static NSString *FCBFormatFamilyStandard = @"FCBFamilyStandard";

@interface DataService()

@property (retain, nonatomic) AFHTTPRequestOperationManager *httpManager;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataService


#pragma mark FastImageCache delegate methods
- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[entity sourceImageURLWithFormatName:formatName]]];
        completionBlock(sourceImage);
    });
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

- (void)imageCache:(FICImageCache *)imageCache cancelImageLoadingForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName {
    NSLog(@"Something is breaking");
}

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

+ (NSString *)newRecipiesEndpointSince:(NSDate *)date {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/recipies.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)allLocationsEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/location.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)newLocationsEndPointSince:(NSDate *)date {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/location.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)featuredEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/featured.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)popularEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/popular.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)purchasedEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/purchased.json", [DataService protocol], [DataService domain]];
}

+ (NSString *)informationEndPoint {
    return [NSString stringWithFormat:@"%@://%@/u/95002502/foundation/information.json", [DataService protocol], [DataService domain]];
}

@synthesize httpManager = _httpManager;
@synthesize managedObjectContext = _managedObjectContext;

+ (NSString*)urlForResources {
    return [NSString stringWithFormat:@"%@://%@/u/19713116/FACApp/Images/",[DataService protocol], [DataService domain]];
}

+ (NSString*)imageFormat:(BOOL)isCell {
    float scale = [[UIScreen mainScreen] scale];
    NSString *scaleString = @"";
    if (scale == 1.0f) {
        scaleString = @"Small";
    } else if (scale == 2.0f) {
        scaleString = @"Medium";
    } else if (scale == 3.0f) {
        scaleString = @"Large";
    }
    return [NSString stringWithFormat:@"FCB%@%@",isCell ? @"Cell" : @"Standard" ,scaleString];
}

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
        
        [self setupImageCache];
    }
    return self;
}

#pragma mark - Setup Image Cache
- (void)setupImageCache {
    FICImageFormatDevices device;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        device = FICImageFormatDevicePad;
    } else {
        device = FICImageFormatDevicePhone;
    }
    
    NSMutableArray *mutableImageFormats = [NSMutableArray array];
    FICImageFormat *imageCellSmall = [FICImageFormat formatWithName:FCBFormaCellSmall family:FCBFormatFamilyCell imageSize:[Utils getSmallCellSize] style:FICImageFormatStyle32BitBGR maximumCount:250 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageCellSmall];
    
    FICImageFormat *imageCellMedium = [FICImageFormat formatWithName:FCBFormatCellMedium family:FCBFormatFamilyCell imageSize:[Utils getSmallCellSize] style:FICImageFormatStyle32BitBGR maximumCount:250 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageCellMedium];
    
    FICImageFormat *imageCellLarge = [FICImageFormat formatWithName:FCBFormatCellLarge family:FCBFormatFamilyCell imageSize:[Utils getSmallCellSize] style:FICImageFormatStyle32BitBGR maximumCount:250 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageCellLarge];

    FICImageFormat *imageStandardSmall = [FICImageFormat formatWithName:FCBFormatStandardSmall family:FCBFormatFamilyStandard imageSize:[Utils getSmallStandardSize] style:FICImageFormatStyle32BitBGR maximumCount:50 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageStandardSmall];
    
    FICImageFormat *imageStandardMedium = [FICImageFormat formatWithName:FCBFormatStandardMedium family:FCBFormatFamilyStandard imageSize:[Utils getSmallStandardSize] style:FICImageFormatStyle32BitBGR maximumCount:250 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageStandardMedium];
    
    FICImageFormat *imageStandardLarge = [FICImageFormat formatWithName:FCBFormatStandardLarge family:FCBFormatFamilyStandard imageSize:[Utils getSmallStandardSize] style:FICImageFormatStyle32BitBGR maximumCount:250 devices:device protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:imageStandardLarge];
    
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    sharedImageCache.delegate = self;
    sharedImageCache.formats = (NSArray*)mutableImageFormats;
}

#pragma mark - Data Integrity Helpers

- (void)setLastUpdated:(NSDate *)date {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:@"currentDate"];
}

- (NSDate *)lastUpdated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"currentDate"];
}

- (void)setFirstLaunch:(BOOL)isFirstLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(isFirstLaunch) forKey:@"firstLaunch"];
}

- (BOOL)firstLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *firstLaunch = [defaults objectForKey:@"firstLaunch"];

    return firstLaunch && [firstLaunch boolValue];
}

- (void)updateUserDefaults {
    [self setFirstLaunch:NO];
    [self setLastUpdated:[NSDate date]];
}

#pragma mark - External Source Fetch Methods

- (void)fetchData {
    static BOOL fetchingData = NO;

    // Do not allow concurrent fetches.
    if(fetchingData) {
        return;
    }

    fetchingData = YES;

    // Suspend the operation queue so that we can queue up all data requests before any are executed.
    // We want to do this because to avoid a race-condition where we are checking the lastUpdated and firstLaunch
    // user default properties.
    //
    // Once all requests are queued, we allow all requests to be made, and on completion of all requests we will
    // update the last response.
    [[[self httpManager] operationQueue] setSuspended:YES];
    [[[self httpManager] operationQueue] setMaxConcurrentOperationCount:1];

    [self fetchRecipeData];
    [self fetchLocationData];
    [self fetchFeaturedData];
    [self fetchPopularData];
    [self fetchPurchasedData];
    // Uncomment when Information.json is uploaded.
   // [self fetchInformationData];

    __weak DataService *wSelf = self;

    // Final `drain` operation.
    [[[self httpManager] operationQueue] addOperationWithBlock:^{
        DataService *sSelf = wSelf;

        // Final commit to coredata.
        NSError *error = nil;
        [sSelf.managedObjectContext save:&error];

        // Update the userdefaults.
        [sSelf updateUserDefaults];

        fetchingData = NO;
    }];

    [[[self httpManager] operationQueue] setSuspended:NO];
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

    if([self firstLaunch]) {
        [[self httpManager] GET:[DataService allRecipiesEndpoint] parameters:nil success:success failure:failure];

    } else {
        [[self httpManager] GET:[DataService newRecipiesEndpointSince:[self lastUpdated]] parameters:nil success:success failure:failure];
    }
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
        [self processLocationsData:responseDict];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    };

    if([self firstLaunch]) {
        [[self httpManager] GET:[DataService allLocationsEndPoint] parameters:nil success:success failure:failure];

    } else {
        [[self httpManager] GET:[DataService newLocationsEndPointSince:[self lastUpdated]] parameters:nil success:success failure:failure];
    }
}


- (void)fetchFeaturedData {
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSArray* responseData = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }

        [self processFeaturedData:responseData];

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
        NSArray* responseData = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }
        [self processPopularData:responseData];

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

- (void)fetchInformationData {
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

    [[self httpManager] GET:[DataService informationEndPoint] parameters:nil success:success failure:failure];
}


#pragma mark - CoreData Process Methods

- (void)loadInformation:(NSDictionary*)information {
    // TODO: Check if information exists
    Information *informationDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    informationDataObject.version = (NSString*)[information objectForKey:@"version"];
    informationDataObject.season = (NSNumber*)[information objectForKey:@"season"];
    NSError *error = nil;
    if (error) {
        NSLog(@"Error loading information: %@",error);
    }
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
    if (error) {
        NSLog(@"Error loading popular: %@",error);
    }
}

- (void)processLocationsData:(NSDictionary*)jsonData {
    NSArray *locations = [jsonData objectForKey:@"locations"];
    // Temporary quick fix:
    if([locations count] != [[self loadLocationFromCoreData] count]){
        for (NSDictionary *location in locations) {
            [self processLocationData:location];
        }
    }
}

- (void)processLocationData:(NSDictionary*)location {
    NSEntityDescription *lookupLocation = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locationId == %@", location[@"id"]];
    fetchRequest.entity = lookupLocation;
    NSArray *fetchedObject = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];

    BOOL new = [fetchedObject count] == 0;

    Location *locationDataObject;

    if(new) {
        locationDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];;
    } else {
        locationDataObject = fetchedObject[0];
    }

    locationDataObject.email = (NSString*)[location objectForKey:@"email"];
    locationDataObject.address = (NSString*)[location objectForKey:@"address"];
    locationDataObject.latitude = (NSNumber*)[location objectForKey:@"latitude"];
    locationDataObject.longitude = (NSNumber*)[location objectForKey:@"longitude"];
    locationDataObject.phone = (NSString*)[location objectForKey:@"phone"];
    locationDataObject.story = (NSString*)[location objectForKey:@"story"];
    locationDataObject.type = (NSString*)[location objectForKey:@"type"];
    locationDataObject.locationId = (NSNumber *)[location objectForKey:@"id"];
    locationDataObject.name = (NSString*)[location objectForKey:@"title"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM:dd:YYYY";
    locationDataObject.dateUpdated = [formatter dateFromString:(NSString*)[location objectForKey:@"updatedDate"]];

    NSError *error = nil;
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

    // [self processFeaturedData];
}

- (void)processRecipeData:(NSDictionary*)recipe {
    NSEntityDescription *lookupRecipe = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recipeId == %@", recipe[@"id"]];
    fetchRequest.entity = lookupRecipe;
    NSArray *fetchedObject = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];

    BOOL new = [fetchedObject count] == 0;

    Recipe *recipeDataObject;

    if(new) {
        recipeDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    } else {
        recipeDataObject = fetchedObject[0];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM:dd:YYYY"];
    recipeDataObject.addDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"addedDate"]];
    recipeDataObject.updateDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"updatedDate"]];
    recipeDataObject.title = (NSString*)[recipe objectForKey:@"title"];
    recipeDataObject.season = (NSString*)[recipe objectForKey:@"season"];
    recipeDataObject.recipeId = (NSNumber*)[recipe objectForKey:@"id"];
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

- (void)processPopularData:(NSArray *)popularData {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *popularEntity = [NSEntityDescription entityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:popularEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Add a predicate later.
    Popular *popular;
    if([results count]){
        popular = (Popular*)[results lastObject];
    }
    else{
        popular = (Popular*)[NSEntityDescription insertNewObjectForEntityForName:@"Popular" inManagedObjectContext:_managedObjectContext];
    }

    NSMutableOrderedSet *popularSet = [NSMutableOrderedSet new];
    for(NSNumber *number in popularData){
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

- (void)processFeaturedData:(NSArray *)featuredData {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *featuredEntity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:featuredEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Delete all the featured objects
    for (Featured *featured in results) {
        [_managedObjectContext deleteObject:featured];
    }
    
    int counter = 0;
    for(NSNumber *number in featuredData){
        Featured *featured = (Featured*)[NSEntityDescription insertNewObjectForEntityForName:@"Featured" inManagedObjectContext:_managedObjectContext];
        featured.featuredId = number;
        featured.order = [NSNumber numberWithInt:counter];
        Recipe *recipe = (Recipe*)[self loadRecipeFromCoreData:number];
        featured.recipe = recipe;
        counter++;
    }

    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }
}

- (void)processPurchasedData:(NSArray *)purchasedData {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *featuredEntity = [NSEntityDescription entityForName:@"Purchased" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:featuredEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Add a predicate later.
    Purchased *purchased;
    NSMutableOrderedSet *purchasedSet;
    if([results count]){
        purchased = [results lastObject];
        purchasedSet = (NSMutableOrderedSet*)[purchased recipes];
    }
    else{
        purchased = [NSEntityDescription insertNewObjectForEntityForName:@"Purchased" inManagedObjectContext:_managedObjectContext];
        purchasedSet = [NSMutableOrderedSet new];
    }

    for(NSNumber *number in purchasedData){
        Recipe *recipe = [self loadRecipeFromCoreData:number];
        recipe.purchased = purchased;
        [purchasedSet addObject:recipe];
    }

    [purchased setRecipes:purchasedSet];
    [purchased setPurchasedId:[NSNumber numberWithInt:kPurchasedId]];

    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }
}

- (void)processInformation:(NSDictionary*)informationData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *featuredEntity = [NSEntityDescription entityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:featuredEntity];
    NSError *err = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    // Add a predicate later.
    Information *info;
    if([results count]){
        info = [results lastObject];
    }
    else{
        info = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    }

    [info setVersion:[informationData valueForKey:@"version"]];
    [info setSeason:[informationData valueForKey:@"season"]];

    NSError *error = nil;
    [_managedObjectContext save:&error];
    if(error){
        NSLog(@"error description :%@",[error description]);
    }

}

#pragma mark - CoreData Load Methods

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
        return (Recipe*)[results firstObject];
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

- (NSArray*)loadLocationFromCoreData {
    // Fetch Request
    NSFetchRequest *locationFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    [locationFetchRequest setEntity:locationEntity];

    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:locationFetchRequest error:&error];
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

- (NSArray*)loadLocationsFromCoreData {
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
        return results;
    }

    return nil;
}

- (Popular*)loadPopularDataFromCoreData:(NSNumber*)popularId {
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

- (Featured*)loadFeaturedDataFromCoreData:(NSNumber*)featuredId {
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
        return (Featured*)[results lastObject];
    }

    return nil;
}

- (Purchased*)loadPurchasedDataFromCoreData:(NSNumber*)purchasedId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Purchased" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"purchasedId = %@",purchasedId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        return  (Purchased*)[results lastObject];
    }

    return nil;
}

- (Information*)loadInformationDataFromCoreData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error = nil;

    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"error description :%@",[error description]);
    }
    else {
        return  (Information*)[results lastObject];
    }
    return nil;
}
@end
