//
//  LineAnimationLayer.h
//  FACCookbook
//
//  Created by Aaron Eisses on 6/9/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SeasonColors.h"

@interface LineAnimationLayer : CALayer

@property (nonatomic, assign) CGFloat yPosition;

+ (NSString*)kLineraAnimationKey;
- (id)initWithWidth:(CGFloat)width forValue:(int)i ofValue:(int)max season:(Season)season;
- (void)addAnimations:(CGRect)bounds;

@end
