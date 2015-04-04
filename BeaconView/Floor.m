//
//  Room.m
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "Floor.h"
#import "RoomBeacon.h"

@implementation Floor

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableArray *)beacons UserPosition:(CGPoint)position {
    self = [super init];
     if (self) {
         _rooms = rooms;
         _beacons = beacons;
         _userPosition = position;
         _accuracy = 0;
     }
     return self;
}

-(void)didRangeBeacons:(NSArray *)beacons {
    for (CLBeacon *beacon in beacons) {
        for (RoomBeacon *roomBeacon in self.beacons) {
            if (roomBeacon.major == beacon.major && roomBeacon.minor == beacon.minor) {
                roomBeacon.proximity = beacon.proximity;
                roomBeacon.accuracy = beacon.accuracy;
            }
        }
    }
}

@end
