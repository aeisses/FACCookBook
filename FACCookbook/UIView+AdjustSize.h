//
//  UITextField+UITextField_ReAdjustSize.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-08-18.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AdjustSize)

- (void)adjustHeightAndConstraintToTextSize:(NSLayoutConstraint*)constraint withModifier:(NSInteger)modifier;

@end
