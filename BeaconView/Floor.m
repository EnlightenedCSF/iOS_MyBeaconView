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

@interface Floor()

-(BOOL)isRay:(CGPoint)ray IntersectsWithBeaconAccuracyZone:(RoomBeacon *)beacon;

@end

@implementation Floor

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableDictionary *)beacons UserPosition:(CGPoint)position {
    self = [super init];
     if (self) {
         _rooms = rooms;
         _beacons = beacons;
         _userPosition = position;
         _userPositions = [NSMutableArray new];
         _canDefineUserPosition = NO;
         _boundingRectangle = CGRectMake(0, 0, 0, 0);
         _userRect = CGRectMake(0, 0, 0, 0);
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
    
    
    //[self calculateUserPositionWithBeacons:[self threeBestBeacons]];
    //[self calculateUserPosition_RAY_TRACING_WithBeacons:[self threeBestBeacons]];
    [self calculateUserPosition_ANOTHER_METHOD_WithBeacons:[self threeBestBeacons]];
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

-(void)calculateUserPosition_RAY_TRACING_WithBeacons:(NSMutableArray *)beacons {
    if (beacons.count != 3) {
        self.canDefineUserPosition = NO;
        return;
    }
    self.canDefineUserPosition = YES;
    
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
    _boundingRectangle = CGRectMake(xMin, yMin, xMax - xMin, yMax - yMin);
    
    //xMin = yMin = 1e10;
    //xMax = yMax= -1e10;
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
    _userRect = CGRectMake(xMinUser, yMinUser, xMaxUser - xMinUser, yMaxUser - yMinUser);
    _userPosition = CGPointMake((xMinUser + xMaxUser)/2.0, (yMinUser +yMaxUser)/2.0);
    _userProximity = (xMaxUser - xMinUser  < yMaxUser - yMinUser) ? (xMaxUser - xMinUser)/2.0 : (yMaxUser - yMinUser)/2.0;
    [_userPositions addObject:[[UserPosition alloc] initWithPosition:_userPosition]];
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

-(void)calculateUserPosition_ANOTHER_METHOD_WithBeacons:(NSMutableArray *)beacons {
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
    double ex[2],ey[2],ez[2];
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
}

@end
