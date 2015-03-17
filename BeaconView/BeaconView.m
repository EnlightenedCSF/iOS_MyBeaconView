//
//  BeaconView.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconView.h"
#import "Beacon.h"

@implementation BeaconView

-(void)addBeaconPositions:(NSSet *)objects {
    for (Beacon* point in objects) {
        [self.beaconPositions addObject:point];
        NSLog(@"Added");
    }
}

-(CGFloat)convertX:(NSInteger)x {
    return self.bounds.size.width / 100.0f * x;
}

-(CGFloat)convertY:(NSInteger)y {
    return self.bounds.size.height / 100.0f * y;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)setup {
//    self.beaconImageUnknown = [UIImage imageNamed:@"icon"];
    self.beaconPositions = [[NSMutableArray alloc] init];
    
    self.beaconIcons = @{ [NSNumber numberWithInt:Unknown]: [UIImage imageNamed:@"icon"],
                          [NSNumber numberWithInt:Immidiate]: [UIImage imageNamed:@"icon_green"],
                          [NSNumber numberWithInt:Near]: [UIImage imageNamed:@"icon_yellow"],
                          [NSNumber numberWithInt:Far]: [UIImage imageNamed:@"icon_red"]
                          };
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (Beacon* point in self.beaconPositions) {
        [[self.beaconIcons objectForKey:[NSNumber numberWithInt:point.beaconPower]] drawAtPoint:CGPointMake([self convertX:point.x], [self convertY:point.y])];
    }
}



@end
