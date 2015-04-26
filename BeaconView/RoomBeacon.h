//
//  BPoint.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconView.h"
@import CoreLocation;

@interface RoomBeacon : NSObject

@property (nonatomic, readonly) NSArray *pos;
@property (nonatomic, readonly) double h;

@property (nonatomic, readonly) NSNumber *major;
@property (nonatomic, readonly) NSNumber *minor;

@property (nonatomic) NSInteger rssi;
@property (nonatomic) CLProximity proximity;

@property (nonatomic) double accuracy;
@property (nonatomic) double lastMeasurment;
@property (nonatomic) double distance;

@property (nonatomic) BOOL isTakenForCalculation;

-(id)initWithPosition:(NSArray *) pos height:(double)h major:(int)major minor:(int)minor;

@end
