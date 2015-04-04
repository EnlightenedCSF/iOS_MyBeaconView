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

@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;

@property (nonatomic, readonly) NSNumber *major;
@property (nonatomic, readonly) NSNumber *minor;

@property (nonatomic) CLProximity proximity;
@property (nonatomic) CLLocationAccuracy accuracy;

-(id)initWithCoordinateX:(double) x Y: (double)y major:(int)major minor:(int)minor;

@end
