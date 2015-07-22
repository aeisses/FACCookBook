//
//  RecipeViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RecipeViewController : UIViewController

@property(nonatomic) NSString *imgPath;
@property(nonatomic) NSString *name;
@property(nonatomic) NSArray *recipeImages;

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@end
