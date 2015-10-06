//
//  PurchasedTableViewCell.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-10-05.
//  Copyright © 2015 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCost;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;
@property (weak, nonatomic) IBOutlet UILabel *season;

@end
