//
//  PurchaseViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import "PurchaseViewController.h"
#import "Purchased.h"
#import "Recipe.h"
#import "DataService.h"
#import "SeasonColors.h"
#import "NSString+ConvertToEnum.h"
#import "Categories.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

@synthesize recipe = _recipe;
@synthesize showNavigationBar = _showNavigationBar;
@synthesize recipes = _recipes;
@synthesize name = _name;
@synthesize recipeImage = _recipeImage;
@synthesize starButton = _starButton;
@synthesize infoButton = _infoButton;
@synthesize infoButton2 = _infoButton2;
@synthesize backGroundView = _backGroundView;
@synthesize purchaseButton = _purchaseButton;
@synthesize popularRibbonImage = _popularRibbonImage;
@synthesize purchaseLabel = _purchaseLabel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRecipe];
    
    if (_showNavigationBar) {
        UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        navigationController.navigationBarHidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)touchPurchaseButton:(id)sender {
    
}

- (void)loadImageforRecipe {
    [[self recipeImage] setImage:[UIImage imageNamed:@"iPhoneStandard"]];
    [[FICImageCache sharedImageCache] retrieveImageForEntity:_recipe withFormatName:[DataService imageFormat:NO] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        @autoreleasepool {
            if (image) {
                [_recipeImage setImage:image];
            } else {
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    _recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
                } else {
                    _recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
                }
            }
        }
    }];
}

- (void)loadRecipe {
    _name.text = _recipe.title;
    _starButton.selected = [_recipe.isFavourite boolValue];
    
    [[self name] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];
    [[self purchaseLabel] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];
    
    [self loadImageforRecipe];

    [[self purchaseButton] setBackgroundColor:[SeasonColors neturalColorBackground]];
    [[self purchaseButton] setTitleColor:[SeasonColors neturalColorText] forState:UIControlStateNormal];
    
    [[self infoButton] setHidden:YES];
    [[self infoButton2] setHidden:YES];
    if ([_recipe popular] != nil) {
        self.popularRibbonImage.hidden = NO;
    } else {
        self.popularRibbonImage.hidden = YES;
    }
    
    if ([_recipe.categories count] > 1) {
        for (Categories *category in _recipe.categories) {
            if ([category.category isEqualToString:@"vegan"]) {
                [[self infoButton2] setHidden:NO];
                [[self infoButton2] setImage:[UIImage imageNamed:@"vegan_icon"] forState:UIControlStateNormal];
                [[self infoButton2] setTag:0];
            }
            if ([category.category isEqualToString:@"vegetarian"]) {
                [[self infoButton2] setHidden:NO];
                [[self infoButton2] setImage:[UIImage imageNamed:@"vegetarian_icon"] forState:UIControlStateNormal];
                [[self infoButton2] setTag:1];
            }
            if ([category.category isEqualToString:@"gluten free"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"gluten_free_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:2];
            }
        }
    } else {
        for (Categories *category in _recipe.categories) {
            if ([category.category isEqualToString:@"vegan"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"vegan_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:0];
            }
            if ([category.category isEqualToString:@"vegetarian"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"vegetarian_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:1];
            }
            if ([category.category isEqualToString:@"gluten free"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"gluten_free_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:2];
            }
        }
    }
    
    [[self backGroundView] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
}

@end
