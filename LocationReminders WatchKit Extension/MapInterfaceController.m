//
//  MapInterfaceController.m
//  LocationReminders
//
//  Created by Annemarie Ketola on 2/7/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

#import "MapInterfaceController.h"
#import "InterfaceController.h"
#import <CoreLocation/CoreLocation.h>


@interface MapInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceMap *miniMap;

@end


@implementation MapInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  self.currentRegion = context;
  // sets up the miniMap with the info from the cell. This part seems to work correctly
   MKCoordinateRegion miniRegion = MKCoordinateRegionMake(self.currentRegion.center, MKCoordinateSpanMake(0.01, 0.01));
   [self.miniMap setRegion:miniRegion];
  
  NSLog(@"the self.currentRegion: %@", self.currentRegion);
  
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



