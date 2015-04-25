//
//  RayTracingTrilateratingStrategy.h
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTrilateratingMethod.h"

@interface RayTracingTrilateratingStrategy : AbstractTrilateratingMethod

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons;

@end
