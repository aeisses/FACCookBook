//
//  UITextField+UITextField_ReAdjustSize.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-08-18.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "UIView+AdjustSize.h"

@implementation UIView (AdjustSize)

- (void)adjustHeightAndConstraintToTextSize:(NSLayoutConstraint*)constraint withModifier:(NSInteger)modifier {
    CGFloat fixedWidth = self.frame.size.width;
    CGSize newSize = [self sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    constraint.constant = newFrame.size.height + modifier;
}

@end
