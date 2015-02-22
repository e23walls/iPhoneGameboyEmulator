//
//  emulatorMain.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "rom.h"
#import "romState.h"

#define MYDEBUG

#ifdef MYDEBUG
#define PRINTDBG(...) printf(__VA_ARGS__)
#else
#define PRINTDBG(...) ;
#endif

enum interruptFlagBitNames
{
    VERTICAL_BLANK,
    LCD_STATUS_TRIGGERS,
    TIMER_OVERFLOW,
    SERIAL_LINK,
    JOYPAD_PRESS
};

@interface emulatorMain : NSObject

- (emulatorMain *) initWithRom: (rom *) theRom;
- (void) runRom;
- (void) pressedKey:(int8_t)offset;
- (void) printKeys;

@end
