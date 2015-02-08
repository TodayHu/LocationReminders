//
//  MapInterfaceController.h
//  LocationReminders
//
//  Created by Annemarie Ketola on 2/7/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "InterfaceController.h"

@interface MapInterfaceController : WKInterfaceController
@property (strong, nonatomic) CLCircularRegion *currentRegion;

@end
