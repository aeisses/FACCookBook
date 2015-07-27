//
//  RecipeView.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface RecipeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

- (void)addRecipeImage:(Recipe*)recipe forCell:(BOOL)forCell;

@end
