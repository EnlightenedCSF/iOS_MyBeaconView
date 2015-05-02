//
//  AbstractTrilateratingMethod.m
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "AbstractTrilateratingStrategy.h"
#import "Floor.h"
#import "UserPosition.h"

@implementation AbstractTrilateratingStrategy

-(id)initWithFloor:(Floor *)floor {
    self = [super init];
    if (self) {
        _floor = floor;
    }
    return self;
}

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons {
    self.floor.userPosition = [[UserPosition alloc] initWithPosition:CGPointMake(0, 0)];
}

@end
