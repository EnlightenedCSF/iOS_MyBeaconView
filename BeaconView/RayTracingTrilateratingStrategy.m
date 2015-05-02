//
//  RayTracingTrilateratingStrategy.m
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "RayTracingTrilateratingStrategy.h"
#import "Floor.h"
#import "RoomBeacon.h"
#import "UserPosition.h"

@interface RayTracingTrilateratingStrategy()

-(BOOL)isRay:(CGPoint)ray IntersectsWithBeaconAccuracyZone:(RoomBeacon *)beacon;

@end

@implementation RayTracingTrilateratingStrategy

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons {
    RoomBeacon *first = beacons[0];
    double xMin = [first.pos[0] doubleValue];
    double xMax = xMin;
    double yMin = [first.pos[1] doubleValue];
    double yMax = yMin;
    for (RoomBeacon *beacon in beacons) {
        double x = [beacon.pos[0] doubleValue];
        double y = [beacon.pos[1] doubleValue];
        double r = beacon.accuracy;
        
        if (x-r < xMin) {
            xMin = x-r;
        }
        if (x+r > xMax) {
            xMax = x+r;
        }
        if (y-r < yMin) {
            yMin = y-r;
        }
        if (y+r > yMax) {
            yMax = y+r;
        }
    }
    
    double xMinUser = 1e10;
    double xMaxUser = -1e10;
    double yMinUser = 1e10;
    double yMaxUser = -1e10;
    for (double i = xMin; i < xMax; i += 0.07) {
        for (double j = yMin; j < yMax; j += 0.07) {
            if ([self isRay:CGPointMake(i, j) IntersectsWithBeaconAccuracyZone:beacons[0]] &&
                [self isRay:CGPointMake(i, j) IntersectsWithBeaconAccuracyZone:beacons[1]] &&
                [self isRay:CGPointMake(i, j) IntersectsWithBeaconAccuracyZone:beacons[2]])
            {
                if (i < xMinUser) {
                    xMinUser = i;
                }
                if (i > xMaxUser) {
                    xMaxUser = i;
                }
                
                if (j < yMinUser) {
                    yMinUser = j;
                }
                if (j > yMaxUser) {
                    yMaxUser = j;
                }
            }
        }
    }
    self.floor.userProximityRect = CGRectMake(xMinUser, yMinUser, xMaxUser - xMinUser, yMaxUser - yMinUser);
    self.floor.userPosition = [[UserPosition alloc] initWithPosition:CGPointMake((xMinUser + xMaxUser)/2.0, (yMinUser +yMaxUser)/2.0)];
    [self.floor.userPositions addObject:self.floor.userPosition];
}

-(BOOL)isRay:(CGPoint)ray IntersectsWithBeaconAccuracyZone:(RoomBeacon *)beacon {
    if (beacon == nil) {
        return false;
    }
    
    double r = beacon.accuracy;
    double x = [beacon.pos[0] doubleValue];
    double y = [beacon.pos[1] doubleValue];
    
    return r > sqrt((ray.x - x)*(ray.x - x) + (ray.y - y)*(ray.y - y));
}

@end
