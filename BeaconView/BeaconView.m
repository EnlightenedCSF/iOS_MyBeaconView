//
//  BeaconView.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconView.h"
#import "BPoint.h"

@implementation BeaconView

-(void)addBeaconPositions:(NSSet *)objects {
    for (BPoint* point in objects) {
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
    self.beaconImage = [UIImage imageNamed:@"icon"];
    self.beaconPositions = [[NSMutableArray alloc] init];
    
    NSLog(@"Image is %@", self.beaconImage);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (BPoint* point in self.beaconPositions) {
        [self.beaconImage drawAtPoint:CGPointMake( [self convertX:point.x], [self convertY:point.y] )];
    }
    [self.beaconImage drawAtPoint:CGPointMake(10, 10)];
}



@end
