//
//  BPoint.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPoint : NSObject

@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger y;

-(id)initWithCoordinateX:(NSInteger)x Y:(NSInteger)y;

@end
