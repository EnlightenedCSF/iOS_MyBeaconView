//
//  DrawingOptions.h
//  BeaconView
//
//  Created by Admin on 26.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawingOptions : NSObject

+(DrawingOptions *)sharedData;

@property (nonatomic)BOOL isDrawingGrid;
@property (nonatomic)double gridCellSize;

@property (nonatomic)BOOL isDrawingTrace;
@property (nonatomic)BOOL isDrawingUserProximity;
@property (nonatomic)BOOL isDrawingUserBoundingBoxes;

@property (nonatomic)BOOL isDrawingBeaconAccuracyRadiuses;
@property (nonatomic)BOOL isDrawingBeaconLabels;

@end
