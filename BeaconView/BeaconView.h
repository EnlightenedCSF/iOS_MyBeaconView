//
//  BeaconView.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Floor.h"

@interface BeaconView : UIView

@property (strong, nonatomic) UIImage *userIcon; 
@property (strong, nonatomic) NSDictionary *beaconIcons;
@property (strong, nonatomic) UIImage *takenBeaconImage;

@property (nonatomic) Floor *floor;

-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
