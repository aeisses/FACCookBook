//
//  RecipeCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

@synthesize recipeImage = _recipeImage;

- (void)prepareForReuse {
}

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
  }
  
  return self;
}

- (void)addRecipeImage:(Recipe*)recipe forCell:(BOOL)forCell {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (forCell) {
            _recipeImage.image = [UIImage imageNamed:@"iPadCell"];
        } else {
            _recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
        }
    } else {
        if (forCell) {
            _recipeImage.image = [UIImage imageNamed:@"iPhoneCell"];
        } else {
            _recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
        }
    }
}

@end
