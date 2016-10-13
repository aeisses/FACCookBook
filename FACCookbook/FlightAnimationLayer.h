//
//  FlightAnimationLayer.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-08-07.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightAnimationLayer : CALayer <CAAnimationDelegate>
- (id)initInFrame:(CGRect)frame offSet:(BOOL)offset opacity:(CGFloat)opactiy;
- (void)addAnimation;
@end
