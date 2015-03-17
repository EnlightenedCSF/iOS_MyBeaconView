//
//  BPoint.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconView.h"

@interface Beacon : NSObject

@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger y;
@property (nonatomic)enum BeaconPower beaconPower;

-(id)initWithCoordinateX:(NSInteger)x Y:(NSInteger)y;
-(id)initWithCoordinateX:(NSInteger)x Y:(NSInteger)y Level:(enum BeaconPower)power;
    
@end
