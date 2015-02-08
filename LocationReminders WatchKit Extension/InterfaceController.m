//
//  InterfaceController.m
//  LocationReminders WatchKit Extension
//
//  Created by Annemarie Ketola on 2/6/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

#import "InterfaceController.h"
#import "ReminderRowController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapInterfaceController.h"
#import "AddReminderViewController.h"
#import <MapKit/MapKit.h>


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) NSArray *regionsArray;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  
  CLLocationManager *locationManger = [CLLocationManager new];
  NSSet *regions = locationManger.monitoredRegions;  // <- this is supposed to get all the monitered region notifications. . . . . it does not seem to do this :(
  NSLog(@"This is what is in the moniteredRegions: %@", locationManger.monitoredRegions);
  self.regionsArray = regions.allObjects;
  NSLog(@"This is what is inside the regionsArray: %@", self.regionsArray);
  
  // use this to check to see if the table is set up correctly
//  NSArray *names = @[@"Anne", @"Paul", @"Reima", @"Matt", @"Helena"];
//  [self.table setNumberOfRows:names.count withRowType:@"ReminderRowController"];
  
  // sets up the table cells with the reminders
  [self.table setNumberOfRows:regions.count withRowType:@"ReminderRowController"];
  NSLog(@"regions.count: %lu", (unsigned long)regions.count);
  NSInteger index = 0;
  for (CLRegion *region in self.regionsArray) {
    ReminderRowController * rowController = [self.table rowControllerAtIndex:index];
    [rowController.reminderLabel setText:region.identifier];
     NSLog(@" what you get from setText-region: %@", region.identifier);
    index++;
  }

    // Configure interface objects here.
}

// This passes the information about the region over to the next interface controller
-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
  NSLog(@"%ld", (long)rowIndex);
  return self.regionsArray[rowIndex];
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



