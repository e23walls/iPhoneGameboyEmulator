//
//  ViewController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rom.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView * imageView;
    IBOutlet UILabel * romTitleLabel;
}

- (ViewController *) init;
- (ViewController *) initWithCurrentRom:(rom *) theRom;

- (IBAction)upButton:(id)sender;
- (IBAction)downButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)rightButton:(id)sender;
- (IBAction)AButton:(id)sender;
- (IBAction)BButton:(id)sender;
- (IBAction)selectButton:(id)sender;
- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;

@end
