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
        size = (CGSize){150, 100};
    } else {
        size = (CGSize){192, 128};
    }
    return size;
}

+ (CGSize)getMediumCellSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){300, 200};
    } else {
        size = (CGSize){384, 256};
    }
    return size;
}

+ (CGSize)getLargeCellSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){450, 300};
    } else {
        size = (CGSize){576, 384};
    }
    return size;
}

+ (CGSize)getSmallStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){300, 200};
    } else {
        size = (CGSize){480, 320};
    }
    return size;
}

+ (CGSize)getMediumStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){600, 400};
    } else {
        size = (CGSize){960, 640};
    }
    return size;
}

+ (CGSize)getLargeStandardSize {
    CGSize size;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        size = (CGSize){900, 600};
    } else {
        size = (CGSize){1440, 960};
    }
    return size;
}

@end