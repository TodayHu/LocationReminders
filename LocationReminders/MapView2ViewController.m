//
//  MapView2ViewController.m
//  LocationReminders
//
//  Created by Annemarie Ketola on 2/2/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

#import "MapView2ViewController.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "AddReminderViewCOntroller.h"

@interface MapView2ViewController () < CLLocationManagerDelegate, MKMapViewDelegate>

// Define the variables/properties/outlets
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *selectedAnnotation;
@property(strong, nonatomic) MKUserLocation *userLocation;
@property(assign) BOOL *userInitialLocationFound;
@property (strong, nonatomic) NSMutableDictionary *userInfo;


@end

@implementation MapView2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.userInitialLocationFound = NO;                            // <- sets the bool that will control the zoom on the user's current location
  BOOL userInitialLocationFound = self.userInitialLocationFound;
  
  // sets up itself as the observer/recipiant of the notifications associated with the reminder the user adds
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderAdded:) name:@"ReminderAdded" object:nil];
  
  // initiate the location manger
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;                           // <- makes location manager as its own delegate
  self.myMapView.delegate = self;                                 // <-sets the myMapView as its own delegate
 // [self.myMapView setShowsUserLocation:YES];
  
  // checks to make sure location services are enabled
  if ([CLLocationManager locationServicesEnabled]) {
    NSLog(@"current status is %d", [CLLocationManager authorizationStatus]);
    if ([CLLocationManager authorizationStatus] == 0) {           // <- no authorization yet, request authorization
      [self.locationManager requestAlwaysAuthorization];
    } else {
      self.myMapView.showsUserLocation = true;                    // <- if it is given, then start monitering if the user moves
      [self.locationManager startMonitoringSignificantLocationChanges];
    }
  } else {
    //warn the user that location services are not currently enabled
  }
  
  // setup/initiate a long Press Gesture onto the map, we will use this later to drop a pin
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressed:)];
  [self.myMapView addGestureRecognizer:longPress];
}

// This function lets the map zoom in, after it finds the user's initial location, but limits it to the first time it finds it (otherwise it would keep trying to zoom in to the user's current location
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if (self.userInitialLocationFound == NO) {                      // This bool is set NO in the viewdidLoad as the first time
  [self.myMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated: YES];
    self.userInitialLocationFound = YES;  // after it does the initial zoom, it changes the bool to YES, so it won't keep zooming
    BOOL userInitialLocationFound = self.userInitialLocationFound;
    }
  }

// function that makes a dictionary that holds user's reminder's they put in locations
-(void) reminderAdded:(NSNotification *)notification {           // <- variable is called "notification"
  NSLog(@"reminder notification");
  // The properties of the function
  NSDictionary *userInfo = notification.userInfo;                // <- makes a Dictionary called userInfo to define the overlay
  NSLog(@"userInfo notification.userInfo is: %@", notification.userInfo);
  CLCircularRegion *region = userInfo[@"reminder"];              // <- defines the region
  NSLog(@"CLCircularRegion region is: %@", userInfo);
  MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];  // <- defines the circle overlay
  [self.myMapView addOverlay:circleOverlay];                     // <- adds the overlay to the map
}


// setup/initiate the Overlay ability
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  circleRenderer.fillColor = [UIColor blueColor];                // <- sets the color
  circleRenderer.strokeColor = [UIColor redColor];               // <- not sure what stoke color is
  circleRenderer.alpha = 0.5;                                    // <- makes it be see-through (opacity)
  return circleRenderer;
}


// function that defines what happens when you do the long Press Gesture
-(void)mapLongPressed:(id)sender {
  UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
  NSLog(@"long press fired");

  if (longPress.state ==3) {                                      // <- once the long press is finished (state 3)
    NSLog(@"long press ended");
    CGPoint location = [longPress locationInView:self.myMapView]; // <- hooks it up to the press location
    NSLog(@"location y: %f location: %f", location.y, location.x);
    CLLocationCoordinate2D coordinates = [self.myMapView convertPoint:location toCoordinateFromView:self.myMapView];  // <-converts the location press to coordinates
    NSLog(@"coordinate long: %f coordinate lat x: %f", coordinates.longitude, coordinates.latitude);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];  // <- setup/initiate the pin
    annotation.coordinate = coordinates;                          // hooks it up to the coordinates defines by the press gesture above
    annotation.title = @"New Location";                           // gives the location a title
    [self.myMapView addAnnotation:annotation];                    // <- adds the pin to the map
  }
}

