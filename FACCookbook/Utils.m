//
//  Utils.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-07-26.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (CGSize)getSmallCellSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){192, 128};
    } else {
        size = (CGSize){150, 100};
    }
    return size;
}

+ (CGSize)getMediumCellSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){384, 256};
    } else {
        size = (CGSize){300, 200};
    }
    return size;
}

+ (CGSize)getLargeCellSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){576, 384};
    } else {
        size = (CGSize){450, 300};
    }
    return size;
}

+ (CGSize)getSmallStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){480, 320};
    } else {
        size = (CGSize){300, 200};
    }
    return size;
}

+ (CGSize)getMediumStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){960, 640};
    } else {
        size = (CGSize){600, 400};
    }
    return size;
}

+ (CGSize)getLargeStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){1440, 960};
    } else {
        size = (CGSize){900, 600};
    }
    return size;
}

@end