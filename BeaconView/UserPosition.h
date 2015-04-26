//
//  UserPosition.h
//  BeaconView
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface UserPosition : NSObject

@property (nonatomic) CGPoint position;

-(id)initWithPosition:(CGPoint) point;

@end
