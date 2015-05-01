//
//  DataService.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "DataService.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "Direction.h"
#import "Ingredient.h"
#import "Recipe.h"
#import "Location.h"
#import "Note.h"
#import "Popular.h"
#import "Information.h"

static NSString *kURL = @"https://dl.dropboxusercontent.com/u/19713116/recipes.json";

@interface DataService()

@property (retain, nonatomic) AFHTTPRequestOperationManager *httpManager;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURLRequest*)getRequestUrl;
- (void)processRecipesData:(NSDictionary*)jsonData;
- (void)processRecipeData:(NSDictionary*)recipe;

@end

@implementation DataService

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

- (NSURLRequest*)getRequestUrl {
    NSURL *url = [[NSURL alloc] initWithString:kURL];
    return [[NSURLRequest alloc] initWithURL:url];
}

- (Recipe*)loadRecipeFromCoreData:(NSNumber*)recipeId {
    // Fetch Request
    return nil;
}

- (void)loadInformation:(NSDictionary*)information {
    // TODO: Check if information exists
    Information *informationDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:_managedObjectContext];
    informationDataObject.version = (NSString*)[information objectForKey:@"version"];
    informationDataObject.season = (NSNumber*)[information objectForKey:@"season"];
    Recipe *recipe = [self loadRecipeFromCoreData:[information objectForKey:@"featured"]];
    recipe.featured = (NSManagedObject*)information;
    informationDataObject.featured = recipe;
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
    locationDataObject.type = (NSNumber*)[location objectForKey:@"type"];
    NSError *error = nil;
    [_managedObjectContext save:&error];
    // TODO: Handle error
}

- (void)processRecipeData:(NSDictionary*)recipe {
    // TODO: Check if recipe exists
    Recipe *recipeDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM:dd:YYYY"];
    recipeDataObject.addDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"addedDate"]];
    recipeDataObject.updateDate = (NSDate*)[formatter dateFromString:(NSString*)[recipe objectForKey:@"updatedDate"]];
    recipeDataObject.title = (NSString*)[recipe objectForKey:@"title"];
    recipeDataObject.searchItems = (NSString*)[recipe objectForKey:@"searchItems"];
    recipeDataObject.season = (NSNumber*)[recipe objectForKey:@"season"];
    recipeDataObject.recipeId = (NSNumber*)[recipe objectForKey:@"recipeId"];
    recipeDataObject.type = (NSNumber*)[recipe objectForKey:@"type"];
    recipeDataObject.isFavourite = 0;

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
    // TODO: Handle error
}

- (void)processRecipesData:(NSDictionary*)jsonData {
    NSArray *recipes = [jsonData objectForKey:@"recipes"];
    for (NSDictionary *recipe in recipes) {
        [self processRecipeData:recipe];
    }
}

- (void)loadRecipeData {
    AFHTTPRequestOperation *operation = [_httpManager HTTPRequestOperationWithRequest:[self getRequestUrl] success:^(AFHTTPRequestOperation *op, id res) {
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&errorJson];
        if (errorJson) {
            NSLog(@"Error parsing JSON: %@",errorJson);
            return;
        }
        [self processRecipesData:responseDict];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        if (error) {
            NSLog(@"Error making httpRequest: %@",error);
        }
    }];
    [operation start];
}

@end