//
//  ViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//
// Store ROMs in /var/mobile/Media/ROMs/GAMEBOY/ -- if doesn't exist, create the directory (may also need to create ROMs)

#import "ViewController.h"

// 0 = off; 1 = on
#define PRINTOUTKEYS 0

#if PRINTOUTKEYS
#define PRINTKEYS() [emulator printKeys];
#else
#define PRINTKEYS() ;
#endif

// DO NOT REFINE!
#define NUMBEROFBUTTONS 8

@interface ViewController ()

@end

@implementation ViewController

static Rom * currentRom;

- (ViewController *) init
{
    self = [super init];
    return self;
}
- (ViewController *) initWithCurrentRom:(Rom *)theRom
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
    emulator = [[EmulatorMain alloc] initWithRom:currentRom];
    [emulator addObserver:self];
    [self setupImage];
//    [self romNotRunning];
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
 
 For emulator.buttons, we'll say that the lower 4 bits are for the arrows,
 D, U, L, R
 And the top 4 bits are for the other buttons,
 Start, Select, B, A
 
 */

enum KeyNames
{
    RIGHT,
    LEFT,
    UP,
    DOWN,
    A,
    B,
    SELECT,
    START
};

- (IBAction)upButtonDown:(id)sender
{
    NSLog(@"User pressed 'Up' button!\n");
    // or (0000 0100)2 with [0xff00]
    [emulator pressedKey:UP];
    PRINTKEYS();
}
- (IBAction)downButtonDown:(id)sender
{
    NSLog(@"User pressed 'Down' button!\n");
    // or (0000 1000)2 with [0xff00]
    [emulator pressedKey:DOWN];
    PRINTKEYS();
}
- (IBAction)leftButtonDown:(id)sender
{
    NSLog(@"User pressed 'Left' button!\n");
    // or (0000 0010)2 with [0xff00]
    [emulator pressedKey:LEFT];
    PRINTKEYS();
}
- (IBAction)rightButtonDown:(id)sender
{
    NSLog(@"User pressed 'Right' button!\n");
    // or (0000 0001)2 with [0xff00]
    [emulator pressedKey:RIGHT];
    PRINTKEYS();
}
- (IBAction)AButtonDown:(id)sender
{
    NSLog(@"User pressed 'A' button!\n");
    // or (0000 0001)2 with [0xff00]
    [emulator pressedKey:A];
    PRINTKEYS();
}
- (IBAction)BButtonDown:(id)sender
{
    NSLog(@"User pressed 'B' button!\n");
    // or (0000 0010)2 with [0xff00]
    [emulator pressedKey:B];
    PRINTKEYS();
}
- (IBAction)startButtonDown:(id)sender
{
    NSLog(@"User pressed 'Start' button!\n");
    // or (0000 1000)2 with [0xff00]
    [emulator pressedKey:START];
    PRINTKEYS();
}
- (IBAction)selectButtonDown:(id)sender
{
    NSLog(@"User pressed 'Select' button!\n");
    // or (0000 0100)2 with [0xff00]
    [emulator pressedKey:SELECT];
    PRINTKEYS();
}
- (IBAction)upButtonUp:(id)sender
{
    NSLog(@"User released 'Up' button!\n");
    // or (0000 0100)2 with [0xff00]
    [emulator pressedKey:UP];
    PRINTKEYS();
}
- (IBAction)downButtonUp:(id)sender
{
    NSLog(@"User released 'Down' button!\n");
    // or (0000 1000)2 with [0xff00]
    [emulator pressedKey:DOWN];
    PRINTKEYS();
}
- (IBAction)leftButtonUp:(id)sender
{
    NSLog(@"User released 'Left' button!\n");
    // or (0000 0010)2 with [0xff00]
    [emulator pressedKey:LEFT];
    PRINTKEYS();
}
- (IBAction)rightButtonUp:(id)sender
{
    NSLog(@"User released 'Right' button!\n");
    // or (0000 0001)2 with [0xff00]
    [emulator pressedKey:RIGHT];
    PRINTKEYS();
}
- (IBAction)AButtonUp:(id)sender
{
    NSLog(@"User released 'A' button!\n");
    // or (0000 0001)2 with [0xff00]
    [emulator pressedKey:A];
    PRINTKEYS();
}
- (IBAction)BButtonUp:(id)sender
{
    NSLog(@"User released 'B' button!\n");
    // or (0000 0010)2 with [0xff00]
    [emulator pressedKey:B];
    PRINTKEYS();
}
- (IBAction)startButtonUp:(id)sender
{
    NSLog(@"User released 'Start' button!\n");
    // or (0000 1000)2 with [0xff00]
    [emulator pressedKey:START];
    PRINTKEYS();
}
- (IBAction)selectButtonUp:(id)sender
{
    NSLog(@"User released 'Select' button!\n");
    // or (0000 0100)2 with [0xff00]
    [emulator pressedKey:SELECT];
    PRINTKEYS();
}
- (IBAction)stopButton:(id)sender
{
    // Save state, then return
    printf("Returning to previous view controller\n");
    [self.navigationController popToRootViewControllerAnimated:YES];
    printf("Hiding navigation bar\n");
    [self.navigationController setNavigationBarHidden:NO];

    // Save the ROM state, and then stop it.
    [emulator saveState];
    [emulator stopRom];
}

- (IBAction)run:(id)sender
{
    // Rom must run in a separate thread so that key pad input can be obtained.
    NSThread* romThread = [[NSThread alloc] initWithTarget:emulator
                                                  selector:@selector(runRom)
                                                    object:nil];
    if ([emulator isRunning] == false)
    {
        [self romRunning:YES];
        [romThread start];
    }
    else
    {
        [self romRunning:NO];
        [emulator pauseRom];
    }
}

- (void) changeImageView:(UIImage *)image
{
    UIImage * i = [emulator getScreen];
    [imageView setImage:i];
}

- (void) update
{
//    PRINTDBG("ViewController update...\n");
    [imageView setImage:[emulator updateScreen:[imageView image]]];
    [imageView setNeedsDisplay];
}

// Set the image/screen to be all black at first.
- (void) setupImage
{
    CGSize imageSize = CGSizeMake(160, 144);
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageView setImage:image];
}

- (void) romRunning:(BOOL)isRunning
{
    if (isRunning)
    {
        [runButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.view setNeedsDisplay];
    }
    else
    {
        [runButton setTitle:@"Run" forState:UIControlStateNormal];
        [self.view setNeedsDisplay];
    }
    [leftButton setEnabled:isRunning];
    [rightButton setEnabled:isRunning];
    [upButton setEnabled:isRunning];
    [downButton setEnabled:isRunning];
    [aButton setEnabled:isRunning];
    [bButton setEnabled:isRunning];
    [selectButton setEnabled:isRunning];
    [startButton setEnabled:isRunning];
    [middle setEnabled:isRunning];
}

@end
