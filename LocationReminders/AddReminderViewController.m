//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Annemarie Ketola on 2/4/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

#import "AddReminderViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AddReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *regionAddedLabel;
//@property (weak, nonatomic) NSMutableArray *regionsArray;


@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSLog(@"long: %f lat: %f", self.annotation.coordinate.longitude, self.annotation.coordinate.latitude);
//  NSMutableArray* regionsArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

// this is what happens when you push the ok button on the addReminder page
-(IBAction)pressedAddReminderButton:(id)sender {
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {  // <- make sure monitering is available
    CLCircularRegion *regions = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:200 identifier:self.textField.text];                                                 // <- region is 200m from the pin, uses reminder name typed in by the user
    [self.locationManger startMonitoringForRegion:regions];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderAdded" object:self userInfo:@{@"reminder" : regions}]; // <- sends the reminder notification to the observers
   NSLog(@"This is what you get as a Regions: %@", regions);
//    [self.regionsArray addObject:regions];
//    NSLog(@"This is what is in the ragionsArray: %@", _regionsArray);
  }
  NSLog(@"pressedAddReminderButton is PRESSED");
  _regionAddedLabel.text = @"Your region was added!";
  [self.view endEditing:YES];
  
  // I added this up to see what all the messages that were sent/monitered were to see if they were being sent
  CLLocationManager *locationManger = [CLLocationManager new];
  NSSet *newRegions = locationManger.monitoredRegions;
  NSLog(@"newRegions is moniteredRegions: %@", locationManger.monitoredRegions);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
