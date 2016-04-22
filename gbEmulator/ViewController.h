//
//  ViewController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rom.h"
#import "EmulatorMain.h"

@class EmulatorMain;

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView * imageView;
    IBOutlet UIButton * middle;
    IBOutlet UILabel * romTitleLabel;
    IBOutlet UIButton * runButton;
    IBOutlet UIButton * leftButton;
    IBOutlet UIButton * upButton;
    IBOutlet UIButton * rightButton;
    IBOutlet UIButton * downButton;
    IBOutlet UIButton * aButton;
    IBOutlet UIButton * bButton;
    IBOutlet UIButton * startButton;
    IBOutlet UIButton * selectButton;
    EmulatorMain * emulator;
}

- (ViewController *) init;
- (ViewController *) initWithCurrentRom:(Rom *) theRom;

- (IBAction)upButtonDown:(id)sender;
- (IBAction)downButtonDown:(id)sender;
- (IBAction)leftButtonDown:(id)sender;
- (IBAction)rightButtonDown:(id)sender;
- (IBAction)AButtonDown:(id)sender;
- (IBAction)BButtonDown:(id)sender;
- (IBAction)selectButtonDown:(id)sender;
- (IBAction)startButtonDown:(id)sender;
- (IBAction)upButtonUp:(id)sender;
- (IBAction)downButtonUp:(id)sender;
- (IBAction)leftButtonUp:(id)sender;
- (IBAction)rightButtonUp:(id)sender;
- (IBAction)AButtonUp:(id)sender;
- (IBAction)BButtonUp:(id)sender;
- (IBAction)selectButtonUp:(id)sender;
- (IBAction)startButtonUp:(id)sender;
- (IBAction)stopButton:(id)sender;
- (IBAction)run:(id)sender;
- (void) changeImageView:(UIImage *)image;
- (void) update;

@end