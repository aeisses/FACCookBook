//
//  PurchasedViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface PurchaseViewController: UIViewController

@property (retain, nonatomic) Recipe *recipe;
@property (assign, nonatomic) BOOL showNavigationBar;
@property (retain, nonatomic) NSArray *recipes;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton2;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (strong, nonatomic) IBOutlet UIImageView *popularRibbonImage;
@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

- (IBAction)touchPurchaseButton:(id)sender;

@end
