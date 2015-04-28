//
//  PowerLinesTrilateratingStrategy.h
//  BeaconView
//
//  Created by Admin on 28.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTrilateratingMethod.h"

@interface PowerLinesTrilateratingStrategy : AbstractTrilateratingMethod

-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons;

@end
