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
@end

@implementation FlightAnimationLayer

- (CGFloat)getAnimationPauseDelay {
    int randomNumber = arc4random_uniform(10);
    return randomNumber;
}

- (CGFloat)getAnimationDuration {
    int randomNumber = arc4random_uniform(5) + 15.0f;
    return randomNumber;
}

- (id)initInFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        _parentFrame = frame;
        UIImage *image = [UIImage imageNamed:@"bee"];
        CGFloat sizeMod = 1.0f;
        CGSize size = (CGSize){image.size.width*sizeMod,image.size.height*sizeMod};
        [self setFrame:(CGRect){-40,50,size}];
        [self setContents:(id)image.CGImage];
        self.opacity = 0.50f;
    }
    return self;
}

- (UIBezierPath*)createBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    int startPoint = arc4random_uniform(_parentFrame.size.height);
    int firstMidPoint = arc4random_uniform(_parentFrame.size.width/2);
    int secondMidPoint = arc4random_uniform(_parentFrame.size.width/2) + _parentFrame.size.width/2;
    int endPoint = arc4random_uniform(_parentFrame.size.height);
    [path moveToPoint:(CGPoint){-40,startPoint}];
    [path addCurveToPoint:(CGPoint){_parentFrame.size.width+40,endPoint}
            controlPoint1:(CGPoint){firstMidPoint,0}
            controlPoint2:(CGPoint){secondMidPoint,_parentFrame.size.height}];
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