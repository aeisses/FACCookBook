//
//  UITableViewCell+IngredientsTableCell.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-08-24.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientsTableCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UILabel *ingredient;

@end
