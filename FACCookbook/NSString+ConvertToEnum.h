//
//  NSString+ConvertToEnum.h
//  FACCookbook
//
//  Created by Aaron Eisses on 5/21/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeasonColors.h"

@interface NSString (ConvertToEnum)

- (Season)convertToSeasonEnum;

@end
