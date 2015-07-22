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

@interface RecipeViewController : UIViewController

@property(nonatomic) Recipe *recipe;

@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *season;
@property (weak, nonatomic) IBOutlet UILabel *categories;
@property (weak, nonatomic) IBOutlet UITextView *instructions;

@end
