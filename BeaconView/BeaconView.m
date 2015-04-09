//
//  BeaconView.m
//  BeaconView
//
//  Created by Admin on 15.03.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "BeaconView.h"
#import "RoomBeacon.h"
#import "Floor.h"
#import "Room.h"
#import "UserPosition.h"

@interface BeaconView()

@property (nonatomic) double anchorX;
@property (nonatomic) double anchorY;

@end

@implementation BeaconView

double ROOM_CONTOUR_LINE_WIDTH = 2;
double PIXELS_PER_METER = 80.0;
double BEACON_ICON_HALF_WIDTH;
double BEACON_ICON_HALF_HEIGHT;
double USER_ICON_HALF_WIDTH;
double USER_ICON_HEIGHT;

CGPoint touchLocation;

#pragma mark - Coordinates conversion

-(CGPoint)convertBeaconPosition:(CGPoint) position {
    return CGPointMake(position.x * PIXELS_PER_METER - BEACON_ICON_HALF_WIDTH + _anchorX,
                       position.y * PIXELS_PER_METER - BEACON_ICON_HALF_HEIGHT + _anchorY);
}

-(CGFloat)convertBeaconX:(double)x {
    return x * PIXELS_PER_METER - BEACON_ICON_HALF_WIDTH + _anchorX;
}

-(CGFloat)convertBeaconY:(double)y {
    return PIXELS_PER_METER * y - BEACON_ICON_HALF_HEIGHT + _anchorY;
}

-(CGPoint)convertUserPosition:(CGPoint)position {
    return CGPointMake(position.x * PIXELS_PER_METER - USER_ICON_HALF_WIDTH + _anchorX,
                       position.y * PIXELS_PER_METER - USER_ICON_HEIGHT + _anchorY);
}

/*-(CGFloat)convertUserX:(double)x {
    return x * PIXELS_PER_METER - USER_ICON_HALF_WIDTH + _anchorX;
}

-(CGFloat)convertUserY:(double)y {
    return y * PIXELS_PER_METER - USER_ICON_HEIGHT + _anchorY;
}*/

#pragma mark - Initialization

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
    _anchorX = 0;
    _anchorY = 0;
    
    self.userIcon = [UIImage imageNamed:@"icon_user"];
    self.beaconIcons = @{ [NSNumber numberWithInt:CLProximityUnknown]: [UIImage imageNamed:@"icon"],
                          [NSNumber numberWithInt:CLProximityImmediate]: [UIImage imageNamed:@"icon_green"],
                          [NSNumber numberWithInt:CLProximityNear]: [UIImage imageNamed:@"icon_yellow"],
                          [NSNumber numberWithInt:CLProximityFar]: [UIImage imageNamed:@"icon_red"]
                          };
    
    UIImage *icon = [self.beaconIcons objectForKey:[NSNumber numberWithInt:CLProximityFar]];
    BEACON_ICON_HALF_WIDTH = icon.size.width / 2.0;
    BEACON_ICON_HALF_HEIGHT = icon.size.height / 2.0;
    USER_ICON_HALF_WIDTH = self.userIcon.size.width / 2.0;
    USER_ICON_HEIGHT = self.userIcon.size.height;
    
    NSMutableArray *rooms = [[NSMutableArray alloc] initWithObjects:
                             [[Room alloc] initWithRect:CGRectMake(0.5, 0.5, 3, 3.5)], nil];
    
    /*NSMutableArray *beacons = [[NSMutableArray alloc] initWithObjects:
                               [[RoomBeacon alloc] initWithCoordinateX:1    Y:1 major:1 minor:3],
                               [[RoomBeacon alloc] initWithCoordinateX:2.45 Y:1 major:1 minor:4], для большой комнаты
                               [[RoomBeacon alloc] initWithCoordinateX:1    Y:2 major:1 minor:1],
                               [[RoomBeacon alloc] initWithCoordinateX:2.45 Y:2 major:1 minor:2], nil];*/
    
    /*NSMutableArray *beacons = [[NSMutableArray alloc] initWithObjects:
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1], [NSNumber numberWithDouble:1], nil] height:0 major:1 minor:1],
                               
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:2.5], [NSNumber numberWithDouble:1.5], nil] height:0 major:1 minor:2],
                               
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1], [NSNumber numberWithDouble:2], nil] height:0 major:1 minor:3], nil];*/
    
    NSMutableArray *beacons = [[NSMutableArray alloc] initWithObjects:
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1], [NSNumber numberWithDouble:1], nil] height:0 major:1 minor:1],
                               
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:1], nil] height:0 major:1 minor:2],
                               
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:3], nil] height:0 major:1 minor:3],
                               
                               [[RoomBeacon alloc] initWithPosition:
                                [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:1], [NSNumber numberWithDouble:3], nil] height:0 major:1 minor:4], nil];
    
    
    self.floor = [[Floor alloc] initWithRooms:rooms Beacons:beacons UserPosition:CGPointMake(0, 0)];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:220.0/255.0 green:237.0/255.0 blue:250.0/255.0 alpha:1] setFill];
    [[UIColor blackColor] setStroke];
    
    // Rooms
    for (Room *room in self.floor.rooms) {
        UIBezierPath *roomContour = [UIBezierPath bezierPathWithRect:[self getDrawableRectFromRoom:room]];
        roomContour.lineWidth = ROOM_CONTOUR_LINE_WIDTH;
        [roomContour fill];
        [roomContour stroke];
    }
    
    // Beacons, labels and radiuses
    for (RoomBeacon *beacon in self.floor.beacons) {
    
        [[UIColor colorWithRed:215.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:0.4] setFill];
        UIBezierPath *radius = [UIBezierPath bezierPathWithOvalInRect:[self getDrawableRectForBeacon:beacon]];
        [radius fill];
        
        [[self.beaconIcons objectForKey:[NSNumber numberWithInt:beacon.proximity]]
         drawAtPoint:CGPointMake([self convertBeaconX:[beacon.pos[0] doubleValue]], [self convertBeaconY:[beacon.pos[1] doubleValue]])];
        
        [self drawLabelsForBeacon:beacon];
    }
    
    // User
    if (self.floor.userPositions.count > 1) {
        [[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.5 alpha:1] setStroke];
        
        UIBezierPath *userTrack = [UIBezierPath new];
        
        UserPosition *point = [self.floor.userPositions objectAtIndex:0];
        [userTrack moveToPoint:[self convertUserPosition:point.position]];
        
        for (int i = 1; i < self.floor.userPositions.count; i++) {
            point = [self.floor.userPositions objectAtIndex:i];
            [userTrack addLineToPoint:[self convertUserPosition:point.position]];
        }
        [userTrack closePath];
        [userTrack stroke];
    }
    
    if (self.floor.canDefineUserPosition) {
        [self.userIcon drawAtPoint:[self convertUserPosition:self.floor.userPosition]];
    }
}


