//
//  FlowerAnimationLayer.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-08-07.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerAnimationLayer : CALayer
- (id)initInFrame:(CGRect)frame opacity:(CGFloat)opactiy;
- (void)addAnimation;
@end
