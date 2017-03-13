//
//  PurchasedTableViewCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import "PurchasedTableViewCell.h"
#import "FICImageCache.h"
#import "DataService.h"

@implementation PurchasedTableViewCell

- (NSString *) reuseIdentifier {
    return @"PurchasedCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:(CGRect){{0,0},{120,80}}];
    self.recipeImage.layer.masksToBounds = NO;
    self.recipeImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.recipeImage.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.recipeImage.layer.shadowOpacity = 0.5f;
    self.recipeImage.layer.shadowPath = shadowPath.CGPath;
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
