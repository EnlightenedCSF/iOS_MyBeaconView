//
//  Room.h
//  BeaconView
//
//  Created by Admin on 04.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface Room : NSObject

@property (nonatomic) CGRect rect;

-(id)initWithRect:(CGRect) rect;

@end
