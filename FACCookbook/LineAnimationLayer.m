//
//  LineAnimationLayer.m
//  FACCookbook
//
//  Created by Aaron Eisses on 6/9/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "LineAnimationLayer.h"

static NSString *const kLineraAnimationKey = @"yPosition";

@interface LineAnimationLayer()
@property (assign) CGRect animationBounds;
@property (assign) CGFloat screenWidth;
@property (assign) CGRect startingFrame;
- (void)addAnimation;
@end

@implementation LineAnimationLayer

@synthesize yPosition = _yPosition;

- (UIImage*)getImageForSeason:(Season)season {
    NSString *seasonName = @"";
    int images = 0;
    switch (season) {
        case Winter:
            seasonName = @"snowflake";
            images = 3;
            break;
        case Autumn:
            seasonName = @"fallleaf";
            images = 10;
            break;
        case Spring:
        case Summer:
            break;
    }
    int randomNumber = arc4random_uniform(images) + 1;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@%i",seasonName,randomNumber]];
}

- (CGFloat)getRandomXValue:(int)i ofValue:(int)max {
    int adjuster = (_screenWidth-80)/max;
    int randomNumber = arc4random_uniform(adjuster) + (_screenWidth-80)/max*i + 10;
    return randomNumber;
}

- (CGFloat)getAnimationDuration {
    int randomNumber = arc4random_uniform(10) + 15.0f;
    return randomNumber;
}

- (CGFloat)getAnimationPauseDelay {
    int randomNumber = arc4random_uniform(30);
    return randomNumber;
}

- (CGFloat)getSizeModifier {
    int randomNumber = arc4random_uniform(3);
    if (randomNumber == 0) {
        return 1.0f;
    } else if (randomNumber == 1) {
        return 0.9f;
    }
    return 0.8f;
}

- (id)initWithWidth:(CGFloat)width forValue:(int)i ofValue:(int)max season:(Season)season {
    self = [super init];
    if (self) {
        _screenWidth = width;
        UIImage *image = [self getImageForSeason:season];
        CGFloat sizeMod = [self getSizeModifier];
        CGSize size = (CGSize){image.size.width*sizeMod,image.size.height*sizeMod};
        _startingFrame = (CGRect){{[self getRandomXValue:i ofValue:max],-(size.height)},size};
        [self setFrame:_startingFrame];
        [self setContents:(id)image.CGImage];
        self.opacity = 0.5f;
    }
    return self;
}

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
    NSNumber *yPosition = [[self presentationLayer] valueForKey:kLineraAnimationKey];
    CGFloat interpolatedYPosition = [yPosition floatValue];
    if (interpolatedYPosition) {
        [self setPosition:(CGPoint){self.position.x, interpolatedYPosition}];
    }
}

- (void)addAnimationTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:[self getAnimationPauseDelay] target:self selector:@selector(addAnimation) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self setFrame:_startingFrame];
    [self removeAllAnimations];
    [self addAnimationTimer];
}

- (void)addAnimations:(CGRect)bounds {
    [self setAnimationBounds:bounds];
    [self addAnimationTimer];
}

- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"yPosition"];
    animation.fromValue = [NSNumber numberWithInteger:_startingFrame.origin.y];
    CGFloat endValue = _animationBounds.size.height + _startingFrame.size.height;
    animation.toValue = [NSNumber numberWithInteger:endValue];
    animation.duration = [self getAnimationDuration];
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;

    CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.fromValue = [NSNumber numberWithFloat:0.0f];
    animation2.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation2.duration = 15.0f;
    animation2.repeatCount = INFINITY;
    [self addAnimation:animation2 forKey:@"SpinAnimation"];
    
    [self addAnimation:animation forKey:@"yPosition"];
}

@end
