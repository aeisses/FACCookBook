//
//  RecipeView.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-10-03.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "Utils.h"

@interface RecipeView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

- (void)addRecipeImage:(Recipe*)recipe forCell:(BOOL)forCell;

@end
