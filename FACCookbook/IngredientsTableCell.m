//
//  UITableViewCell+IngredientsTableCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-08-24.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "IngredientsTableCell.h"

@implementation IngredientsTableCell

@synthesize amount;
@synthesize ingredient;

- (NSString *) reuseIdentifier {
    return @"IngredientCell";
}

@end