// function that tells us that we got authorization for the location (variable = manager?)
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSLog(@" the new status is %d", status);
}

// function that logs changes in user location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.firstObject;                   // <- gets the first element in the location array
  NSLog(@"latitude: %f and longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}


// setsup/initiates the pin/annotation
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKPinAnnotationView *annotativeView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotativeView"];
  annotativeView.animatesDrop =true;                              // <- gives it the drop animation
  annotativeView.pinColor = MKPinAnnotationColorPurple;           // <- defines it color
  annotativeView.canShowCallout = true;                           // <- adds a callout bubble that is shown when the user taps a selected annotation view
  annotativeView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd]; // <- makes the pin + a button
  
  return annotativeView;
}

// function what happens when you click on the pin, it segues onto the next screen
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  // MKPointAnnotation *annotation; // <- why?
  self.selectedAnnotation = view.annotation;
  [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:self];
  NSLog(@"button tapped");
}


// function that tells what happens when you get the notification that you entered the region
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"did enter  region");
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];  // <- setup/initiate the local notifications
  localNotification.alertBody = @"region body!";
  localNotification.alertAction = @"region action";
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];  // <- no idea what this does
}

// function that checks to make sure the segue is going to the correct location that the identifier matches
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SHOW_DETAIL"]) {           // <- identifier match check
    AddReminderViewController *addReminderVC = (AddReminderViewController *)segue.destinationViewController;
    addReminderVC.annotation = self.selectedAnnotation;
    addReminderVC.locationManger = self.locationManager;
  }
}

- (IBAction)schoolButtonPressed:(id)sender {
  CLLocationCoordinate2D schoolLocation = CLLocationCoordinate2DMake(47.623558, -122.335942);
  MKCoordinateRegion schoolZoomRegion = MKCoordinateRegionMakeWithDistance(schoolLocation, 1500, 1500);
  [self.myMapView setRegion:schoolZoomRegion animated:YES];
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];  // <- setup/initiate the pin
  annotation.coordinate = schoolLocation;                            // hooks it up to the coordinates defines by the press gesture above
  annotation.title = @"Code Fellows";                                // gives the location a title
  [self.myMapView addAnnotation:annotation];                         // <- adds the pin to the map
}

- (IBAction)homeButtonPressed:(id)sender {
  CLLocationCoordinate2D homeLocation = CLLocationCoordinate2DMake(47.617830, -122.352231);
  MKCoordinateRegion homeZoomRegion = MKCoordinateRegionMakeWithDistance(homeLocation, 1500, 1500);
  [self.myMapView setRegion:homeZoomRegion animated:YES];
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];  // <- setup/initiate the pin
  annotation.coordinate = homeLocation;                              // hooks it up to the coordinates defines by the press gesture above
  annotation.title = @"The Gallery Condos";                          // gives the location a title
  [self.myMapView addAnnotation:annotation];                         // <- adds the pin to the map
}

- (IBAction)barButtonPressed:(id)sender {
  CLLocationCoordinate2D barLocation = CLLocationCoordinate2DMake(47.601106, -122.334052);
  MKCoordinateRegion barZoomRegion = MKCoordinateRegionMakeWithDistance(barLocation, 1500, 1500);
  [self.myMapView setRegion:barZoomRegion animated:YES];
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];  // <- setup/initiate the pin
  annotation.coordinate = barLocation;                               // hooks it up to the coordinates defines by the press gesture above
  annotation.title = @"Damn the Weather Bar";                        // gives the location a title
  [self.myMapView addAnnotation:annotation];                         // <- adds the pin to the map
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
