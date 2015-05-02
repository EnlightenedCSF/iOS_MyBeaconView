//
//  UserPosition.m
//  BeaconView
//
//  Created by Admin on 09.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "UserPosition.h"

@implementation UserPosition

-(id)initWithPosition:(CGPoint)point {
    self = [super init];
    if (self) {
        _position = point;
    }
    return self;
}

-(double)x {
    return _position.x;
}

-(double)y {
    return _position.y;
}

@end
