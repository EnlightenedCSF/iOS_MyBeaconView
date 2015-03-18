//
//  Room.m
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "Room.h"
#import "Beacon.h"

@implementation Room

-(id)initWithX:(double)x Y:(double)y Width:(double)width Height:(double)height {
    self = [super init];
    if (self) {
        self.rect = CGRectMake(x, y, width, height);
        self.beaconPositions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addBeaconPositions:(NSSet *)objects {
    for (Beacon* point in objects) {
        [self.beaconPositions addObject:point];
    }
}

@end
