//
//  SeasonColors.h
//  FACCookbook
//
//  Created by Aaron Eisses on 5/21/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Season) {
    Spring = 0,
    Summer,
    Autumn,
    Winter
};

@interface SeasonColors : NSObject

+ (UIColor*)titleColor:(Season)season;
+ (UIColor*)textColor:(Season)season;
+ (UIColor*)backgroundColor:(Season)season;
+ (NSString*)convertToString:(Season)season;
+ (UIColor*)neturalColorBackground;
+ (UIColor*)neturalColorText;

@end
