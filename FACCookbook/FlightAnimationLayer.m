//
//  FlightAnimationLayer.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-08-07.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "FlightAnimationLayer.h"

@interface FlightAnimationLayer()
@property (assign) CGRect parentFrame;
@property (assign) BOOL shouldOffset;
@end

@implementation FlightAnimationLayer

- (CGFloat)getAnimationPauseDelay {
    int randomNumber = arc4random_uniform(10);
    return randomNumber;
}

- (CGFloat)getAnimationDuration {
    int randomNumber = arc4random_uniform(10) + 15.0f;
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

- (id)initInFrame:(CGRect)frame offSet:(BOOL)offset opacity:(CGFloat)opacity {
    self = [super init];
    if (self) {
        _shouldOffset = offset;
        _parentFrame = frame;
        UIImage *image = [UIImage imageNamed:@"bee"];
        CGFloat sizeMod = [self getSizeModifier];
        CGSize size = (CGSize){image.size.width*sizeMod,image.size.height*sizeMod};
        [self setFrame:(CGRect){-40,50,size}];
        [self setContents:(id)image.CGImage];
        self.opacity = opacity;
    }
    return self;
}

- (UIBezierPath*)createBezierPath {
    CGFloat offset = 0.0f;
    if(_shouldOffset) {
        offset = _parentFrame.origin.y;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    int startPoint = arc4random_uniform(_parentFrame.size.height);
    int firstMidPoint = arc4random_uniform(_parentFrame.size.width/2);
    int secondMidPoint = arc4random_uniform(_parentFrame.size.width/2) + _parentFrame.size.width/2;
    int endPoint = arc4random_uniform(_parentFrame.size.height);
    [path moveToPoint:(CGPoint){-40,startPoint+offset}];
    [path addCurveToPoint:(CGPoint){_parentFrame.size.width+40,endPoint+offset}
            controlPoint1:(CGPoint){firstMidPoint,offset}
            controlPoint2:(CGPoint){secondMidPoint,_parentFrame.size.height+offset}];
    return path;
}

- (void)addAnimationTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:[self getAnimationPauseDelay] target:self selector:@selector(createAnimation) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
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
    [self addAnimation:anim forKey:@"bee"];
}

@end