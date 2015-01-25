//
//  emulatorMain.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rom.h"
#import "romState.h"

@interface emulatorMain : NSObject

/*
 Keys:
 [Start][Select][B][A][Down][Up][Left][Right]
 */
@property int * keys;
- (emulatorMain *) initWithRom: (rom *) theRom;
- (void) runRom;
- (void) executeInstruction:(romState *) state;

@end
