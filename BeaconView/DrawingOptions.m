//
//  DrawingOptions.m
//  BeaconView
//
//  Created by Admin on 26.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "DrawingOptions.h"

@implementation DrawingOptions

-(id)init {
    self = [super init];
    if (self) {
        _isDrawingGrid = YES;
        _gridCellSize = 2;
        
        _isDrawingUserTrace = YES;
        _isDrawingUserProximity = NO;
        
        _isDrawingBeaconLabels = YES;
        _isDrawingBeaconAccuracyRadiuses = YES;
    }
    return self;
}

+(DrawingOptions *)sharedData {
    static id data = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        data = [[DrawingOptions alloc] init];
    });
    return data;
}

@end
