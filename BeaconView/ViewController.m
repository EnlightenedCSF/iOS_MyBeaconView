//
//  ViewController.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "ViewController.h"
#import "BeaconView.h"
#import "BPoint.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BeaconView *myBeaconView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableSet *set = [[NSMutableSet alloc]initWithCapacity:3];
    [set addObject:[[BPoint alloc] initWithCoordinateX:10 Y:10]];
    [set addObject:[[BPoint alloc] initWithCoordinateX:90 Y:10]];
    [set addObject:[[BPoint alloc] initWithCoordinateX:50 Y:80]];
    
    [self.myBeaconView addBeaconPositions:set];
}

@end
