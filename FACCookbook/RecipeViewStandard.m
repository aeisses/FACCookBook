//
//  RecipeViewStandard.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-10-03.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "RecipeViewStandard.h"

@implementation RecipeViewStandard

- (void)prepareForReuse {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
    } else {
        self.recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
    }
}

@end
