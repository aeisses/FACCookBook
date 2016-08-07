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
            color = [UIColor colorWithRed:0.f/255.f green:120.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Summer:
            color = [UIColor colorWithRed:255.f/255.f green:160.f/255.f blue:70.f/255.f alpha:1.0f];
            break;
        case Autumn:
//            color = [UIColor colorWithRed:109.f/255.f green:113.f/255.f blue:0.f/255.f alpha:1.0f];
            color = [UIColor colorWithRed:197.f/255.f green:55.f/255.f blue:0.f/255.f alpha:1.0f];
            break;
        case Winter:
            color = [UIColor colorWithRed:80.f/255.f green:33.f/255.f blue:163.f/255.f alpha:1.0f];
            break;
    }
    return color;
}

+ (UIColor*)textColor:(Season)season {
    UIColor *color = nil;
//    switch (season) {
//        case Spring:
//            color = [UIColor colorWithRed:244.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0f];
//            break;
//        case Summer:
//            color = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.0f];
//            break;
//        case Autumn:
//            color = [UIColor colorWithRed:37.f/255.f green:64.f/255.f blue:92.f/255.f alpha:1.0f];
//            break;
//        case Winter:
//            color = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:211.f/255.f alpha:1.0f];
            color = [UIColor colorWithRed:37.f/255.f green:64.f/255.f blue:92.f/255.f alpha:1.0f];
//            break;
//    }
    return color;
}

+ (UIColor*)backgroundColor:(Season)season {
    UIColor *color = nil;
    switch (season) {
        case Spring:
            color = [UIColor colorWithRed:120.f/255.f green:160.f/255.f blue:90.f/255.f alpha:1.0f];
            break;
        case Summer:
            color = [UIColor colorWithRed:252.f/255.f green:252.f/255.f blue:129.f/255.f alpha:1.0f];
            break;
        case Autumn:
            color = [UIColor colorWithRed:222.f/255.f green:140.f/255.f blue:70.f/255.f alpha:1.0f];
            break;
        case Winter:
            color = [UIColor colorWithRed:163/255.f green:195.f/255.f blue:229.f/255.f alpha:1.0f];
            break;
    }
    return color;
}

@end