-(void)drawLabelsForBeacon:(RoomBeacon *)beacon {
    CGPoint p = CGPointMake([self convertBeaconX:[beacon.pos[0] doubleValue]], [self convertBeaconY:[beacon.pos[1] doubleValue]]);
    
    p.y -= 5;
    NSAttributedString *accuracyLabel = [[NSAttributedString alloc]
                                         initWithString:[NSString stringWithFormat:@"%f", beacon.distance]];
    [accuracyLabel drawAtPoint:p];
    
    p.y += 10;
    NSAttributedString *rssiLabel = [[NSAttributedString alloc]
                                     initWithString:[NSString stringWithFormat:@"%ld", (long)beacon.rssi]];
    [rssiLabel drawAtPoint:p];
    
    p.x += 15;
    p.y += 10;
    NSAttributedString *label = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", beacon.minor]];
    [label drawAtPoint:p];
}

-(CGRect)getDrawableRectFromRoom:(Room *)room {
    return CGRectMake(room.rect.origin.x * PIXELS_PER_METER + _anchorX,
                      room.rect.origin.y * PIXELS_PER_METER + _anchorY,
                      room.rect.size.width * PIXELS_PER_METER,
                      room.rect.size.height * PIXELS_PER_METER);
}

-(CGRect)getDrawableRectForBeacon:(RoomBeacon *)beacon {
    double r = beacon.accuracy * PIXELS_PER_METER;
    double x = [self convertBeaconX:[beacon.pos[0] doubleValue]] + BEACON_ICON_HALF_WIDTH;
    double y = [self convertBeaconY:[beacon.pos[1] doubleValue]] + BEACON_ICON_HALF_HEIGHT;
    return CGRectMake(x - r/2.0, y - r/2.0, r, r);
}

#pragma mark - Gestures

-(void)pan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        touchLocation = [gesture locationInView:self];
    }
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
             (gesture.state == UIGestureRecognizerStateEnded)) {
        _anchorX += [gesture locationInView:self].x - touchLocation.x;
        _anchorY += [gesture locationInView:self].y - touchLocation.y;
        touchLocation = [gesture locationInView:self];
        [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        double lastValue = PIXELS_PER_METER;
        PIXELS_PER_METER *= gesture.scale;
        
        _anchorX -= 2*(PIXELS_PER_METER - lastValue);
        _anchorY -= 2*(PIXELS_PER_METER - lastValue);
        
        gesture.scale = 1.0;
        [self setNeedsDisplay];
    }
}

@end
