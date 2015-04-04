//
//  BeaconRangingViewController.m
//  BeaconView
//
//  Created by Admin on 24.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconRangingViewController.h"
#import "BeaconDefaults.h"
@import CoreLocation;

@interface BeaconRangingViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UILabel *testLbl;

//@property NSMutableDictionary *beacons;
@property CLBeaconRegion *region;
@property CLLocationManager *manager;

@end

@implementation BeaconRangingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    
    NSUUID *uuid = [BeaconDefaults sharedData].uuid;
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
    self.region.notifyEntryStateOnDisplay = YES;
    
    //self.beacons = [NSMutableDictionary new];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.manager startRangingBeaconsInRegion:self.region];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.manager stopRangingBeaconsInRegion:self.region];
}

#pragma mark - Location manager delegate

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    self.testLbl.text = [NSString stringWithFormat:@"%lu", (unsigned long)beacons.count];

    
    
    /*[self.beacons removeAllObjects];
    for (NSNumber *prox in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)]) {
        NSArray *proxBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [prox intValue]]];
        if ([proxBeacons count]) {
            self.beacons[prox] = proxBeacons;
        }
            
    }*/
}

@end
