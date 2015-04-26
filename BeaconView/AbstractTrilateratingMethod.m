//
//  AbstractTrilateratingMethod.m
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "AbstractTrilateratingMethod.h"
#import "Floor.h"

@implementation AbstractTrilateratingMethod

-(id)initWithFloor:(Floor *)floor {
    self = [super init];
    if (self) {
        _floor = floor;
    }
    return self;
}

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons {
    self.floor.userPosition = CGPointMake(0, 0);
}

@end
