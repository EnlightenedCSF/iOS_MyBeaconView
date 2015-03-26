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

@property (strong, nonatomic) IBOutlet UITableView *beaconTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *console;

@property NSMutableDictionary *beacons;
@property NSMutableArray *arrayBeacons;
@property CLBeaconRegion *region;
@property CLLocationManager *manager;

@end

@implementation BeaconRangingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    self.beacons = [[NSMutableDictionary alloc] init];
    self.arrayBeacons = [[NSMutableArray alloc] init];
    
    NSUUID *uuid = [BeaconDefaults sharedData].uuid;
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.manager startMonitoringForRegion:self.region];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.manager stopMonitoringForRegion:self.region];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayBeacons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 
    //tableCell.textLabel.text = [[self.beacons allKeys] objectAtIndex:indexPath.row];
    //tableCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.beacons allValues] objectAtIndex:indexPath.row]];
    
    
    CLBeacon *beacon = [self.arrayBeacons objectAtIndex:indexPath.row];
    tableCell.textLabel.text = [NSString stringWithFormat:@"Major: %@    Minor: %@", beacon.major, beacon.minor];
    
    self.console.title = [NSString stringWithFormat:@"%d", [self.arrayBeacons count]];
    
    return tableCell;
}

#pragma mark - Location manager delegate

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    [self.beacons removeAllObjects];
    [self.arrayBeacons removeAllObjects];
    
    [self.arrayBeacons addObjectsFromArray:beacons];
    
    /*for (NSNumber *proximity in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)]) {
        NSArray* array = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [proximity intValue]]];
        if ([array count]) {
            self.beacons[proximity] = array;
        }
    }*/
    
    
    [self.beaconTable reloadData];
}

@end
