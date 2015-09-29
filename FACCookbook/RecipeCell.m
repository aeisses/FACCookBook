//
//  RecipeCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeCell.h"
#import "FICImageCache.h"
#import "DataService.h"

@implementation RecipeCell

@synthesize recipeImage = _recipeImage;

- (void)prepareForReuse {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (YES) {
            _recipeImage.image = [UIImage imageNamed:@"iPadCell"];
        } else {
//            _recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
        }
    } else {
        if (YES) {
            _recipeImage.image = [UIImage imageNamed:@"iPhoneCell"];
        } else {
//            _recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
        }
    }
}

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
  }
  
  return self;
}

- (void)addRecipeImage:(Recipe*)recipe forCell:(BOOL)forCell {
    [[FICImageCache sharedImageCache] retrieveImageForEntity:recipe withFormatName:[DataService imageFormat:forCell] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        @autoreleasepool {
            if (image) {
                [_recipeImage setImage:image];
            } else {
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
        }
    }];
}

@end
