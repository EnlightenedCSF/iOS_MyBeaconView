//
//  ViewController.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "ViewController.h"
#import "BeaconView.h"
#import "Beacon.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BeaconView *myBeaconView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableSet *set = [[NSMutableSet alloc]initWithCapacity:3];
    [set addObject:[[Beacon alloc] initWithCoordinateX:10 Y:10 Level:Unknown]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:90 Y:10 Level:Immidiate]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:10 Y:90 Level:Near]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:90 Y:90 Level:Far]];
    
    [self.myBeaconView addBeaconPositions:set];
}

@end
