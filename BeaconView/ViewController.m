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
    
    [self.myBeaconView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.myBeaconView action:@selector(pan:)]];
}


@end
