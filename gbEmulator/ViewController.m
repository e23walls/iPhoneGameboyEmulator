//
//  ViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//
// Store ROMs in /var/mobile/Media/ROMs/GAMEBOY/ -- if doesn't exist, create the directory (may also need to create ROMs)

#import "ViewController.h"
#import "emulatorMain.h"

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
    emulatorMain * emulator = [[emulatorMain alloc] initWithRom:currentRom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upButton:(id)sender
{
    NSLog(@"User clicked up arrow!\n");
}
- (IBAction)downButton:(id)sender
{
    NSLog(@"User clicked down arrow!\n");
}
- (IBAction)leftButton:(id)sender
{
    NSLog(@"User clicked left arrow!\n");
}
- (IBAction)rightButton:(id)sender
{
    NSLog(@"User clicked right arrow!\n");
}
- (IBAction)AButton:(id)sender
{
    NSLog(@"User clicked 'A' button!\n");
}
- (IBAction)BButton:(id)sender
{
    NSLog(@"User clicked 'B' button!\n");
}
- (IBAction)startButton:(id)sender
{
    NSLog(@"User clicked 'Start' button!\n");
}
- (IBAction)selectButton:(id)sender
{
    NSLog(@"User clicked 'Select' button!\n");
}
- (IBAction)stopButton:(id)sender
{
    // Save state, then return
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
