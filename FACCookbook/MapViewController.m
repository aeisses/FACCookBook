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

static CGFloat const kMapCenterX = 45.562151;
static CGFloat const kMapCenterY = -63.092663;
static CGFloat const kMapDeltaSpanX = 6.755762;
static CGFloat const kMapDetlaSpanY = 6.786120;
@interface MapViewController()
@property (retain, nonatomic) Location *currentLocation;
@end

@implementation MapViewController

@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D centre = CLLocationCoordinate2DMake(kMapCenterX, kMapCenterY);
    MKCoordinateSpan span = MKCoordinateSpanMake(kMapDeltaSpanX, kMapDetlaSpanY);
    
    [self.mapView setRegion:MKCoordinateRegionMake(centre, span)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSArray *locations = [[DataService sharedInstance] loadLocationsFromCoreData];
    [self.mapView addAnnotations:locations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSArray *locations = [[DataService sharedInstance] loadLocationsFromCoreData];
    [self.mapView removeAnnotations:locations];
}

#pragma mark MKMapViewDelegate Methods

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    _currentLocation = (Location*)view.annotation;
    [self performSegueWithIdentifier:@"location" sender:self];
}

#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationViewController* vc = (LocationViewController*)segue.destinationViewController;
    vc.location = _currentLocation;
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [MKAnnotationView new];
    UIImage *image = [UIImage imageNamed:@"mapAnnotation"];
    [annotationView setImage:image];
    annotationView.centerOffset = (CGPoint){0,image.size.height/-2};
        
    return annotationView;
}

@end
