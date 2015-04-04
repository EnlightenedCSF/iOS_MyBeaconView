//
//  BPoint.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "RoomBeacon.h"

@implementation RoomBeacon

-(id)initWithCoordinateX:(double)x Y:(double)y major:(int)major minor:(int)minor {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _major = [NSNumber numberWithInt:major];
        _minor = [NSNumber numberWithInt:minor];
        _proximity = CLProximityUnknown;
        _accuracy = 0;
    }
    return self;
}

@end
