//
//  Room.m
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "Floor.h"
#import "RoomBeacon.h"
#import "BeaconDefaults.h"
#import "UserPosition.h"

@implementation Floor

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableDictionary *)beacons UserPosition:(CGPoint)position {
    self = [super init];
     if (self) {
         _rooms = rooms;
         _beacons = beacons;
         _userPosition = position;
         _userPositions = [NSMutableArray new];
         _canDefineUserPosition = NO;
     }
     return self;
}

-(void)didRangeBeacons:(NSArray *)beacons {
    for (RoomBeacon *beacon in [self.beacons allValues]) {
        beacon.isTakenForCalculation = NO;
    }
    
    
    NSString *uuid = [[BeaconDefaults sharedData].uuid UUIDString];
    for (CLBeacon *beacon in beacons) {
        NSString *key = [NSString stringWithFormat:@"%@%@%@", uuid, beacon.major, beacon.minor];
        
        RoomBeacon *roomBeacon = [self.beacons objectForKey:key];
        if (roomBeacon == nil) {
            continue;
        }
        roomBeacon.proximity = beacon.proximity;
        roomBeacon.rssi = beacon.rssi;
        roomBeacon.lastMeasurment = roomBeacon.accuracy;
        if ([BeaconDefaults sharedData].isFilteringAccuracy) {
            double k = [BeaconDefaults sharedData].kalmanKforAccuracy;
            roomBeacon.accuracy = roomBeacon.lastMeasurment * k + beacon.accuracy * (1.0 - k);
        }
        else {
            roomBeacon.accuracy = beacon.accuracy;
        }
        double h = roomBeacon.h;
        double a = roomBeacon.accuracy;
        roomBeacon.distance = sqrt(a * a - h * h);
    }
    
    [self calculateUserPositionWithBeacons:[self threeBestBeacons]];
}

-(NSMutableArray *)threeBestBeacons {
    if (self.beacons.count < 3)
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];    
    for (RoomBeacon *beacon in [self.beacons allValues]) {
        if (result.count < 3) {
            [result addObject:beacon];
        }
        else {
            RoomBeacon *worst = result[0];
            for (int k = 1; k < result.count; k++) {
                RoomBeacon *b = result[k];
                if (worst.rssi > b.rssi) {
                    worst = b;
                }
            }
            
            RoomBeacon *newBeacon = beacon;
            if (worst.rssi < newBeacon.rssi) {
                [result removeObject:worst];
                [result addObject:newBeacon];
            }
        }
    }
    
    for (RoomBeacon *b in result) {
        b.isTakenForCalculation = YES;
    }
    return result;
}

//todo: rewrite in C
-(void)calculateUserPositionWithBeacons:(NSMutableArray *)beacons {
    if (beacons == nil || beacons.count != 3) {
        self.canDefineUserPosition = NO;
        return;
    }
    self.canDefineUserPosition = YES;
    
    NSArray *P1 = ((RoomBeacon *)beacons[0]).pos;
    NSArray *P2 = ((RoomBeacon *)beacons[1]).pos;
    NSArray *P3 = ((RoomBeacon *)beacons[2]).pos;
    
    //this is the distance between all the points and the unknown point
    double DistA = ((RoomBeacon *)beacons[0]).distance;
    double DistB = ((RoomBeacon *)beacons[1]).distance;
    double DistC = ((RoomBeacon *)beacons[2]).distance;
    
    // ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
    NSMutableArray *ex = [[NSMutableArray alloc] initWithCapacity:0];
    double temp = 0;
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t = t1 - t2;
        temp += (t*t);
    }
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double exx = (t1 - t2)/sqrt(temp);
        [ex addObject:[NSNumber numberWithDouble:exx]];
    }
    
    // i = dot(ex, P3 - P1)
    NSMutableArray *p3p1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = t1 - t2;
        [p3p1 addObject:[NSNumber numberWithDouble:t3]];
    }
    
    double ival = 0;
    for (int i = 0; i < [ex count]; i++) {
        double t1 = [[ex objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        ival += (t1*t2);
    }
    
    // ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
    NSMutableArray *ey = [[NSMutableArray alloc] initWithCapacity:0];
    double p3p1i = 0;
    for (int  i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double t = t1 - t2 -t3;
        p3p1i += (t*t);
    }
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double eyy = (t1 - t2 - t3)/sqrt(p3p1i);
        [ey addObject:[NSNumber numberWithDouble:eyy]];
    }
    
    
    // ez = numpy.cross(ex,ey)
    // if 2-dimensional vector then ez = 0
    NSMutableArray *ez = [[NSMutableArray alloc] initWithCapacity:0];
    double ezx;
    double ezy;
    double ezz;
    if ([P1 count] !=3){
        ezx = 0;
        ezy = 0;
        ezz = 0;
        
    }else{
        ezx = ([[ex objectAtIndex:1] doubleValue]*[[ey objectAtIndex:2]doubleValue]) - ([[ex objectAtIndex:2]doubleValue]*[[ey objectAtIndex:1]doubleValue]);
        ezy = ([[ex objectAtIndex:2] doubleValue]*[[ey objectAtIndex:0]doubleValue]) - ([[ex objectAtIndex:0]doubleValue]*[[ey objectAtIndex:2]doubleValue]);
        ezz = ([[ex objectAtIndex:0] doubleValue]*[[ey objectAtIndex:1]doubleValue]) - ([[ex objectAtIndex:1]doubleValue]*[[ey objectAtIndex:0]doubleValue]);
        
    }
    
    [ez addObject:[NSNumber numberWithDouble:ezx]];
    [ez addObject:[NSNumber numberWithDouble:ezy]];
    [ez addObject:[NSNumber numberWithDouble:ezz]];
    
    
    // d = numpy.linalg.norm(P2 - P1)
    double d = sqrt(temp);
    
    // j = dot(ey, P3 - P1)
    double jval = 0;
    for (int i = 0; i < [ey count]; i++) {
        double t1 = [[ey objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        jval += (t1*t2);
    }
    
    // x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
    double xval = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d);
    
    // y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
    double yval = ((pow(DistA,2) - pow(DistC,2) + pow(ival,2) + pow(jval,2))/(2*jval)) - ((ival/jval)*xval);
    
    // z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
    // if 2-dimensional vector then z = 0
    double zval;
    if ([P1 count] !=3){
        zval = 0;
    }else{
        zval = sqrt(pow(DistA,2) - pow(xval,2) - pow(yval,2));
    }
    
    // triPt = P1 + x*ex + y*ey + z*ez
    NSMutableArray *triPt = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P1 objectAtIndex:i] doubleValue];
        double t2 = [[ex objectAtIndex:i] doubleValue] * xval;
        double t3 = [[ey objectAtIndex:i] doubleValue] * yval;
        double t4 = [[ez objectAtIndex:i] doubleValue] * zval;
        double triptx = t1+t2+t3+t4;
        [triPt addObject:[NSNumber numberWithDouble:triptx]];
    }
    
    CGPoint p = CGPointMake([triPt[0] doubleValue], [triPt[1] doubleValue]);
    
    if ([BeaconDefaults sharedData].isFilteringUserPosition) {
        double k = [BeaconDefaults sharedData].kalmanKforUser;
        CGPoint newPos = CGPointMake(self.userPosition.x * k + (1-k) * p.x,
                                     self.userPosition.y * k + (1-k) * p.y);
        self.userPosition = newPos;
        [self.userPositions addObject:[[UserPosition alloc] initWithPosition:newPos]];        
    }
    else {
        self.userPosition = p;
        [self.userPositions addObject:[[UserPosition alloc] initWithPosition:p]];
    }
}

@end
