//
//  LineAnimationLayer.m
//  FACCookbook
//
//  Created by Aaron Eisses on 6/9/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "LineAnimationLayer.h"

static NSString *const kLineraAnimationKey = @"xPosition";

@implementation LineAnimationLayer

@synthesize xPosition = _xPosition;

+ (NSString*)kLineraAnimationKey {
    return kLineraAnimationKey;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:kLineraAnimationKey]) {
        return YES;
    }
    return NO;
}

- (void)display {
    NSNumber *xPosition = [[self presentationLayer] valueForKey:kLineraAnimationKey];
    CGFloat interpolatedXPosition = [xPosition floatValue];

    [self setPosition:(CGPoint){interpolatedXPosition,self.position.y}];
}

- (void)addAnimations:(CGRect)bounds {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"xPosition"];
    animation.fromValue = [NSNumber numberWithInteger:0];
    CGFloat endValue = bounds.size.width + 36.0f;
    animation.toValue = [NSNumber numberWithInteger:endValue];
    animation.duration = 2.5f;
    animation.repeatCount = 1;
    animation.autoreverses = NO;

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    animation2.fromValue = [NSNumber numberWithInteger:0];
    animation2.toValue = [NSNumber numberWithInteger:100];
    animation2.duration = 2.5f;
    animation.repeatCount = 1;
    animation.autoreverses = NO;

    [self addAnimation:animation forKey:@"xPosition"];
    [self addAnimation:animation2 forKey:@"zPosition"];
}

@end
