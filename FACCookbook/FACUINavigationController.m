//
//  UINavigationController_FACUINavigationController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2016-11-16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "FACUINavigationController.h"

@implementation FACUINavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[self topViewController] respondsToSelector:@selector(supportedInterfaceOrientations)])
        return [[self topViewController] supportedInterfaceOrientations];
    else
        return [super supportedInterfaceOrientations];
}

@end
