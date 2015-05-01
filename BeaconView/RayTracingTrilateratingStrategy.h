//
//  RayTracingTrilateratingStrategy.h
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTrilateratingStrategy.h"

@interface RayTracingTrilateratingStrategy : AbstractTrilateratingStrategy

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons;

@end
