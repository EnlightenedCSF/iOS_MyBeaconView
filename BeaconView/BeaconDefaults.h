//
//  BeaconDefaults.h
//  BeaconView
//
//  Created by Admin on 24.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconDefaults : NSObject

+(BeaconDefaults*)sharedData;

@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (strong, nonatomic, readonly) NSNumber *defaultPower;

@property (nonatomic) BOOL isFilteringAccuracy;
@property (nonatomic) double kalmanKforAccuracy;

@property (nonatomic) BOOL isFilteringUserPosition;
@property (nonatomic) double kalmanKforUser;

@end
