//
//  PowerLinesTrilateratingStrategy.m
//  BeaconView
//
//  Created by Admin on 28.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "PowerLinesTrilateratingStrategy.h"
#import "Floor.h"
#import "RoomBeacon.h"

@implementation PowerLinesTrilateratingStrategy

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons {
    
    NSArray *B1 = ((RoomBeacon *)beacons[0]).pos;
    NSArray *B2 = ((RoomBeacon *)beacons[1]).pos;
    NSArray *B3 = ((RoomBeacon *)beacons[2]).pos;
    
    //this is the distance between all the points and the unknown point
    double DistA = ((RoomBeacon *)beacons[0]).distance;
    double DistB = ((RoomBeacon *)beacons[1]).distance;
    double DistC = ((RoomBeacon *)beacons[2]).distance;
    
    // k[n] = ( B[n].x^2 + B[n].y^2 - dist[n]^2 )/2
    double k1 = ([B1[0] doubleValue]*[B1[0] doubleValue] + [B1[1] doubleValue]*[B1[1] doubleValue] - DistA*DistA) / 2.0;
    double k2 = ([B2[0] doubleValue]*[B2[0] doubleValue] + [B2[1] doubleValue]*[B2[1] doubleValue] - DistB*DistB) / 2.0;
    double k3 = ([B3[0] doubleValue]*[B3[0] doubleValue] + [B3[1] doubleValue]*[B3[1] doubleValue] - DistC*DistC) / 2.0;
    
    // D = | x1-x2  y1-y2 | = (x1-x2)*(y2-y3) - (y1-y2)*(x2-x3)
    //     | x2-x3  y2-y3 |
    double D = ([B1[0] doubleValue] - [B2[0] doubleValue]) * ([B2[1] doubleValue] - [B3[1] doubleValue]) -
               ([B1[1] doubleValue] - [B2[1] doubleValue]) * ([B2[0] doubleValue] - [B3[0] doubleValue]);
    
    if (abs(D) < 1e-7) {
        self.floor.canDefineUserPosition = NO;
        return;
    }
    
    // X = | k1-k2  y1-y2 | = (k1-k2)*(y2-y3) - (y1-y2)*(k2-k3)
    //     | k2-k3  y2-y3 |
    double X = (k1 - k2) * ([B2[1] doubleValue] - [B3[1] doubleValue]) -
               (k2 - k3) * ([B1[1] doubleValue] - [B2[1] doubleValue]);
    
    // Y = | x1-x2  k1-k2 | = (x1-x2)*(k2-k3) - (k1-k2)*(x2-x3)
    //     | x2-x3  k2-k3 |
    double Y = ([B1[0] doubleValue] - [B2[0] doubleValue]) * (k2 - k3) -
               ([B2[0] doubleValue] - [B3[0] doubleValue]) * (k1 - k2);
    
    self.floor.userPosition = [[UserPosition alloc] initWithPosition:CGPointMake(X / D, Y / D)];
    [self.floor.userPositions addObject:self.floor.userPosition];
}

@end
