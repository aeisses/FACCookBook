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
#import "LocationViewController.h"

@interface MapViewController()
@property (retain, nonatomic) Location *currentLocation;
@end

@implementation MapViewController

@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    CLLocationCoordinate2D centre = CLLocationCoordinate2DMake(45.562151, -63.092663);
    MKCoordinateSpan span = MKCoordinateSpanMake(6.755762, 6.786120);
    [self.mapView setRegion:MKCoordinateRegionMake(centre, span)];
    
    NSArray *locations = [[DataService sharedInstance] loadLocationsFromCoreData];
    [self.mapView addAnnotations:locations];
}

#pragma mark MKMapViewDelegate Methods
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
//    NSLog(@"MapView: %f, %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    NSLog(@"MapView: %f, %f, %f, %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta,mapView.region.center.latitude,mapView.region.center.longitude);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    _currentLocation = (Location*)view.annotation;
    [self performSegueWithIdentifier:@"location" sender:self];
}


#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationViewController* vc = (LocationViewController*)segue.destinationViewController;
    vc.location = _currentLocation;
}

@end
