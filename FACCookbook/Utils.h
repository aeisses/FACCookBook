//
//  Utils.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-07-26.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SeasonColors.h"

@interface Utils : NSObject

+ (CGSize)getSmallCellSize;
+ (CGSize)getMediumCellSize;
+ (CGSize)getLargeCellSize;
+ (CGSize)getSmallStandardSize;
+ (CGSize)getMediumStandardSize;
+ (CGSize)getLargeStandardSize;
+ (Season)getCurrentSeason;

@end
