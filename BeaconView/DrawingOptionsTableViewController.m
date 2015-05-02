//
//  DrawingOptionsTableViewController.m
//  BeaconView
//
//  Created by Admin on 26.04.15.
//  Copyright (c) 2015 CSF. All rights reserved.
//

#import "DrawingOptionsTableViewController.h"
#import "DrawingOptions.h"
#import "BeaconDefaults.h"

@interface DrawingOptionsTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchGrid;
@property (weak, nonatomic) IBOutlet UIStepper *stepperGridCellSize;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGridCellSize;

@property (weak, nonatomic) IBOutlet UISwitch *switchUserProx;
@property (weak, nonatomic) IBOutlet UISwitch *switchUserTrace;


@property (weak, nonatomic) IBOutlet UISwitch *switchBeaconLabels;
@property (weak, nonatomic) IBOutlet UISwitch *switchBeaconsAccuracy;

@property (weak, nonatomic) IBOutlet UISwitch *switchFilterAccuracy;
@property (weak, nonatomic) IBOutlet UIStepper *stepperAccuracyK;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAccuracyK;

@property (weak, nonatomic) IBOutlet UISwitch *switchFilterUserPosition;
@property (weak, nonatomic) IBOutlet UIStepper *stepperUserPositionK;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserPositionK;

@end

@implementation DrawingOptionsTableViewController

NSNumberFormatter *numberFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    numberFormatter = [NSNumberFormatter new];
    numberFormatter.roundingIncrement = [NSNumber numberWithDouble:0.1];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
}

#pragma mark - Switches and steppers

- (IBAction)toggleGrid:(UISwitch *)sender {
    [DrawingOptions sharedData].isDrawingGrid = self.switchGrid.isOn;
    [self.textFieldGridCellSize setEnabled:self.switchGrid.isOn];
    [self.stepperGridCellSize setEnabled:self.switchGrid.isOn];
}

- (IBAction)gridCellSizeChanged:(id)sender {
    [self.textFieldGridCellSize setText:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:0.5*self.stepperGridCellSize.value]]];
    [DrawingOptions sharedData].gridCellSize = 0.5 * self.stepperGridCellSize.value;
}

- (IBAction)toggleUserTrace:(id)sender {
    [DrawingOptions sharedData].isDrawingUserTrace = self.switchUserTrace.isOn;
}

- (IBAction)toggleUserProximity:(id)sender {
    [DrawingOptions sharedData].isDrawingUserProximity = self.switchUserProx.isOn;
}

- (IBAction)toggleBeaconsAccuracy:(id)sender {
    [DrawingOptions sharedData].isDrawingBeaconAccuracyRadiuses = self.switchBeaconsAccuracy.isOn;
}

- (IBAction)toggleBeaconLabels:(id)sender {
    [DrawingOptions sharedData].isDrawingBeaconLabels = self.switchBeaconLabels.isOn;
}

- (IBAction)toggleAccuracyFiltering:(id)sender {
    [BeaconDefaults sharedData].isFilteringAccuracy = self.switchFilterAccuracy.isOn;
    [self.stepperAccuracyK setEnabled:self.switchFilterAccuracy.isOn];
    [self.textFieldAccuracyK setEnabled:self.switchFilterAccuracy.isOn];
}

- (IBAction)filterAccuracyKChanged:(id)sender {
    [self.textFieldAccuracyK setText:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.stepperAccuracyK.value / 10.0]]];
    [BeaconDefaults sharedData].kalmanKforAccuracy = self.stepperAccuracyK.value / 10.0;
}

- (IBAction)toggleUserPosFiltering:(id)sender {
    [BeaconDefaults sharedData].isFilteringUserPosition = self.switchFilterUserPosition.isOn;
    [self.stepperUserPositionK setEnabled:self.switchFilterUserPosition.isOn];
    [self.textFieldUserPositionK setEnabled:self.switchFilterUserPosition.isOn];
}

- (IBAction)filterUserPosKChanged:(id)sender {
    [self.textFieldUserPositionK setText:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.stepperUserPositionK.value / 10.0]]];
    [BeaconDefaults sharedData].kalmanKforUser = self.stepperUserPositionK.value / 10.0;
}

@end
