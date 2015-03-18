//
//  Room.h
//  BeaconView
//
//  Created by Admin on 18.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Room : NSObject

@property (nonatomic) CGRect rect;
@property (strong) NSMutableArray *beaconPositions; //of Beacon

-(id)initWithX:(double)x Y:(double)y Width:(double)width Height:(double)height;

-(void)addBeaconPositions:(NSSet *)objects;

@end
