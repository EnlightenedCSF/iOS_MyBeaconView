//
//  BPoint.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon

-(id)initWithCoordinateX:(double)x Y:(double)y {
    return [self initWithCoordinateX:x Y:y Level:Unknown];
}

-(id)initWithCoordinateX:(double)x Y:(double)y Level:(enum BeaconPower)power {
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.beaconPower = power;
    }
    return self;
}
@end
