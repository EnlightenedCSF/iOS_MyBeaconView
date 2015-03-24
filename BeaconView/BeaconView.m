//
//  BeaconView.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconView.h"
#import "Beacon.h"
#import "Room.h"

@implementation BeaconView

double PIXELS_PER_METER = 80.0;
double anchorX = 0.0;
double anchorY = 0.0;

CGPoint touchLocation;

-(CGFloat)convertBeaconX:(double)x {
    UIImage *icon = [self.beaconIcons objectForKey:[NSNumber numberWithInt:CLProximityFar]];
    double halfWidth = icon.size.width / 2.0;
    return x * PIXELS_PER_METER - halfWidth + anchorX;
}

-(CGFloat)convertBeaconY:(double)y {
    UIImage *icon = [self.beaconIcons objectForKey:[NSNumber numberWithInt:CLProximityFar]];
    double halfHeight = icon.size.height / 2.0;
    return PIXELS_PER_METER * y - halfHeight + anchorY;
}

-(CGFloat)convertUserX:(double)x {
    double halfWidth = self.userIcon.size.width / 2.0;
    return x * PIXELS_PER_METER - halfWidth + anchorX;
}

-(CGFloat)convertUserY:(double)y {
    double height = self.userIcon.size.height;
    return y * PIXELS_PER_METER - height + anchorY;
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
    NSLog(@"The sizes of the component: X:%f; Y:%f", self.bounds.size.width, self.bounds.size.height);
    
    self.userIcon = [UIImage imageNamed:@"icon_user"];
    self.userX = 1.5;
    self.userY = 1.5;
    
    self.beaconIcons = @{ [NSNumber numberWithInt:CLProximityUnknown]: [UIImage imageNamed:@"icon"],
                          [NSNumber numberWithInt:CLProximityImmediate]: [UIImage imageNamed:@"icon_green"],
                          [NSNumber numberWithInt:CLProximityNear]: [UIImage imageNamed:@"icon_yellow"],
                          [NSNumber numberWithInt:CLProximityFar]: [UIImage imageNamed:@"icon_red"]
                          };
    
    NSMutableSet *set = [[NSMutableSet alloc]initWithCapacity:3];
    [set addObject:[[Beacon alloc] initWithCoordinateX:0.5 Y:0.5 Level:CLProximityUnknown]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:2.5 Y:0.5 Level:CLProximityImmediate]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:0.5 Y:3 Level:CLProximityNear]];
    [set addObject:[[Beacon alloc] initWithCoordinateX:2.5 Y:3 Level:CLProximityFar]];
    
    Room *room = [[Room alloc] initWithX:0.5 Y:0.5 Width:3 Height:3.5];
    [room addBeaconPositions:set];
    
    self.rooms = [NSMutableArray arrayWithObject:room];
}

- (void)drawRect:(CGRect)rect {
    UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:220.0/255.0 green:237.0/255.0 blue:250.0/255.0 alpha:1] setFill];
    [[UIColor blackColor] setStroke];
    
    // Drawing code
    for (Room *room in self.rooms) {
        UIBezierPath* roomContour = [UIBezierPath bezierPathWithRect:[self getDrawableRectFromRoom:room]];
        roomContour.lineWidth = 2;
        [roomContour fill];
        [roomContour stroke];
        
        for (Beacon *beacon in room.beaconPositions) {
            [[self.beaconIcons objectForKey:[NSNumber numberWithInt:beacon.beaconPower]]
                drawAtPoint:CGPointMake([self convertBeaconX:(beacon.x + room.rect.origin.x)],
                                        [self convertBeaconY:(beacon.y + room.rect.origin.y)])];
        }
    }
    
    [self.userIcon drawAtPoint:CGPointMake([self convertUserX:self.userX], [self convertUserY:self.userY])];
}

-(CGRect)getDrawableRectFromRoom:(Room *)room {
    return CGRectMake(room.rect.origin.x * PIXELS_PER_METER + anchorX, room.rect.origin.y * PIXELS_PER_METER + anchorY,
                      room.rect.size.width * PIXELS_PER_METER, room.rect.size.height * PIXELS_PER_METER);
}

-(void)pan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        touchLocation = [gesture locationInView:self];
    }
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
             (gesture.state == UIGestureRecognizerStateEnded)) {
        anchorX += [gesture locationInView:self].x - touchLocation.x;
        anchorY += [gesture locationInView:self].y - touchLocation.y;
        touchLocation = [gesture locationInView:self];
        [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        double lastValue = PIXELS_PER_METER;
        PIXELS_PER_METER *= gesture.scale;
        
        anchorX -= 2*(PIXELS_PER_METER - lastValue);
        anchorY -= 2*(PIXELS_PER_METER - lastValue);
        
        gesture.scale = 1.0;
        [self setNeedsDisplay];
    }
}

@end
