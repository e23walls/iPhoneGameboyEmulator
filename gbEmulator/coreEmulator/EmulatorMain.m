//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "EmulatorMain.h"
#include <sys/stat.h>

const int k = 1024;
const int ramSize = 64 * k; // For readability purposes; an unsigned short spans the same set of integers.
const int biosSize = 256;

// At some point, it'd be nice if the print statements didn't sign-extend negative values out to 32-bits.
// To fix this, simply AND the value being printed with 0xFF, if it's one byte, and 0xFFFF if it's two bytes.
// Similarly, printing 2 byte values needs to have 4 hex digits display at once, not just 2.

@interface EmulatorMain ()
{
    bool incrementPC;
    int8_t interruptsEnabled;
}

@property char * ram;
@property Rom * currentRom;
@property RomState * currentState;
/*
 Keys:
 [Start][Select][B][A][Down][Up][Left][Right]
 */
@property int * keys;
@property int8_t buttons;

@end

void (^executeInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^setKeysInMemory)(char *, int);
extern void (^enableInterrupts)(bool, char *);
extern void (^interruptServiceRoutineCaller)(RomState *, char *, bool *, int8_t *);
extern const unsigned short interruptFlagAddress;
extern const unsigned short interruptEnableRegister;

@implementation EmulatorMain

- (EmulatorMain *) initWithRom:(Rom *) theRom
{
    self = [super init];
    if (self != nil)
    {
        incrementPC = true;
        self.buttons = 0b00000000;
        self.keys = calloc(8, sizeof(int));
        self.currentRom = theRom;
        self.ram = (char *)malloc(ramSize * sizeof(char));
        char start[] = {0xce, 0x01, 0x00, 0x50, 0xde, 0x00, 0x60, 0xcd, 0x34, 0x83, 0xdf, 0x04, 0xde, 0xd9, 0x00, 0xf1, 0xee, 0xc1, 0x7f, 0xcd, 0x1d, 0xf3, 0xc1, 0x9c, 0x1d, 0xcd, 0xc1, 0x88, 0x88, 0xc1, 0x03, 0x1f, 0xb8, 0xee, 0xfb, 0xfe, 0xde, 0xef, 0x7f, 0xe5, 0x32, 0x6a, 0xff, 0x32, 0x69, 0xff, 0xec, 0x84, 0x01, 0xcb, 0xdf, 0x0c, 0xee, 0x27, 0xff, 0xf9, 0xf7, 0xe5, 0xec, 0xdd, 0xdc, 0xfa, 0xdf, 0x06, 0xc1, 0xe6, 0x15, 0xef, 0x66, 0xde, 0xd0, 0x66, 0xf1, 0xf3, 0xc2, 0xd7, 0xf7, 0xcd, 0xf2, 0xdf, 0x06, 0xd1, 0xf0, 0xe7, 0x0c, 0x98, 0xc1, 0x9b, 0xa8, 0x1f, 0xbd, 0xc1, 0x6e, 0x1f, 0xbf, 0xfb, 0xe1, 0xfd, 0xf1, 0xf3, 0x0f, 0xbb, 0x01, 0x6f, 0xdf, 0x05, 0xf2, 0xdf, 0x08, 0xe2, 0xdf, 0x0d, 0xf1, 0xec, 0xdb, 0x83, 0xe1, 0x7c, 0x01, 0x9d, 0xd7, 0xf9, 0xe1, 0x3e, 0x01, 0x9b, 0xdf, 0xf9, 0x84, 0x1d, 0xf3, 0xc1, 0x78, 0x1d, 0x0f, 0xbd, 0x6f, 0x1f, 0xbd, 0xea, 0xdf, 0x2d, 0xfa, 0xdf, 0xb0, 0xe9, 0xdf, 0xe7, 0x34, 0xb0, 0xf9, 0xfb, 0x3a, 0x34, 0xee, 0xe8, 0x3e, 0x34, 0xee, 0xe8, 0xfa, 0xdf, 0x0a, 0xdd, 0xdc, 0xdd, 0xdc, 0x36, 0x31, 0x12, 0x99, 0x99, 0x33, 0xf2, 0xff, 0xf4, 0xfc, 0x8c, 0xff, 0x7c, 0xff, 0xf3, 0xff, 0xf2, 0xff, 0xf7, 0xee, 0xe0, 0x77, 0x76, 0xff, 0xf1, 0x23, 0x33, 0x91, 0x19, 0x22, 0x22, 0x26, 0x66, 0x44, 0x44, 0x98, 0x9c, 0x91, 0xf1, 0x13, 0x33, 0x22, 0x23, 0x66, 0x60, 0x44, 0x46, 0xcc, 0xc1, 0xc3, 0xbd, 0x46, 0x5a, 0x46, 0x5a, 0xbd, 0xc3, 0xde, 0xfb, 0xfe, 0xee, 0x57, 0xff, 0xe5, 0xec, 0x41, 0xdf, 0x01, 0xdc, 0x82, 0x01, 0xcb, 0xdf, 0x0a, 0xf9, 0xe6, 0x87, 0x79, 0xdc, 0xfa, 0xdf, 0x04, 0x79, 0xdf, 0x01, 0xc1, 0xfe, 0x1f, 0xaf};
        
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
            printf("Warning: EOF was reached before RAM was filled.\n");
        }
        else
        {
            printf("As expected, EOF was not reached before end of RAM.\n");
        }
        fclose(romFileHandler);
        NSLog(@"Setting up the ROM initial state...");
        self.currentState = [[RomState alloc] init];
        enableInterrupts(false, self.ram);
        NSLog(@"Loading BIOS into RAM...");
        for (int i = 0; i < biosSize; i++)
        {
            self.ram[i] = start[i] ^ 0xff;
        }
    }
    else
    {
        printf("Error! Couldn't allocate memory for emulator.\n");
    }
    return self;
}

