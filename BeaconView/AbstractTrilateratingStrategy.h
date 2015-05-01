//
//  AbstractTrilateratingMethod.h
//  BeaconView
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Floor;

@interface AbstractTrilateratingStrategy : NSObject

@property (nonatomic, weak) Floor *floor;

-(id)initWithFloor:(Floor *)floor;

/// This method is abstract; you must implement it in the inherited classes.
-(void)calculateUserPositionUsingBeacons:(NSMutableArray *)beacons;

@end
