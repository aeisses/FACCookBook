//
//  MapViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "MapViewController.h"
#import "DataService.h"
#import "Location.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSArray *array = [[DataService sharedInstance] loadLocationsFromCoreData];
    Location *location = (Location *)[array firstObject];
    
    [self.mapView addAnnotation:location];
//    NSLog(@"Lat: %@", location.latitude);
//    NSLog(@"Long: %@", location.longitude);
}

@end
