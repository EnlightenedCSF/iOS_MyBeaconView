//
//  BeaconView.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <UIKit/UIKit.h>

enum BeaconPower : NSInteger {
    Unknown,
    Immidiate,
    Near,
    Far
};

@interface BeaconView : UIView

@property (strong, nonatomic) NSDictionary *beaconIcons;
property (strong) NSMutableArray *beaconPositions; //of Beacon

-(void)addBeaconPositions:(NSSet *)objects;

@end
