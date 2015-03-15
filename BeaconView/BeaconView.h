//
//  BeaconView.h
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconView : UIView

@property (strong, nonatomic) UIImage *beaconImage;
@property (strong) NSMutableArray *beaconPositions; //of BPoint

-(void)addBeaconPositions:(NSSet *)objects;

@end
