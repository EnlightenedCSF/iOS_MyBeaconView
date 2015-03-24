//
//  IPadViewController.m
//  BeaconView
//
//  Created by Admin on 23.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "IPadViewController.h"
#import "BeaconView.h"

@interface IPadViewController ()

@property (weak, nonatomic) IBOutlet BeaconView *beaconView;

@end


@implementation IPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.beaconView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                             initWithTarget:self.beaconView action:@selector(pan:)]];
    
    [self.beaconView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                             initWithTarget:self.beaconView action:@selector(pinch:)]];

}

@end
