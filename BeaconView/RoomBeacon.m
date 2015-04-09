//
//  BPoint.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "RoomBeacon.h"

@implementation RoomBeacon

-(id)initWithPosition:(NSArray *)pos height:(double)h major:(int)major minor:(int)minor {
    self = [super init];
    if (self) {
        _pos = pos;
        _h = h;
        _major = [NSNumber numberWithInt:major];
        _minor = [NSNumber numberWithInt:minor];
        _proximity = CLProximityUnknown;
        _accuracy = 0;
        _lastMeasurment = 0;
        _rssi = 0;
        _distance = 0;
        _isTakenForCalculation = NO;
    }
    return self;
}

@end
