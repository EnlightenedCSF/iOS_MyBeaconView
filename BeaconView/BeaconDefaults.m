//
//  BeaconDefaults.m
//  BeaconView
//
//  Created by Admin on 24.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconDefaults.h"

@implementation BeaconDefaults

-(id)init {
    self = [super init];
    if (self) {
        _uuid = [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
        _defaultPower = @-59;
    }
    return self;
}

+(BeaconDefaults *)sharedData {
    static id data = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        data = [[BeaconDefaults alloc] init];
    });
    return data;
}

@end
