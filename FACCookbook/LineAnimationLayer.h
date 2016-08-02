//
//  LineAnimationLayer.h
//  FACCookbook
//
//  Created by Aaron Eisses on 6/9/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineAnimationLayer : CALayer

@property (nonatomic, assign) CGFloat xPosition;

+ (NSString*)kLineraAnimationKey;
- (void)addAnimations:(CGRect)bounds;

@end
