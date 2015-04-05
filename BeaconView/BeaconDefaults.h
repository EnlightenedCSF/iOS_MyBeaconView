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

@property (nonatomic) BOOL useFilter;
@property (nonatomic) double kalmanK;

@end
