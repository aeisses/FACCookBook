//
//  RecipeViewCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewCell.h"

@implementation RecipeViewCell

- (void)prepareForReuse {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.recipeImage.image = [UIImage imageNamed:@"iPadCell"];
    } else {
        self.recipeImage.image = [UIImage imageNamed:@"iPhoneCell"];
    }
}

@end
