//
//  Room.h
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTrilateratingStrategy.h"
#import "UserPosition.h"
@import CoreGraphics;


@interface Floor : NSObject

@property (nonatomic, strong) NSMutableArray *rooms;        // of Room
@property (nonatomic, strong) NSMutableDictionary *beacons; // of @"uuid+major+minor" => Room Beacon

@property (nonatomic) BOOL canDefineUserPosition;
@property (nonatomic, strong) AbstractTrilateratingStrategy *algorithm;

@property (nonatomic, strong) UserPosition* userPosition;
@property (nonatomic, strong) NSMutableArray *userPositions;

@property (nonatomic) CGRect userProximityRect;

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableDictionary *)beacons UserPosition:(CGPoint)position;

-(void)didRangeBeacons:(NSArray *)beacons;

-(void)useAnotherCalculationStrategy:(AbstractTrilateratingStrategy *)strategy;

@end
