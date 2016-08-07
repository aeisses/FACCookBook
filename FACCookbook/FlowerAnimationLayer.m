//
//  FlowerAnimationLayer.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-08-07.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "FlowerAnimationLayer.h"

@interface FlowerAnimationLayer()
@property (assign) CGRect parentFrame;
@property (assign) CGPoint startPoisiton;
@property (assign) CGPoint endPosition;
@end

@implementation FlowerAnimationLayer

- (CGFloat)getAnimationPauseDelay {
    int randomNumber = arc4random_uniform(10);
    return randomNumber;
}

- (CGFloat)getAnimationDuration {
    int randomNumber = arc4random_uniform(5) + 5.0f;
    return randomNumber;
}

- (CGFloat)getRandomXValue {
    int adjuster = (_parentFrame.size.width-80);
    int randomNumber = arc4random_uniform(adjuster) + 10;
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

- (id)initInFrame:(CGRect)frame opacity:(CGFloat)opacity {
    self = [super init];
    if (self) {
        _parentFrame = frame;
        UIImage *image = [UIImage imageNamed:@"flower"];
        CGFloat sizeMod = [self getSizeModifier];
        CGSize size = (CGSize){image.size.width*sizeMod,image.size.height*sizeMod};
        [self setFrame:(CGRect){[self getRandomXValue],_parentFrame.size.height+size.height,size}];
        [self setContents:(id)image.CGImage];
        _startPoisiton = self.position;
        _endPosition = (CGPoint){_startPoisiton.x,_startPoisiton.y-size.height*2};
        self.opacity = opacity;
    }
    return self;
}

- (UIBezierPath*)createBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint)[self startPoisiton]];
    [path addLineToPoint:(CGPoint)[self endPosition]];
    return path;
}

- (void)addAnimationTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:[self getAnimationPauseDelay] target:self selector:@selector(createAnimation) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self setPosition:_endPosition];
    [self removeAllAnimations];
    [self addAnimationTimer];
}

- (void)addAnimation {
    [self addAnimationTimer];
}

- (void)createAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.path = [self createBezierPath].CGPath;
    anim.delegate = self;
    anim.repeatCount = 1;
    anim.duration = [self getAnimationDuration];
    [self addAnimation:anim forKey:@"flower"];
}

@end
