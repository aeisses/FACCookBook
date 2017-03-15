//
//  RecipeView.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-10-03.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "RecipeView.h"
#import "FICImageCache.h"
#import "DataService.h"

@implementation RecipeView

@synthesize recipeImage = _recipeImage;

- (void)addRecipeImage:(Recipe*)recipe forCell:(BOOL)forCell {
    if ([recipe purchased] != nil) {
        if (YES) { // Check if the recipe is purchased
            self.purchaseScreen.hidden = NO;
            self.purchasePrice.hidden = NO;
        }
    }
    if ([recipe popular] != nil) {
        self.popularImage.hidden = NO;
    }
    [[FICImageCache sharedImageCache] retrieveImageForEntity:recipe withFormatName:[DataService imageFormat:forCell] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        @autoreleasepool {
            if (image) {
                [[self recipeImage] setImage:image];
            }
        }
    }];
}

@end
