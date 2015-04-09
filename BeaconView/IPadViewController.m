//
//  IPadViewController.m
//  BeaconView
//
//  Created by Admin on 23.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "IPadViewController.h"
#import "BeaconView.h"
#import "BeaconDefaults.h"
@import CoreLocation;

@interface IPadViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet BeaconView *beaconView;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;
@property (weak, nonatomic) IBOutlet UITextField *filterValue;
@property (weak, nonatomic) IBOutlet UIStepper *filterStepper;
@property (weak, nonatomic) IBOutlet UISwitch *userFilterSwitch;

@property CLBeaconRegion *region;
@property CLLocationManager *manager;

@end


@implementation IPadViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.beaconView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                             initWithTarget:self.beaconView action:@selector(pan:)]];
    
    [self.beaconView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                             initWithTarget:self.beaconView action:@selector(pinch:)]];

    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    
    NSUUID *uuid = [BeaconDefaults sharedData].uuid;
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
    self.region.notifyEntryStateOnDisplay = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.manager startRangingBeaconsInRegion:self.region];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.manager stopRangingBeaconsInRegion:self.region];
}

#pragma mark - Filter settings

- (IBAction)toggleFilter:(id)sender {
    if ([self.filterSwitch isOn]) {
        [BeaconDefaults sharedData].isFilteringAccuracy = YES;
        [self.filterValue setEnabled:YES];
        [self.filterStepper setEnabled:YES];
    }
    else {
        [BeaconDefaults sharedData].isFilteringAccuracy = NO;
        [self.filterValue setEnabled:NO];
        [self.filterStepper setEnabled:NO];
    }
}

- (IBAction)changeFilterK:(id)sender {
    double newValue = self.filterStepper.value / 10.0;
    self.filterValue.text = [NSString stringWithFormat:@"%f", newValue];
    [BeaconDefaults sharedData].kalmanKforAccuracy = newValue;
}

- (IBAction)toggleUserFilter:(id)sender {
    [BeaconDefaults sharedData].isFilteringUserPosition = self.userFilterSwitch.isOn;
}

#pragma mark - Location manager delegate

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    [self.beaconView.floor didRangeBeacons:beacons];
    [self.beaconView setNeedsDisplay];
}

@end
