//
//  Location.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface Location : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *story;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *locationId;
@property (nonatomic, retain) NSDate *dateUpdated;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
