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

@property (strong, nonatomic) UIImage *userIcon; 
@property (strong, nonatomic) NSDictionary *beaconIcons;
@property (strong) NSMutableArray *rooms; // of Room

@property (nonatomic) double userX;
@property (nonatomic) double userY;

-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
