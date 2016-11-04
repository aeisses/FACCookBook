//
//  RecipeViewCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewCell.h"

@implementation RecipeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:(CGRect){{0,0},[Utils getSmallCellSize]}];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)prepareForReuse {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.recipeImage.image = [UIImage imageNamed:@"iPadCell"];
    } else {
        self.recipeImage.image = [UIImage imageNamed:@"iPhoneCell"];
    }
}

@end
