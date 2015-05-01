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

#import "FirstTrilateratingStrategy.h"
#import "RayTracingTrilateratingStrategy.h"

@implementation Floor

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableDictionary *)beacons UserPosition:(CGPoint)position {
    self = [super init];
     if (self) {
         _rooms = rooms;
         _beacons = beacons;
         
         _canDefineUserPosition = NO;
         _algorithm = [[RayTracingTrilateratingStrategy alloc] initWithFloor:self];
         
         _userPosition = position;
         _userPositions = [NSMutableArray new];
         
         _boundingRectangle = CGRectMake(0, 0, 0, 0);
         _userRect = CGRectMake(0, 0, 0, 0);
         _userProximity = 0;
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
    
    NSMutableArray *threeBestBeacons = [self threeBestBeacons];
    
    if (threeBestBeacons == nil || threeBestBeacons.count != 3) {
        self.canDefineUserPosition = NO;
        return;
    }
    self.canDefineUserPosition = YES;
    
    [_algorithm calculateUserPositionUsingBeacons:threeBestBeacons];
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

-(void)useAnotherCalculationStrategy:(AbstractTrilateratingStrategy *)strategy {
    _algorithm = strategy;
}

/*-(void)calculateUserPosition_ANOTHER_METHOD_WithBeacons:(NSMutableArray *)beacons {
    if (beacons == nil || beacons.count != 3) {
        self.canDefineUserPosition = NO;
        return;
    }
    self.canDefineUserPosition = YES;
    
    CGPoint a = CGPointMake([((RoomBeacon *)beacons[0]).pos[0] doubleValue], [((RoomBeacon *)beacons[0]).pos[1] doubleValue]);
    CGPoint b = CGPointMake([((RoomBeacon *)beacons[1]).pos[0] doubleValue], [((RoomBeacon *)beacons[1]).pos[1] doubleValue]);
    CGPoint c = CGPointMake([((RoomBeacon *)beacons[2]).pos[0] doubleValue], [((RoomBeacon *)beacons[2]).pos[1] doubleValue]);
    
    double dA = ((RoomBeacon *)beacons[0]).accuracy;
    double dB = ((RoomBeacon *)beacons[1]).accuracy;
    double dC = ((RoomBeacon *)beacons[2]).accuracy;
    
    if (dA < 0 || dB < 0 || dC < 0) {
        _canDefineUserPosition = NO;
        return;
    }
    
    CGFloat W, Z, x, y, y2;
    W = dA*dA - dB*dB - a.x*a.x - a.y*a.y + b.x*b.x + b.y*b.y;
    Z = dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;
    
    @try {
        x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
        y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y));
        y2 = (Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y));
        y = (y + y2) / 2;
    }
    @catch (NSException *exception) {
        _canDefineUserPosition = NO;
        return;
    }
    
    _userPosition = CGPointMake(x, y);
    [_userPositions addObject:[[UserPosition alloc] initWithPosition:CGPointMake(x, y)]];
}

-(void)calculateUserPosition_THIRD_METHOD_WithBeacons:(NSMutableArray *)beacons {
    if (beacons == nil || beacons.count != 3) {
        self.canDefineUserPosition = NO;
        return;
    }
    self.canDefineUserPosition = YES;
    
    double xa = [((RoomBeacon *)beacons[0]).pos[0] doubleValue], ya = [((RoomBeacon *)beacons[0]).pos[1] doubleValue];
    double xb = [((RoomBeacon *)beacons[1]).pos[0] doubleValue], yb = [((RoomBeacon *)beacons[1]).pos[1] doubleValue];
    double xc = [((RoomBeacon *)beacons[2]).pos[0] doubleValue], yc = [((RoomBeacon *)beacons[2]).pos[1] doubleValue];
    
    double dx = xa, dy = ya;
    xa -= dx; xb -= dx; xc -= dx;
    ya -= dy; yb -= dy; yc -= dy;
    
    double triPt[2]={0,0};   //Trilaterated point
    double p1[2]={xa,ya};
    double p2[2]={xb,yb};
    double p3[2]={xc,yc};
    double ex[2],ey[2];//,ez[2];
    double i=0,k=0,x=0,y=0;
    
    double distA = ((RoomBeacon *)beacons[0]).accuracy;
    double distB = ((RoomBeacon *)beacons[1]).accuracy;
    double distC = ((RoomBeacon *)beacons[2]).accuracy;
    
    //Transforms to find circles around the three access points
    //Here it is assumed that all access points and the trilaterated point are in the same plane
    
    for(int j=0;j<2;j++)
    {
        ex[j]=p2[j]-p1[j];
    }
    double d=sqrt(pow(ex[0],2)+pow(ex[1],2));
    for(int j=0;j<2;j++)
    {
        ex[j]=ex[j]/(sqrt(pow(ex[0],2)+pow(ex[1],2)));
    }
    for(int j=0;j<2;j++)
    {
        i=i+(p3[j]-p1[j])*ex[j];
    }
    for(int j=0;j<2;j++)
    {
        ey[j]=p3[j]-p1[j]-i*ex[j];
    }
    for(int j=0;j<2;j++)
    {
        ey[j]=ey[j]/(sqrt(pow(ey[0],2)+pow(ey[1],2)));
    }
    for(int j=0;j<2;j++)
    {
        k=k+(ey[j]*(p3[j]-p1[j]));
    }
    x=(pow(distA,2)-pow(distB,2)+pow(d,2))/(2*d);
    y=((pow(distA,2)-pow(distC,2)+pow(i,2)+pow(k,2))/(2*k))-((i/k)*x);
    
    //Calculating the co-ordinates of the point to be trilaterated
    
    for(int j=0;j<3;j++)
    {
        triPt[j]=p1[j]+x*ex[j]+y*ey[j];
    }
    
    //Print the values
    
    _userPosition = CGPointMake(triPt[0], triPt[1]);
    
    //cout<<triPt[0]<<endl<<triPt[1];
    //getch();
    //return 0;
}*/

@end
