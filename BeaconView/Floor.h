//
//  Room.h
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface Floor : NSObject

@property (nonatomic, strong) NSMutableArray *rooms; // of Room
@property (nonatomic, strong) NSMutableArray *beacons; //of Beacon

@property (nonatomic) BOOL canDefineUserPosition;
@property (nonatomic) CGPoint userPosition;
@property (nonatomic, strong) NSMutableArray *userPositions;

-(id)initWithRooms:(NSMutableArray *)rooms Beacons:(NSMutableArray *)beacons UserPosition:(CGPoint)position;

-(void)didRangeBeacons:(NSArray *)beacons;

@end
