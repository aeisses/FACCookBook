//
//  Location.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "Location.h"
#import "DataService.h"
#import "FICUtilities.h"

@implementation Location

@dynamic name;
@dynamic address;
@dynamic email;
@dynamic latitude;
@dynamic longitude;
@dynamic phone;
@dynamic story;
@dynamic type;
@dynamic locationId;
@dynamic dateUpdated;

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.latitude doubleValue], -1*[self.longitude doubleValue]);
    return coord;
}

- (NSString*)title {
    return self.name;
}

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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i-%@-%@.png",[DataService urlForResources],size,[self.locationId intValue],device,size];
    NSLog(@"URLString: %@",urlString);
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

@end
