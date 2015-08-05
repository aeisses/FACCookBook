//
//  RecipeViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Recipe.h"

@interface RecipeViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) Recipe *recipe;
@property (retain, nonatomic) NSArray *recipes;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *season;
@property (weak, nonatomic) IBOutlet UITextView *instructions;

@end
