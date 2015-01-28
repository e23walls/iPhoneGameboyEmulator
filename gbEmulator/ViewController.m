//
//  ViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//
// Store ROMs in /var/mobile/Media/ROMs/GAMEBOY/ -- if doesn't exist, create the directory (may also need to create ROMs)

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static rom * currentRom;

- (ViewController *) init
{
    self = [super init];
    if (self != nil)
    {
        romTitleLabel.text = @"Undefined ROM";
    }
    return self;
}
- (ViewController *) initWithCurrentRom:(rom *)theRom
{
    self = [super init];
    if (self != nil)
    {
        currentRom = theRom;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    romTitleLabel.text = currentRom.romName;
    emulator = [[emulatorMain alloc] initWithRom:currentRom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Note that the buttons are all active-high: set the correct bit in memory from 1 to 0 to indicate the button press
// Memory location 0xff00 is P1, and stores input/output info.
/*
 Bit 7 - Not used
 Bit 6 - Not used
 Bit 5 - P15 out port - A/B/START/SELECT
 Bit 4 - P14 out port - ARROWS
 Bit 3 - P13 in port - DOWN  | START
 Bit 2 - P12 in port - UP    | SELECT
 Bit 1 - P11 in port - LEFT  | B
 Bit 0 - P10 in port - RIGHT | A
 
 For emulator.keys, we'll say that the lower 4 bits are for the arrows,
 D, U, L, R
 And the top 4 bits are for the other buttons,
 Start, Select, B, A
 
 */

- (IBAction)upButton:(id)sender
{
    NSLog(@"User clicked up arrow!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[2] = 1;
}
- (IBAction)downButton:(id)sender
{
    NSLog(@"User clicked down arrow!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[3] = 1;
}
- (IBAction)leftButton:(id)sender
{
    NSLog(@"User clicked left arrow!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[1] = 1;
}
- (IBAction)rightButton:(id)sender
{
    NSLog(@"User clicked right arrow!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[0] = 1;
}
- (IBAction)AButton:(id)sender
{
    NSLog(@"User clicked 'A' button!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[4] = 1;
}
- (IBAction)BButton:(id)sender
{
    NSLog(@"User clicked 'B' button!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[5] = 1;
}
- (IBAction)startButton:(id)sender
{
    NSLog(@"User clicked 'Start' button!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[7] = 1;
}
- (IBAction)selectButton:(id)sender
{
    NSLog(@"User clicked 'Select' button!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[6] = 1;
}
- (IBAction)stopButton:(id)sender
{
    // Save state, then return
#warning The app crashes when clicking this button
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)run:(id)sender
{
    [emulator runRom];
}

@end