- (void) dealloc
{
    free(self.ram);
}

- (void) runRom
{
    PRINTDBG("\nRunning rom '%s'\n\n", [[self.currentRom romName] cStringUsingEncoding:NSUTF8StringEncoding]);
    interruptsEnabled = 0;
    // This is probably necessary...
    self.ram[interruptFlagAddress] = 0;
    while ([self.currentState getPC] < ramSize)
    {
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
        if (incrementPC)
        {
            [self.currentState incrementPC];
        }
        printf("Before:\n");
        [self.currentState printState:self.ram];
        // This could be slightly off because we don't know the
        // length of the current instruction at this point. It will
        // always be pointing 1 byte ahead of the current instruction.
        // If the current instruction is 1 byte, it should be correct.
        PRINTDBG("\nPC = 0x%02x\n", [self.currentState getPC]);
        incrementPC = true;
        if ([self interruptOccurred])
        {
            PRINTDBG("An interrupt has occurred!\n");
            interruptServiceRoutineCaller(self.currentState, self.ram, &incrementPC, &interruptsEnabled);
        }
        executeInstruction(self.currentState, self.ram, &incrementPC, &interruptsEnabled);
        printf("After:\n");
        [self.currentState printState:self.ram];
        printf("\n\n");
    }
}
- (void) setInterruptFlag:(int8_t) bit
{
    assert(bit <= 5 && bit >= 0);
    self.ram[interruptFlagAddress] |= (1 << bit);
    PRINTDBG("Set IF flag bit #%i\n", bit);
}
- (bool) interruptOccurred
{
    return (bool)(self.ram[interruptEnableRegister] & self.ram[interruptFlagAddress]);
}
// Toggle bit corresponding to the specified key press, and write 1
// to corresponding interrupt flag (bit 4)
- (void) pressedKey:(int8_t)offset
{
    assert(offset >= 0 && offset <= 7);
    self.buttons ^= 1 << offset;
    [self setInterruptFlag:JOYPAD_PRESS];
}
- (void) printKeys
{
    for (int8_t i = 0; i < 8; i++)
    {
        printf("buttons[%i] = %i\n", i, self.buttons & (1 << i));
    }
}

@end
