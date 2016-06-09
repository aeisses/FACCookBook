//
//  NSString+ConvertToEnum.m
//  FACCookbook
//
//  Created by Aaron Eisses on 5/21/16.
//  Copyright © 2016 EAC. All rights reserved.
//

#import "NSString+ConvertToEnum.h"

@implementation NSString (ConvertToEnum)

- (Season)convertToSeasonEnum {
    if ([self isEqualToString:@"Summer"] || [self isEqualToString:@"summer"]) {
        return Summer;
    }
    if ([self isEqualToString:@"Spring"] || [self isEqualToString:@"spring"]) {
        return Spring;
    }
    if ([self isEqualToString:@"Winter"] || [self isEqualToString:@"winter"]) {
        return Winter;
    }
    return Autumn;
}

@end
