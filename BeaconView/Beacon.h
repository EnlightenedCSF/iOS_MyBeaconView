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

@interface Beacon : NSObject

@property (nonatomic)double x;
@property (nonatomic)double y;
@property (nonatomic)CLProximity beaconPower;

-(id)initWithCoordinateX:(double)x Y:(double)y;
-(id)initWithCoordinateX:(double)x Y:(double)y Level:(CLProximity)power;
    
@end
