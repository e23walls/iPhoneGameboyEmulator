//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "emulatorMain.h"
#include <sys/stat.h>

const int k = 1024;
const int ramSize = 64 * k; // For readability purposes; an unsigned short spans the same set of integers.
const int biosSize = 256;

// At some point, it'd be nice if the print statements didn't sign-extend negative values out to 32-bits.
// To fix this, simply AND the value being printed with 0xFF, if it's one byte, and 0xFFFF if it's two bytes.
// Similarly, printing 2 byte values needs to have 4 hex digits display at once, not just 2.

@interface emulatorMain ()
{
    bool incrementPC;
    int8_t interruptsEnabled;
}

@property char * ram;
@property rom * currentRom;
@property romState * currentState;

@end

extern void (^executeInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xcb0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^setKeysInMemory)(char *, int);
extern void (^enableInterrupts)(bool, char *);

@implementation emulatorMain

- (emulatorMain *) initWithRom:(rom *) theRom
{
    self = [super init];
    if (self != nil)
    {
        incrementPC = true;
        self.buttons = 0b00000000;
        self.keys = calloc(8, sizeof(int));
        self.currentRom = theRom;
        self.ram = (char *)malloc(ramSize * sizeof(char));
        char bios[] = {0x31, 0xfe, 0xff, 0xaf, 0x21, 0xff, 0x9f, 0x32, 0xcb, 0x7c, 0x20, 0xfb, 0x21, 0x26, \
            0xff, 0x0e, 0x11, 0x3e, 0x80, 0x32, 0xe2, 0x0c, 0x3e, 0xf3, 0xe2, 0x32, 0x3e, 0x77, 0x77, 0x3e, 0xfc, \
            0xe0, 0x47, 0x11, 0x04, 0x01, 0x21, 0x10, 0x80, 0x1a, 0xcd, 0x95, 0x00, 0xcd, 0x96, 0x00, 0x13, 0x7b, \
            0xfe, 0x34, 0x20, 0xf3, 0x11, 0xd8, 0x00, 0x06, 0x08, 0x1a, 0x13, 0x22, 0x23, 0x05, 0x20, 0xf9, 0x3e, \
            0x19, 0xea, 0x10, 0x99, 0x21, 0x2f, 0x99, 0x0e, 0x0c, 0x3d, 0x28, 0x08, 0x32, 0x0d, 0x20, 0xf9, 0x2e, \
            0x0f, 0x18, 0xf3, 0x67, 0x3e, 0x64, 0x57, 0xe0, 0x42, 0x3e, 0x91, 0xe0, 0x40, 0x04, 0x1e, 0x02, 0x0e, \
            0x0c, 0xf0, 0x44, 0xfe, 0x90, 0x20, 0xfa, 0x0d, 0x20, 0xf7, 0x1d, 0x20, 0xf2, 0x0e, 0x13, 0x24, 0x7c, \
            0x1e, 0x83, 0xfe, 0x62, 0x28, 0x06, 0x1e, 0xc1, 0xfe, 0x64, 0x20, 0x06, 0x7b, 0xe2, 0x0c, 0x3e, 0x87, \
            0xe2, 0xf0, 0x42, 0x90, 0xe0, 0x42, 0x15, 0x20, 0xd2, 0x05, 0x20, 0x4f, 0x16, 0x20, 0x18, 0xcb, 0x4f, \
            0x06, 0x04, 0xc5, 0xcb, 0x11, 0x17, 0xc1, 0xcb, 0x11, 0x17, 0x05, 0x20, 0xf5, 0x22, 0x23, 0x22, 0x23, \
            0xc9, 0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0c, 0x00, 0x0d, \
            0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e, 0xdc, 0xcc, 0x6e, 0xe6, 0xdd, 0xdd, 0xd9, 0x99, 0xbb, \
            0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc, 0xdd, 0xdc, 0x99, 0x9f, 0xbb, 0xb9, 0x33, 0x3e, 0x3c, 0x42, \
            0xb9, 0xa5, 0xb9, 0xa5, 0x42, 0x3c, 0x21, 0x04, 0x01, 0x11, 0xa8, 0x00, 0x1a, 0x13, 0xbe, 0x20, 0xfe, \
            0x23, 0x7d, 0xfe, 0x34, 0x20, 0xf5, 0x06, 0x19, 0x78, 0x86, 0x23, 0x05, 0x20, 0xfb, 0x86, 0x20, 0xfe, \
            0x3e, 0x01, 0xe0, 0x50};
        
        // Load the ROM file into RAM
        
        FILE * romFileHandler = fopen([self.currentRom.fullPath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
        if (romFileHandler == NULL)
        {
            printf("Some error occurred when opening the ROM.\n");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not load ROM!" \
                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            [alert show];
        }
        NSLog(@"Loading the ROM '%@'\nLocation: %@\n", self.currentRom.romName, self.currentRom.fullPath);
        int ch = 0;
        BOOL hitEOF = NO;
        int counter = 0;
        ch = fgetc(romFileHandler);
        while (counter < ramSize)
        {
            if (ch == EOF)
            {
                hitEOF = YES;
                ch = 0;
                printf("HIT EOF!\n");
            }
            self.ram[counter] = (unsigned char)ch;
            counter++;
            if (hitEOF == NO)
            {
                ch = fgetc(romFileHandler);
            }
        }
        NSLog(@"Byte counter reached value: %i\n", counter);
        if (hitEOF == YES)
        {
            printf("Warning: EOF was reached before RAM was filled.");
        }
        else
        {
            printf("As expected, EOF was not reached before end of RAM.");
        }
        fclose(romFileHandler);
        NSLog(@"Setting up the ROM initial state...");
        self.currentState = [[romState alloc] init];
        enableInterrupts(false, self.ram);
        NSLog(@"Loading BIOS into RAM...");
        for (int i = 0; i < biosSize; i++)
        {
            self.ram[i] = bios[i];
        }
    }
    else
    {
        printf("Error! Couldn't allocate memory for emulator.\n");
    }
    return self;
}

- (void) runRom
{
    interruptsEnabled = 0;
    while ([self.currentState getPC] < ramSize)
    {
        PRINTDBG("PC = 0x%02x\n", [self.currentState getPC]);
        incrementPC = true;
        // For when enabling interrupts doesn't take effect until after the next instruction.
        // Otherwise, the instruction can directly call the method enableInterrupts
        if (interruptsEnabled == 2)
        {
            enableInterrupts(true, self.ram);
            interruptsEnabled = 0;
        }
        else if (interruptsEnabled == 1)
        {
            interruptsEnabled++;
        }
        else if (interruptsEnabled == -2)
        {
            enableInterrupts(false, self.ram);
            interruptsEnabled = 0;
        }
        else if (interruptsEnabled == -1)
        {
            interruptsEnabled--;
        }
        setKeysInMemory(self.ram, self.buttons);
        executeInstruction(self.currentState, self.ram, &incrementPC, &interruptsEnabled);
        if (incrementPC)
        {
            [self.currentState incrementPC];
        }
    }
}

@end
