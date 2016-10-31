//
//  RecipeViewStandard.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-10-03.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "RecipeViewStandard.h"

@implementation RecipeViewStandard

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:(CGRect){{0,0},[Utils getHomeScreenSize]}
                                ];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)prepareForReuse {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
    } else {
        self.recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
    }
}

@end
