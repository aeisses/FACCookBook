//
//  SeasonColors.m
//  FACCookbook
//
//  Created by Aaron Eisses on 5/21/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "SeasonColors.h"

@implementation SeasonColors

+ (UIColor*)titleColor:(Season)season {
    UIColor *color = nil;
    switch (season) {
        case Spring:
            color = [UIColor colorWithRed:181.f/255.f green:252.f/255.f blue:31.f/255.f alpha:1.0f];
            break;
        case Summer:
            color = [UIColor colorWithRed:242.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Autumn:
            color = [UIColor colorWithRed:109.f/255.f green:113.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Winter:
            color = [UIColor colorWithRed:196.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
    }
    return color;
}

+ (UIColor*)textColor:(Season)season {
    UIColor *color = nil;
    switch (season) {
        case Spring:
            color = [UIColor colorWithRed:244.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Summer:
            color = [UIColor colorWithRed:254.f/255.f green:255.f/255.f blue:86.f/255.f alpha:1.0f];
            break;
        case Autumn:
            color = [UIColor colorWithRed:37.f/255.f green:64.f/255.f blue:92.f/255.f alpha:1.0f];
            break;
        case Winter:
            color = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:211.f/255.f alpha:1.0f];
            break;
    }
    return color;
}

+ (UIColor*)backgroundColor:(Season)season {
    UIColor *color = nil;
    switch (season) {
        case Spring:
            color = [UIColor colorWithRed:7.f/255.f green:252.f/255.f blue:255.f/255.f alpha:1.0f];
            break;
        case Summer:
            color = [UIColor colorWithRed:121.f/255.f green:255.f/255.f blue:105.f/255.f alpha:1.0f];
            break;
        case Autumn:
            color = [UIColor colorWithRed:222.f/255.f green:98.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Winter:
            color = [UIColor colorWithRed:214.f/255.f green:0.f/255.f blue:119.f/255.f alpha:1.0f];
            break;
    }
    return color;
}

@end
