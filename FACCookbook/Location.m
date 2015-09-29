//
//  Location.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "Location.h"

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

@end
