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

@interface RecipeViewController : UIViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *recipeScrollView;
@property (retain, nonatomic) Recipe *recipe;
@property (assign, nonatomic) BOOL showNavigationBar;
@property (retain, nonatomic) NSArray *recipes;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *season;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITableView *ingredients;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton2;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *titleContainerView;
@property (strong, nonatomic) IBOutlet UIScrollView *secondScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleContainerVerticalOffset;
@property (strong, nonatomic) IBOutlet UILabel *ingredientsTitle;
@property (strong, nonatomic) IBOutlet UIView *ingredientsContainerView;
@property (strong, nonatomic) IBOutlet UILabel *instructionsTitle;
@property (strong, nonatomic) IBOutlet UIView *instructionsContainerView;
@property (strong, nonatomic) IBOutlet UILabel *notesTitle;
@property (strong, nonatomic) IBOutlet UIView *notesContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *popularRibbonImage;

@end
