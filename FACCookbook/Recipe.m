//
//  Recipe.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-06.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "Recipe.h"
#import "DataService.h"
#import "FICUtilities.h"

@implementation Recipe

@dynamic addDate;
@dynamic recipeId;
@dynamic searchItems;
@dynamic categories;
@dynamic title;
@dynamic updateDate;
@dynamic season;
@dynamic type;
@dynamic isFavourite;

@dynamic directions;
@dynamic ingredients;
@dynamic notes;
@dynamic component;
@dynamic information;
@dynamic purchased;
@dynamic popular;

- (NSString *)UUID {
    CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([self.objectID.URIRepresentation absoluteString]);
    NSString *UUID = FICStringWithUUIDBytes(UUIDBytes);
    
    return UUID;
}

- (NSString *)sourceImageUUID {
    CFUUIDBytes sourceImageUUIDBytes = FICUUIDBytesFromMD5HashOfString([self.objectID.URIRepresentation absoluteString]);
    NSString *sourceImageUUID = FICStringWithUUIDBytes(sourceImageUUIDBytes);
    
    return sourceImageUUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    NSString *type = @"";
    NSString *size = @"";
    NSString *device = @"";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        device = @"Tablet";
    } else {
        device = @"Phone";
    }
    
    float scale = [[UIScreen mainScreen] scale];
    if (scale == 1.0f) {
        size = @"Small";
    } else if (scale == 2.0f) {
        size = @"Medium";
    } else if (scale == 3.0f) {
        size = @"Large";
    }
    
    if ([formatName containsString:@"Standard"]) {
        type = @"Standard";
    } else {
        type = @"Cell";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i-%@-%@-%@.png",[DataService urlForResources],size,[self.recipeId intValue],type,device,size];
    return [NSURL URLWithString:urlString];
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef context, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(context, contextBounds);
        UIGraphicsPushContext(context);
        [image drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}

- (UIImage*)imageForSeason {
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    UIImage *image;
    if ([self.season isEqualToString:@"Spring"] || [self.season isEqualToString:@"spring"]) {
        image = [UIImage imageNamed:@"springBackGround"];
    } else if ([self.season isEqualToString:@"Fall"] || [self.season isEqualToString:@"fall"]) {
        image = [UIImage imageNamed:@"fallBackGround"];
    } else if ([self.season isEqualToString:@"Winter"] || [self.season isEqualToString:@"winter"]) {
        image = [UIImage imageNamed:@"winterBackGround"];
    } else {
        image = [UIImage imageNamed:@"summerBackGround"];
    }

    CIImage *inputImage = [CIImage imageWithCGImage:[image CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@4 forKey:kCIInputRadiusKey];

    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);

    return returnImage;
}

@end
