//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "emulatorMain.h"
#include <sys/stat.h>

#define MYDEBUG

#ifdef MYDEBUG
#define PRINTDBG(...) printf(__VA_ARGS__)
#else
#define PRINTDBG(...) ;
#endif

const int k = 1024;
const int ramSize = 64 * k; // For readability purposes; an unsigned short spans the same set of integers.
const int biosSize = 256;

// At some point, it'd be nice if the print statements didn't sign-extend negative values out to 32-bits.
// To fix this, simply AND the value being printed with 0xFF, if it's one byte, and 0xFFFF if it's two bytes.
// Similarly, printing 2 byte values needs to have 4 hex digits display at once, not just 2.

@interface emulatorMain ()
{
    bool incrementPC;
    bool interruptsEnabled;
}

@property char * ram;
@property rom * currentRom;
@property romState * currentState;

@end

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
            NSLog(@"Warning: EOF was reached before RAM was filled.");
        }
        else
        {
            NSLog(@"As expected, EOF was not reached before end of RAM.");
        }
        
        fclose(romFileHandler);
        NSLog(@"Setting up the ROM initial state...");
        self.currentState = [[romState alloc] init];
        [self enableInterrupts:false];
        NSLog(@"Loading BIOS into RAM...");
        for (int i = 0; i < biosSize; i++)
        {
            self.ram[i] = bios[i];
        }
    }
    else
    {
        NSLog(@"Error! Couldn't allocate memory for emulator\n");
    }
    return self;
}

- (void) enableInterrupts:(bool)maybe
{
    if (maybe == true)
    {
        self.ram[0x0ffff] = 1;
    }
    else
    {
        self.ram[0x0ffff] = 0;
    }
}

- (void) runRom
{
#warning Something here/after here is causing a crash in the simulator, but not on a real device. Probably related to view controller transition.
    while ([self.currentState getPC] < ramSize)
    {
        PRINTDBG("PC = 0x%02x\n", [self.currentState getPC]);
        incrementPC = true;
        [self executeInstruction];
        if (incrementPC)
        {
            [self.currentState incrementPC];
        }
    }
}

#pragma mark - Regular instruction processing

- (void) executeInstruction
{
    unsigned char currentInstruction = self.ram[[self.currentState getPC]];
    switch ((currentInstruction & 0xF0) >> 4) {
        case 0:
            [self execute0x0Instruction:currentInstruction];
            break;
        case 1:
            [self execute0x1Instruction:currentInstruction];
            break;
        case 2:
            [self execute0x2Instruction:currentInstruction];
            break;
        case 3:
            [self execute0x3Instruction:currentInstruction];
            break;
        case 4:
            [self execute0x4Instruction:currentInstruction];
            break;
        case 5:
            [self execute0x5Instruction:currentInstruction];
            break;
        case 6:
            [self execute0x6Instruction:currentInstruction];
            break;
        case 7:
            [self execute0x7Instruction:currentInstruction];
            break;
        case 8:
            [self execute0x8Instruction:currentInstruction];
            break;
        case 9:
            [self execute0x9Instruction:currentInstruction];
            break;
        case 0xA:
            [self execute0xAInstruction:currentInstruction];
            break;
        case 0xB:
            [self execute0xBInstruction:currentInstruction];
            break;
        case 0xC:
            [self execute0xCInstruction:currentInstruction];
            break;
        case 0xD:
            [self execute0xDInstruction:currentInstruction];
            break;
        case 0xE:
            [self execute0xEInstruction:currentInstruction];
            break;
        case 0xF:
            [self execute0xFInstruction:currentInstruction];
            break;
    }
}

- (void) execute0x0Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    int prev_int = 0;
    int other_int = 0;
    short prev_short = 0;
    int8_t A = 0;
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // No-op
            PRINTDBG("0x%02x -- no-op\n", currentInstruction);
            break;
        case 1:
            // LD BC, d16 -- Load 16-bit data into registers BC
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | (self.ram[[self.currentState getPC]] & 0x00ff);
            [self.currentState incrementPC];
            [self.currentState setBC_big:d16];
            PRINTDBG("0x%02x -- LD BC, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD BC, A -- Load A into (BC)
            // Cast to unsigned short for case where the number is negative, since it should
            // be interpreted unsigned, but becomes too large a value. -1 should be interpreted as RAMSIZE-1
            self.ram[(unsigned short)[self.currentState getBC_big]] = [self.currentState getA];
            PRINTDBG("0x%02x -- LD (BC), A -- A is now %d\n", currentInstruction, [self.currentState getA]);
            break;
        case 3:
            // INC BC -- increment BC
            [self.currentState setBC_big:([self.currentState getBC_big] + 1)];
            PRINTDBG("0x%02x -- INC BC\n", currentInstruction);
            break;
        case 4:
            // INC B -- increment B and set flags
            prev = [self.currentState getB];
            [self.currentState setB:([self.currentState getB] + 1)];
            [self.currentState setFlags:([self.currentState getB] == 0)
                                    N:false
                                    H:(prev > [self.currentState getB])
                                    C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC B\n", currentInstruction);
            break;
        case 5:
            // DEC B -- decrement B and set flags
            prev = [self.currentState getB];
            [self.currentState setB:([self.currentState getB] - 1)];
            [self.currentState setFlags:([self.currentState getB] == 0)
                                      N:true
                                      H:(prev < [self.currentState getB])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- DEC B\n", currentInstruction);
            break;
        case 6:
            // LD B, d8 -- load following 8-bit data into B
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setB:d8];
            PRINTDBG("0x%02x -- LD B, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // RLCA -- Rotate A left; C = bit 7, A'[0] = A[7]
            A = [self.currentState getA];
            C = (bool)([self.currentState getA] & 0b10000000);
            [self.currentState setA:([self.currentState getA] << 1)];
            // Set LSb of A to its previous MSb
            C ? [self.currentState setA:([self.currentState getA] | 1)] :
                [self.currentState setA:([self.currentState getA] & 0b11111110)];
            Z = [self.currentState getA] == 0;
            [self.currentState setFlags:false
                                      N:false
                                      H:false
                                      C:C];
            PRINTDBG("0x%02x -- RLCA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
            break;
        case 8:
            // LD (a16), SP -- put (SP) at address a16
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | (self.ram[[self.currentState getPC]] & 0xff);
            [self.currentState incrementPC];
            prev_short =  (self.ram[(unsigned short)(d16+1)] << 8) | (self.ram[(unsigned short)d16] & 0x0ff);
            self.ram[(unsigned short)d16] = self.ram[(unsigned short)([self.currentState getSP]+1)];
            self.ram[(unsigned short)(d16+1)] = self.ram[[self.currentState getSP]];
            PRINTDBG("0x%02x -- LD (a16), SP -- put (SP = 0x%02x) at [d16 = 0x%02x] -- [SP] is 0x%02x -- [d16] was 0x%02x; now 0x%02x\n", \
                        currentInstruction, [self.currentState getSP], d16, \
                        (self.ram[[self.currentState getSP]] & 0x0ff) | (self.ram[[self.currentState getSP]+1] << 8), \
                        prev_short, (self.ram[(unsigned short)(d16+1)] & 0x0ff) | (self.ram[(unsigned short)d16] << 8));
            break;
        case 9:
            // ADD HL,BC -- add BC to HL
            // H == carry from bit 11
            // C == carry from bit 15
            prev_int = [self.currentState getHL_big];
            prev_short = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getBC_big]+[self.currentState getHL_big])];
            other_int = prev_short + [self.currentState getBC_big];
            Z = [self.currentState getZFlag];
            C = ((other_int & 0xFFFF0000) ^ (prev_int & 0xFFFF0000)) != 0;
            H = (([self.currentState getHL_big] & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            [self.currentState setFlags:Z
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD HL,BC -- add BC (%i) and HL (%i) = %i\n", currentInstruction, \
                   [self.currentState getBC_big], prev_short, [self.currentState getHL_big]);
            break;
        case 0xA:
            // LD A,(BC) -- load (BC) into A
            [self.currentState setA:self.ram[(unsigned short)[self.currentState getBC_big]]];
            PRINTDBG("0x%02x -- LD A,(BC) -- load (BC == %i -> %i) into A\n", currentInstruction, \
                   [self.currentState getBC_big], (int)self.ram[(unsigned short)[self.currentState getBC_big]]);
            break;
        case 0xB:
            // DEC BC -- decrement BC
            prev_int = [self.currentState getBC_big];
            [self.currentState setBC_big:([self.currentState getBC_big] - 1)];
            PRINTDBG("0x%02x -- DEC BC -- BC was %i; BC is now %i\n", currentInstruction, \
                   prev_int, [self.currentState getBC_big]);
            break;
        case 0xC:
            // INC C -- increment C
            prev = [self.currentState getC];
            [self.currentState setC:([self.currentState getC] + 1)];
            Z = [self.currentState getC] == 0;
            H = [self.currentState getC] < prev;
            [self.currentState setFlags:Z
                                      N:false
                                      H:H
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- INC C -- C was %i; C is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getC]);
            break;
        case 0xD:
            // DEC C -- decrement C
            prev = [self.currentState getC];
            [self.currentState setC:([self.currentState getC] - 1)];
            Z = [self.currentState getC] == 0;
            H = [self.currentState getC] > prev;
            [self.currentState setFlags:Z
                                      N:true
                                      H:H
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- DEC C -- C was %i; C is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getC]);
            break;
        case 0xE:
            // LD C, d8 -- load immediate 8-bit data into C
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setC:d8];
            PRINTDBG("0x%02x -- LD C, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // RRCA -- rotate A right
            A = [self.currentState getA];
            temp = [self.currentState getCFlag];
            C = (bool)([self.currentState getA] & 0b00000001);
            [self.currentState setA:([self.currentState getA] >> 1)];
            // Set MSb of A to its previous LSb
            C ? [self.currentState setA:([self.currentState getA] | 0b10000000)] :
            [self.currentState setA:([self.currentState getA] & 0b01111111)];
            [self.currentState setFlags:false
                                      N:false
                                      H:false
                                      C:C];
            PRINTDBG("0x%02x -- RRCA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
            break;
    }
}
- (void) execute0x1Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    int prev_int = 0;
    short prev_short = 0;
    int other_int = 0;
    int8_t A = 0;
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    int8_t previousButtons = self.buttons;
    switch (currentInstruction & 0x0F) {
        case 0:
            // STOP
            // Wait for button press before changing processor and screen
#warning Figure this out
            while ((self.buttons ^ previousButtons) == 0)
            {/* Do nothing but wait */}
            PRINTDBG("0x%02x -- STOP\n", currentInstruction);
            break;
        case 1:
            // LD DE, d16 -- Load d16 into DE
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | (self.ram[[self.currentState getPC]] & 0x0ff);
            [self.currentState incrementPC];
            [self.currentState setDE_big:d16];
            PRINTDBG("0x%02x -- LD DE, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD (DE), A -- put A into (DE)
            self.ram[(unsigned short)[self.currentState getDE_big]] = [self.currentState getA];
            PRINTDBG("0x%02x -- LD (DE), A -- A = %i\n", currentInstruction, (int)[self.currentState getA]);
            break;
        case 3:
            // INC DE -- Increment DE
            [self.currentState setDE_big:([self.currentState getDE_big] + 1)];
            PRINTDBG("0x%02x -- INC DE\n", currentInstruction);
            break;
        case 4:
            // INC D -- Increment D
            prev = [self.currentState getD];
            [self.currentState setD:([self.currentState getD] + 1)];
            [self.currentState setFlags:([self.currentState getD] == 0)
                                      N:false
                                      H:(prev > [self.currentState getD])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC D\n", currentInstruction);
            break;
        case 5:
            // DEC D -- Decrement D
            prev = [self.currentState getD];
            [self.currentState setD:([self.currentState getD] - 1)];
            [self.currentState setFlags:([self.currentState getD] == 0)
                                      N:true
                                      H:(prev < [self.currentState getD])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- DEC D\n", currentInstruction);
            break;
        case 6:
            // LD D, d8 -- load 8-bit immediate value into D
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setD:d8];
            PRINTDBG("0x%02x -- LD D, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // RLA -- Rotate A left through carry flag -- Does this mean take previous C value for A[0]? Else, what's
            // the difference between it and the RLCA instruction?
            A = [self.currentState getA];
            temp = [self.currentState getCFlag];
            C = (bool)([self.currentState getA] & 0b10000000);
            [self.currentState setA:([self.currentState getA] << 1)];
            // Set LSb of A to its previous C-value
            temp ? [self.currentState setA:([self.currentState getA] | 1)] :
            [self.currentState setA:([self.currentState getA] & 0b11111110)];
            [self.currentState setFlags:false
                                      N:false
                                      H:false
                                      C:C];
            PRINTDBG("0x%02x -- RLA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
            break;
        case 8:
            // JR r8 (8-bit signed data, added to PC)
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState addToPC:d8];
            PRINTDBG("0x%02x -- JR r8 (r8 = %d) -- PC is now 0x%02x\n",
                   currentInstruction, (int)d8, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 9:
            // ADD HL,DE -- add DE to HL
            // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
            prev = [self.currentState getHL_little] & 0xf;
            prev_short = [self.currentState getHL_big];
            prev_int = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getDE_big]+[self.currentState getHL_big])];
            other_int = [self.currentState getDE_big] + prev_short;
            Z = [self.currentState getZFlag];
            C = ((other_int & 0xFFFF0000) ^ (prev_int & 0xFFFF0000)) != 0;
            H = (([self.currentState getHL_big] & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            [self.currentState setFlags:Z
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD HL,DE -- add DE (%i) and HL (%i) = %i\n", currentInstruction, \
                   [self.currentState getDE_big], prev_int, [self.currentState getHL_big]);
            break;
        case 0xA:
            // LD A,(DE) - load (DE) into A
            [self.currentState setA:(self.ram[(unsigned short)[self.currentState getDE_big]])];
            PRINTDBG("0x%02x -- LD A,(DE) -- load (DE == %i -> %i) into A\n", currentInstruction, \
                   [self.currentState getDE_big], (int)self.ram[(unsigned short)[self.currentState getDE_big]]);
            break;
        case 0xB:
            // DEC DE -- Decrement DE
            prev_int = [self.currentState getDE_big];
            [self.currentState setDE_big:([self.currentState getDE_big] - 1)];
            PRINTDBG("0x%02x -- DEC DE -- DE was %i; DE is now %i\n", currentInstruction, \
                     prev_int, [self.currentState getDE_big]);
            break;
        case 0xC:
            // INC E -- Increment E
            prev = [self.currentState getE];
            [self.currentState setE:([self.currentState getE] + 1)];
            [self.currentState setFlags:([self.currentState getE] == 0)
                                      N:false
                                      H:(prev > [self.currentState getE])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC E\n", currentInstruction);
            break;
        case 0xD:
            // DEC E -- Decrement E
            prev = [self.currentState getE];
            [self.currentState setE:([self.currentState getE] - 1)];
            Z = [self.currentState getE] == 0;
            H = [self.currentState getE] > prev;
            [self.currentState setFlags:Z
                                      N:true
                                      H:H
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- DEC E -- E was %i; E is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getE]);
            break;
        case 0xE:
            // LD E,d8 -- Load immediate 8-bit data into E
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setE:d8];
            PRINTDBG("0x%02x -- LD E, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // RRA -- Rotate accumulator right through carry flag
            A = [self.currentState getA];
            temp = [self.currentState getCFlag];
            C = (bool)([self.currentState getA] & 0b00000001);
            [self.currentState setA:([self.currentState getA] >> 1)];
            // Set MSb of A to its previous C-value
            temp ? [self.currentState setA:([self.currentState getA] | 0b10000000)] :
            [self.currentState setA:([self.currentState getA] & 0b01111111)];
            [self.currentState setFlags:false
                                      N:false
                                      H:false
                                      C:C];
            PRINTDBG("0x%02x -- RRA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
            break;
    }
}
- (void) execute0x2Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    int prev_int = 0;
    short prev_short = 0;
    int other_int = 0;
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // JR NZ,r8 -- If !Z, add r8 to PC
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            if ([self.currentState getZFlag] == false)
            {
                [self.currentState addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR NZ, r8 -- if !Z, PC += %i; PC is now 0x%02x\n",
                   currentInstruction, (int8_t)d8, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 1:
            // LD HL,d16 -- Load d16 into HL
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | (self.ram[[self.currentState getPC]] & 0x0ff);
            [self.currentState incrementPC];
            [self.currentState setHL_big:d16];
            PRINTDBG("0x%02x -- LD HL, d16 -- d16 = 0x%02x; HL = 0x%02x\n", currentInstruction, d16, \
                     [self.currentState getHL_big]);
            break;
        case 2:
            // LD (HL+),A -- Put A into (HL), and increment HL
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getA];
            [self.currentState setHL_big:([self.currentState getHL_big] + 1)];
            PRINTDBG("0x%02x -- LD (HL+),A -- HL = 0x%02x; (HL) = 0x%02x; A = %i\n", currentInstruction,
                        [self.currentState getHL_big], self.ram[(unsigned short)[self.currentState getHL_big]],
                     [self.currentState getA]);
            break;
        case 3:
            // INC HL -- Increment HL
            [self.currentState setHL_big:([self.currentState getHL_big] + 1)];
            PRINTDBG("0x%02x -- INC HL\n", currentInstruction);
            break;
        case 4:
            // INC H -- Increment H
            prev = [self.currentState getH];
            [self.currentState setH:([self.currentState getH] + 1)];
            [self.currentState setFlags:([self.currentState getH] == 0)
                                      N:false
                                      H:(prev > [self.currentState getH])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC H\n", currentInstruction);
            break;
        case 5:
            // DEC H -- Decrement H
            prev = [self.currentState getH];
            [self.currentState setH:([self.currentState getH] - 1)];
            [self.currentState setFlags:([self.currentState getH] == 0)
                                      N:true
                                      H:(prev < [self.currentState getH])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- DEC H\n", currentInstruction);
            break;
        case 6:
            // LD H,d8 -- Load 8-bit immediate data into H
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setH:d8];
            PRINTDBG("0x%02x -- LD H, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // DAA -- Decimal adjust register A; adjust A so that correct BCD obtained
#warning Do this eventually!!!
            break;
        case 8:
            // JR Z,r8 -- If Z, add r8 to PC
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            if ([self.currentState getZFlag])
            {
                [self.currentState addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR Z, r8 -- if Z, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 9:
            // ADD HL,HL -- Add HL to HL
            prev = [self.currentState getHL_little] & 0xf;
            prev_int = [self.currentState getHL_big];
            prev_short = [self.currentState getHL_big];
            [self.currentState setHL_big:(2 * [self.currentState getHL_big])];
            other_int = 2 * prev_short;
            Z = [self.currentState getZFlag];
            C = ((other_int & 0xFFFF0000) ^ (prev_int & 0xFFFF0000)) != 0;
            H = (([self.currentState getHL_big] & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            [self.currentState setFlags:Z
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD HL,HL -- add HL (%i) to itself = %i\n", currentInstruction, \
                        prev_int, [self.currentState getHL_big]);
            break;
        case 0xA:
            // LD A,(HL+) -- Put value at address at HL, (HL), into A, and increment HL
            [self.currentState setA:self.ram[(unsigned short)[self.currentState getHL_big]]];
            [self.currentState setHL_big:([self.currentState getHL_big]+1)];
            PRINTDBG("0x%02x -- LD A,(HL+) -- HL is now 0x%02x; A = 0x%02x\n", currentInstruction, \
                        [self.currentState getHL_big], [self.currentState getA]);
            break;
        case 0xB:
            // DEC HL -- Decrement HL
            prev_int = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getHL_big] - 1)];
            PRINTDBG("0x%02x -- DEC HL -- HL was %i; HL is now %i\n", currentInstruction, \
                     prev_int, [self.currentState getHL_big]);
            break;
        case 0xC:
            // INC L -- Increment L
            prev = [self.currentState getL];
            [self.currentState setL:([self.currentState getL] + 1)];
            [self.currentState setFlags:([self.currentState getL] == 0)
                                      N:false
                                      H:(prev > [self.currentState getL])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC L\n", currentInstruction);
            break;
        case 0xD:
            // DEC L -- Decrement L
            prev = [self.currentState getL];
            [self.currentState setL:([self.currentState getL] - 1)];
            Z = [self.currentState getL] == 0;
            H = [self.currentState getL] > prev;
            [self.currentState setFlags:Z
                                      N:true
                                      H:H
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- DEC L -- L was %i; L is now %i\n", currentInstruction, \
                     prev, (int)[self.currentState getL]);
            break;
        case 0xE:
            // LD L,d8 -- Load 8-bit immediate data into L
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setL:d8];
            PRINTDBG("0x%02x -- LD L, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // CPL -- Complement A
            prev = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] ^ 0xff)];
            [self.currentState setFlags:[self.currentState getZFlag]
                                      N:true
                                      H:true
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- CPL A -- A was %i; A is now %i\n", currentInstruction, prev, [self.currentState getA]);
            break;
    }
}
- (void) execute0x3Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    int prev_int = 0;
    short prev_short = 0;
    int other_int = 0;
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // JR NC,r8 -- If !C, add 8-bit immediate data to PC
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            if (![self.currentState getCFlag])
            {
                [self.currentState addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR NC, r8 -- if !C, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 1:
            // LD SP,d16 -- load immediate 16-bit data into SP
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | (self.ram[[self.currentState getPC]] & 0x0ff);
            [self.currentState incrementPC];
            [self.currentState setSP:d16];
            PRINTDBG("0x%02x -- LD SP, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD (HL-),A -- put A into (HL), and decrement HL
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getA];
            [self.currentState setHL_big:([self.currentState getHL_big] - 1)];
            PRINTDBG("0x%02x -- LD (HL-),A -- HL = 0x%02x; (HL) = 0x%02x; A = 0x%02x\n", currentInstruction,
                     [self.currentState getHL_big], self.ram[(unsigned short)[self.currentState getHL_big]],
                     [self.currentState getA]);
            break;
        case 3:
            // INC SP -- Increment SP
            [self.currentState setSP:([self.currentState getSP] + 1)];
            PRINTDBG("0x%02x -- INC SP\n", currentInstruction);
            break;
        case 4:
            // INC (HL) -- Increment (HL)
            prev = self.ram[[self.currentState getHL_big]];
            self.ram[[self.currentState getHL_big]] += 1;
            [self.currentState setFlags:(self.ram[(unsigned short)[self.currentState getHL_big]] == 0)
                                      N:false
                                      H:(prev > self.ram[(unsigned short)[self.currentState getHL_big]])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC (HL)\n", currentInstruction);
            break;
        case 5:
            // DEC (HL) -- Decrement (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] -= 1;
            [self.currentState setFlags:(self.ram[(unsigned short)[self.currentState getHL_big]] == 0)
                                      N:true
                                      H:(prev < self.ram[(unsigned short)[self.currentState getHL_big]])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- DEC (HL)\n", currentInstruction);
            break;
        case 6:
            // LD (HL),d8 -- Load 8-bit immediate data into (HL)
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = d8;
            PRINTDBG("0x%02x -- LD (HL), d8 -- d8 = 0x%02x\n", currentInstruction, (int)d8);
            break;
        case 7:
            // SCF -- Set carry flag
            [self.currentState setFlags:[self.currentState getZFlag]
                                      N:false
                                      H:false
                                      C:true];
            PRINTDBG("0x%02x -- SCF\n", currentInstruction);
            break;
        case 8:
            // JR C,r8 -- If C, add 8-bit immediate data to PC
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            if ([self.currentState getCFlag])
            {
                [self.currentState addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR C, r8 -- if C, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 9:
            // ADD HL,SP -- Add SP to HL
            // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
            prev = [self.currentState getHL_little] & 0xf;
            prev_int = [self.currentState getHL_big];
            prev_short = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getSP]+[self.currentState getHL_big])];
            other_int = [self.currentState getSP] + prev_short;
            Z = [self.currentState getZFlag];
            C = ((other_int & 0xFFFF0000) ^ (prev_int & 0xFFFF0000)) != 0;
            H = (([self.currentState getHL_big] & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            [self.currentState setFlags:Z
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD HL,SP -- add SP (%i) and HL (%i) = %i\n", currentInstruction, \
                     [self.currentState getSP], prev_int, [self.currentState getHL_big]);
            break;
        case 0xA:
            // LD A,(HL-) -- Put value at address at HL, (HL), into A, and decrement HL
            [self.currentState setA:self.ram[(unsigned short)[self.currentState getHL_big]]];
            [self.currentState setHL_big:([self.currentState getHL_big]-1)];
            PRINTDBG("0x%02x -- LD A,(HL-) -- HL is now 0x%02x; A = 0x%02x\n", currentInstruction, \
                     [self.currentState getHL_big], [self.currentState getA]);
            break;
        case 0xB:
            // DEC SP -- Decrement SP
            prev_int = [self.currentState getSP];
            [self.currentState setHL_big:([self.currentState getSP] - 1)];
            PRINTDBG("0x%02x -- DEC SP -- SP was %i; SP is now %i\n", currentInstruction, \
                     prev_int, [self.currentState getSP]);
            break;
        case 0xC:
            // INC A -- Increment A
            prev = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + 1)];
            [self.currentState setFlags:([self.currentState getA] == 0)
                                      N:false
                                      H:(prev > [self.currentState getA])
                                      C:([self.currentState getCFlag])];
            PRINTDBG("0x%02x -- INC A\n", currentInstruction);
            break;
        case 0xD:
            // DEC A -- Decrement A
            prev = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] - 1)];
            Z = [self.currentState getA] == 0;
            H = [self.currentState getA] > prev;
            [self.currentState setFlags:Z
                                      N:true
                                      H:H
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0x%02x -- DEC A -- A was %i; A is now %i\n", currentInstruction, \
                     prev, (int)[self.currentState getA]);
            break;
        case 0xE:
            // LD A,d8 -- Load 8-bit immediate data into A
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setA:d8];
            PRINTDBG("0x%02x -- LD A, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // CCF -- Complement carry flag
            [self.currentState setFlags:[self.currentState getZFlag]
                                      N:false
                                      H:false
                                      C:![self.currentState getCFlag]];
            PRINTDBG("0x%02x -- CCF\n", currentInstruction);
            break;
    }
}
- (void) execute0x4Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD B,B -- Load B into B (effectively a no-op?)
            PRINTDBG("0x%02x -- LD B,B -- WTH!\n", currentInstruction);
            break;
        case 1:
            // LD B,C -- Load C into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getC]];
            PRINTDBG("0x%02x -- LD B,C -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 2:
            // LD B,D -- Load D into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD B,D -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 3:
            // LD B,E -- Load E into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD B,E -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 4:
            // LD B,H -- Load H into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getH]];
            PRINTDBG("0x%02x -- LD B,H -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 5:
            // LD B,L -- Load L into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD B,L -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 6:
            // LD B,(HL) -- Load (HL) into B
            prev = [self.currentState getB];
            [self.currentState setB:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD B,(HL) -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 7:
            // LD B,A -- Load A into B
            prev = [self.currentState getB];
            [self.currentState setB:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD B,A -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getB]);
            break;
        case 8:
            // LD C,B -- Load B into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD C,B -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 9:
            // LD C,C -- Load C into C -- Again, effectively a no-op
            PRINTDBG("0x%02x -- LD C,C\n", currentInstruction);
            break;
        case 0xA:
            // LD C,D -- Load D into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD C,D -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 0xB:
            // LD C,E -- Load E into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD C,E -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 0xC:
            // LD C,H -- Load H into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getH]];
            PRINTDBG("0x%02x -- LD C,H -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 0xD:
            // LD C,L -- Load L into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD C,L -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 0xE:
            // LD C,(HL)
            prev = [self.currentState getC];
            [self.currentState setC:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD C,(HL) -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
        case 0xF:
            // LD C,A -- Load A into C
            prev = [self.currentState getC];
            [self.currentState setC:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD C,A -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getC]);
            break;
    }
}
- (void) execute0x5Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD D,B -- Load B into D
            prev = [self.currentState getD];
            [self.currentState setD:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD D,B -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 1:
            // LD D,C -- Load C into D
            prev = [self.currentState getD];
            [self.currentState setC:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD D,C -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 2:
            // LD D,D -- Load D into D -- No-op
            PRINTDBG("0x%02x -- LD D,D\n", currentInstruction);
            break;
        case 3:
            // LD D,E -- Load E into D
            prev = [self.currentState getD];
            [self.currentState setD:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD D,E -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 4:
            // LD D,H -- Load H into D
            prev = [self.currentState getD];
            [self.currentState setD:[self.currentState getH]];
            PRINTDBG("0x%02x -- LD D,H -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 5:
            // LD D,L -- Load L into D
            prev = [self.currentState getD];
            [self.currentState setD:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD D,L -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 6:
            // LD D,(HL) -- Load (HL) into D
            prev = [self.currentState getD];
            [self.currentState setD:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD D,(HL) -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 7:
            // LD D,A -- Load A into D
            prev = [self.currentState getD];
            [self.currentState setD:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD D,A -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getD]);
            break;
        case 8:
            // LD E,B -- Load B into E
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD E,B -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 9:
            // LD E,C -- Load C into E
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getC]];
            PRINTDBG("0x%02x -- LD E,C -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 0xA:
            // LD E,D -- Load D into E
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD E,D -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 0xB:
            // LD E,E -- Load E into E -- No-op
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD E,E\n", currentInstruction);
            break;
        case 0xC:
            // LD E,H -- Load H into E; A very Canadian instruction
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getH]];
            PRINTDBG("0x%02x -- Load, eh? -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 0xD:
            // LD E,L -- Load L into E
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD E,L -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 0xE:
            // LD E,(HL) -- Load (HL) into E
            prev = [self.currentState getE];
            [self.currentState setE:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD E,(HL) -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
        case 0xF:
            // LD E,A -- Load A into E
            prev = [self.currentState getE];
            [self.currentState setE:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD E,A -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getE]);
            break;
    }
}
- (void) execute0x6Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD H,B -- Load B into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD H,B -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 1:
            // LD H,C -- Load C into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getC]];
            PRINTDBG("0x%02x -- LD H,C -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 2:
            // LD H,D -- Load D into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD H,D -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 3:
            // LD H,E -- Load E into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD H,E -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 4:
            // LD H,H -- Load H into H -- No-op
            PRINTDBG("0x%02x -- LD H,H\n", currentInstruction);
            break;
        case 5:
            // LD H,L -- Load L into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD H,L -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 6:
            // LD H,(HL) -- Load (HL) into H
            prev = [self.currentState getH];
            prev_short = [self.currentState getHL_big];
            [self.currentState setH:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD H,(HL) -- H was 0x%02x; HL was 0x%04x; (HL) was 0x%02x; H is now 0x%02x\n", \
                     currentInstruction, prev & 0xff, prev_short & 0xffff, \
                     self.ram[(unsigned short)prev_short] & 0xff, [self.currentState getH] & 0xff);
            break;
        case 7:
            // LD H,A -- Load A into H
            prev = [self.currentState getH];
            [self.currentState setH:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD H,A -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getH]);
            break;
        case 8:
            // LD L,B -- Load B into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD L,B -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 9:
            // LD L,C -- Load C into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getC]];
            PRINTDBG("0x%02x -- LD L,C -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 0xA:
            // LD L,D -- Load D into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD L,D -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 0xB:
            // LD L,E -- Load E into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD L,E -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 0xC:
            // LD L,H -- Load H into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getH]];
            PRINTDBG("0x%02x -- LD L,H -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 0xD:
            // LD L,L -- Load L into L -- No-op
            PRINTDBG("0x%02x -- LD L,L\n", currentInstruction);
            break;
        case 0xE:
            // LD L,(HL) -- Load (HL) into L
            prev = [self.currentState getL];
            [self.currentState setL:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD L,(HL) -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
        case 0xF:
            // LD L,A -- Load A into L
            prev = [self.currentState getL];
            [self.currentState setL:[self.currentState getA]];
            PRINTDBG("0x%02x -- LD L,A -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getL]);
            break;
    }
}
- (void) execute0x7Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD (HL),B -- Load B into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getB];
            PRINTDBG("0x%02x -- LD (HL),B -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 1:
            // LD (HL),C -- Load C into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getC];
            PRINTDBG("0x%02x -- LD (HL),C -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 2:
            // LD (HL),D -- Load D into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getD];
            PRINTDBG("0x%02x -- LD (HL),D -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 3:
            // LD (HL),E -- Load E into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getE];
            PRINTDBG("0x%02x -- LD (HL),E -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 4:
            // LD (HL),H -- Load H into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getH];
            PRINTDBG("0x%02x -- LD (HL),H -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 5:
            // LD (HL),L -- Load L into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getL];
            PRINTDBG("0x%02x -- LD (HL),L -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 6:
            // HALT -- Power down CPU until interrupt occurs
#warning DO THIS EVENTUALLY!
            PRINTDBG("0x%02x -- HALT\n", currentInstruction);
            break;
        case 7:
            // LD (HL),A -- Load A into (HL)
            prev = self.ram[(unsigned short)[self.currentState getHL_big]];
            self.ram[(unsigned short)[self.currentState getHL_big]] = [self.currentState getA];
            PRINTDBG("0x%02x -- LD (HL),A -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, self.ram[(unsigned short)[self.currentState getHL_big]]);
            break;
        case 8:
            // LD A,B -- Load B into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getB]];
            PRINTDBG("0x%02x -- LD A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 9:
            // LD A,C -- Load C into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getC]];
            PRINTDBG("0x%02x -- LD A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xA:
            // LD A,D -- Load D into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getD]];
            PRINTDBG("0x%02x -- LD A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xB:
            // LD A,E -- Load E into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getE]];
            PRINTDBG("0x%02x -- LD A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xC:
            // LD A,H -- Load H into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getH]];
            PRINTDBG("0x%02x -- LD A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xD:
            // LD A,L -- Load L into A
            prev = [self.currentState getA];
            [self.currentState setA:[self.currentState getL]];
            PRINTDBG("0x%02x -- LD A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xE:
            // LD A,(HL) -- Load (HL) into A
            prev = [self.currentState getA];
            [self.currentState setA:self.ram[(unsigned short)[self.currentState getHL_big]]];
            PRINTDBG("0x%02x -- LD A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [self.currentState getA]);
            break;
        case 0xF:
            // LD A,A -- Load A into A -- No-op
            PRINTDBG("0x%02x -- LD A,A\n", currentInstruction);
            break;
    }
}
- (void) execute0x8Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    int8_t d8 = 0;
    short prev_short = 0;
    short other_short = 0;
    bool C = false;
    bool H = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // ADD A,B -- Add B to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getB])];
            other_short = [self.currentState getB] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,B -- add A (%i) and B (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getB], [self.currentState getA]);
            break;
        case 1:
            // ADD A,C -- Add C to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getC])];
            other_short = [self.currentState getC] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,C -- add A (%i) and C (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getC], [self.currentState getA]);
            break;
        case 2:
            // ADD A,D -- Add D to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getD])];
            other_short = [self.currentState getD] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,D -- add A (%i) and D (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getD], [self.currentState getA]);
            break;
        case 3:
            // ADD A,E -- Add E to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getE])];
            other_short = [self.currentState getE] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,E -- add A (%i) and E (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getE], [self.currentState getA]);
            break;
        case 4:
            // ADD A,H -- Add H to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getH])];
            other_short = [self.currentState getH] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,H -- add A (%i) and H (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getH], [self.currentState getA]);
            break;
        case 5:
            // ADD A,L -- Add L to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] + [self.currentState getL])];
            other_short = [self.currentState getL] + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,L -- add A (%i) and L (%i) = %i\n", currentInstruction, \
                     prev, [self.currentState getL], [self.currentState getA]);
            break;
        case 6:
            // ADD A,(HL) -- Add (HL) to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            d8 = self.ram[(unsigned short)[self.currentState getHL_big]];
            [self.currentState setA:([self.currentState getA] + d8)];
            other_short = d8 + prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,(HL) -- add A (%i) and (HL) (%i) = %i\n", currentInstruction, \
                     prev, d8, [self.currentState getA]);
            break;
        case 7:
            // ADD A,A -- Add A to A
            prev = [self.currentState getA];
            prev_short = [self.currentState getA];
            [self.currentState setA:(2 * [self.currentState getA])];
            other_short = 2 * prev;
            C = ((other_short & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            // If there is carry from b3, the top nibble will be different from before
            H = (([self.currentState getA] & 0xF0) ^ (prev & 0xF0)) != 0;
            [self.currentState setFlags:[self.currentState getA] == 0
                                      N:false
                                      H:H // carry from bit 3?
                                      C:C]; // carry from bit 7?
            PRINTDBG("0x%02x -- ADD A,A -- add A (%i) and A (%i) = %i\n", currentInstruction, \
                     prev, prev, [self.currentState getA]);
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) execute0x9Instruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            // SBC A,A -- Subtract A + carry flag from A, so A = 0 - C-flag
            prev = [self.currentState getA];
            if ([self.currentState getCFlag] == true)
            {
                [self.currentState setA:-1];
            }
            else
            {
                [self.currentState setA:0];
            }
#warning Figure out how to set flags here
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            PRINTDBG("0x%02x -- SBC A,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                        prev, [self.currentState getA]);
            break;
    }
}
- (void) execute0xAInstruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            // XOR A -- A <- A ^ A
            prev = [self.currentState getA];
            [self.currentState setA:(prev ^ prev)];
            [self.currentState setFlags:([self.currentState getA] == 0)
                                      N:false
                                      H:false
                                      C:false];
            PRINTDBG("0x%02x -- XOR A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [self.currentState getA]);
            break;
    }
}
- (void) execute0xBInstruction:(unsigned char)currentInstruction
{
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // OR B -- A <- A | B
            prev = [self.currentState getA];
            [self.currentState setA:([self.currentState getA] | [self.currentState getB])];
            [self.currentState setFlags:([self.currentState getA] == 0)
                                      N:false
                                      H:false
                                      C:false];
            PRINTDBG("0x%02x -- OR B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [self.currentState getA]);
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) execute0xCInstruction:(unsigned char)currentInstruction
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NZ -- If !Z, return from subroutine
            prev_short = [self.currentState getSP];
            if ([self.currentState getZFlag] == false)
            {
                d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                        (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [self.currentState setSP:([self.currentState getSP]+2)];
                [self.currentState setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NZ -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [self.currentState getSP] & 0xffff, [self.currentState getPC]);
            break;
        case 1:
            // POP BC -- Pop two bytes from SP into BC, and increment SP twice
            d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                        (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setBC_big:d16];
            [self.currentState setSP:([self.currentState getSP] + 2)];
            PRINTDBG("0x%02x -- POP BC -- BC = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getBC_big], [self.currentState getSP]);
            break;
        case 2:
            
            break;
        case 3:
            // JP a16 -- Jump to address a16
            [self.currentState incrementPC];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setPC:d16];
            PRINTDBG("0x%02x -- JP a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", currentInstruction,
                     d16 & 0xffff, [self.currentState getPC]);
            incrementPC = false;
            break;
        case 4:
            // CALL NZ,a16 -- If !Z, push PC onto stack, and jump to a16
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getZFlag] == false)
            {
                [self.currentState setSP:([self.currentState getSP] - 2)];
                self.ram[[self.currentState getSP]] = ([self.currentState getPC] & 0xff00) >> 8;
                self.ram[[self.currentState getSP]+1] = [self.currentState getPC] & 0x00ff;
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- CALL NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                        currentInstruction, d16 & 0xffff, prev_short, [self.currentState getSP], \
                        [self.currentState getPC]);
            break;
        case 5:
            // PUSH BC -- push BC onto SP, and decrement SP twice
            d16 = [self.currentState getBC_little];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH BC -- BC = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getBC_big], [self.currentState getSP]);
            break;
        case 6:
            
            break;
        case 7:
            // RST 00H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x00];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 00H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
        case 8:
            // RET Z -- If Z, return from subroutine
            prev_short = [self.currentState getSP];
            if ([self.currentState getZFlag] == true)
            {
                d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [self.currentState setSP:([self.currentState getSP]+2)];
                [self.currentState setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET Z -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [self.currentState getSP] & 0xffff, [self.currentState getPC]);
            break;
        case 9:
            // RET -- return from subroutine; pop two bytes from SP and go to that address
            d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setSP:([self.currentState getSP]+2)];
            [self.currentState setPC:(unsigned short)d16];
            incrementPC = false;
            PRINTDBG("0x%02x -- RET -- PC is now 0x%02x\n", currentInstruction,
                     [self.currentState getPC]);
            break;
        case 0xA:
            // JP Z,a16 -- If Z, jump to address a16
            [self.currentState incrementPC];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getZFlag] == true)
            {
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- JP Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [self.currentState getPC]);
            break;
        case 0xB:
            // Instruction with 0xCB prefix
            PRINTDBG("CB instruction...\n");
            [self executeCBInstruction];
            break;
        case 0xC:
            // CALL Z,a16 -- If Z, call subroutine at address a16
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getZFlag] == true)
            {
                [self.currentState setSP:([self.currentState getSP] - 2)];
                self.ram[[self.currentState getSP]] = ([self.currentState getPC] & 0xff00) >> 8;
                self.ram[[self.currentState getSP]+1] = [self.currentState getPC] & 0x00ff;
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- CALL Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [self.currentState getSP], \
                     [self.currentState getPC]);
            break;
        case 0xD:
            // CALL a16 -- call subroutine at address a16
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = ([self.currentState getPC] & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = [self.currentState getPC] & 0x00ff;
            [self.currentState setPC:d16];
            incrementPC = false;
            PRINTDBG("0x%02x -- CALL a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [self.currentState getSP], \
                     [self.currentState getPC]);
            break;
        case 0xE:
            
            break;
        case 0xF:
            // RST 08H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x08];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 08H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
    }
}
- (void) execute0xDInstruction:(unsigned char)currentInstruction
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NC -- If !C, return from subroutine
            prev_short = [self.currentState getSP];
            if ([self.currentState getCFlag] == false)
            {
                d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [self.currentState setSP:([self.currentState getSP]+2)];
                [self.currentState setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NC -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [self.currentState getSP] & 0xffff, [self.currentState getPC]);
            break;
        case 1:
            // POP DE - Pop two bytes from SP into DE, and increment SP twice
            d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setDE_big:d16];
            [self.currentState setSP:([self.currentState getSP] + 2)];
            PRINTDBG("0x%02x -- POP DE -- DE = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getDE_big], [self.currentState getSP]);
            break;
        case 2:
            // JP NC,a16 -- If !C, jump to address a16
            [self.currentState incrementPC];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getCFlag] == false)
            {
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- JP NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [self.currentState getPC]);
            break;
        case 3:
            
            break;
        case 4:
            // CALL NC,a16 -- If !C, call subroutine at address a16
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getCFlag] == false)
            {
                [self.currentState setSP:([self.currentState getSP] - 2)];
                self.ram[[self.currentState getSP]] = ([self.currentState getPC] & 0xff00) >> 8;
                self.ram[[self.currentState getSP]+1] = [self.currentState getPC] & 0x00ff;
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- CALL NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [self.currentState getSP], \
                     [self.currentState getPC]);
            break;
        case 5:
            // PUSH DE -- push BC onto SP, and decrement SP twice
            d16 = [self.currentState getDE_little];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH DE -- DE = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getDE_big], [self.currentState getSP]);
            break;
        case 6:
            
            break;
        case 7:
            // RST 10H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x10];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 10H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
        case 8:
            // RET C -- If C, return from subroutine
            prev_short = [self.currentState getSP];
            if ([self.currentState getCFlag] == true)
            {
                d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [self.currentState setSP:([self.currentState getSP]+2)];
                [self.currentState setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET C -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [self.currentState getSP] & 0xffff, [self.currentState getPC]);
            break;
        case 9:
            // RETI -- RET + enable interrupts
            d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setSP:([self.currentState getSP]+2)];
            [self.currentState setPC:(unsigned short)d16];
            incrementPC = false;
            [self enableInterrupts:true];
            PRINTDBG("0x%02x -- RETI -- PC is now 0x%02x\n", currentInstruction,
                     [self.currentState getPC]);
            break;
        case 0xA:
            // JP C,a16 -- If C, jump to address a16
            [self.currentState incrementPC];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getCFlag] == true)
            {
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- JP C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [self.currentState getPC]);
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            // CALL C,a16 -- If C, call subroutine at address a16
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d16 = ((self.ram[[self.currentState getPC]] & 0x00ff) << 8) | \
            (((self.ram[[self.currentState getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            if ([self.currentState getCFlag] == true)
            {
                [self.currentState setSP:([self.currentState getSP] - 2)];
                self.ram[[self.currentState getSP]] = ([self.currentState getPC] & 0xff00) >> 8;
                self.ram[[self.currentState getSP]+1] = [self.currentState getPC] & 0x00ff;
                [self.currentState setPC:d16];
                incrementPC = false;
            }
            PRINTDBG("0x%02x -- CALL C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [self.currentState getSP], \
                     [self.currentState getPC]);
            break;
        case 0xE:
            
            break;
        case 0xF:
            // RST 18H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x18];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 18H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
    }
}
- (void) execute0xEInstruction:(unsigned char)currentInstruction
{
    int8_t d8 = 0;
    int16_t d16 = 0;
    unsigned short prev_short = 0;
    bool H = false;
    bool C = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            // POP HL - Pop two bytes from SP into HL, and increment SP twice
            d16 = ((self.ram[[self.currentState getSP]] & 0x00ff) << 8) | \
                    (((self.ram[[self.currentState getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [self.currentState setHL_big:d16];
            [self.currentState setSP:([self.currentState getSP] + 2)];
            PRINTDBG("0x%02x -- POP HL -- HL = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getHL_big], [self.currentState getSP]);
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            // PUSH HL -- push HL onto SP, and decrement SP twice
            d16 = [self.currentState getHL_little];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH HL -- HL = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getHL_big], [self.currentState getSP]);
            break;
        case 6:
            
            break;
        case 7:
            // RST 20H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x20];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 20H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
        case 8:
            // ADD SP,r8 -- Add 8-bit immediate value to SP
            [self.currentState incrementPC];
            prev_short = [self.currentState getSP];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState addToSP:d8];
            C = ([self.currentState getA] >= 0 && prev_short > [self.currentState getA]) || \
                ([self.currentState getA] < 0 && prev_short < [self.currentState getA]);
            // If there is carry from b7, the top byte will be different from before
            H = (([self.currentState getSP] & 0xFF00) ^ (prev_short & 0xFF00)) != 0;
            [self.currentState setFlags:false
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD SP,r8 (r8 = %d) -- SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, (int)d8, prev_short, [self.currentState getSP]);
            break;
        case 9:
            // JP (HL) -- Jump to address in register HL
            [self.currentState incrementPC];
            d16 = (([self.currentState getHL_big] & 0x00ff) << 8) | \
                ((([self.currentState getHL_big] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            [self.currentState setPC:d16];
            incrementPC = false;
            PRINTDBG("0x%02x -- JP (HL) -- HL = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [self.currentState getPC]);
            break;
        case 0xA:
            // LD (a16),A -- Put A into (a16)
            [self.currentState incrementPC];
            d16 = (([self.currentState getPC] & 0x00ff) << 8) | \
                ((([self.currentState getPC] & 0xff00) >> 8) & 0x0ff);
            [self.currentState incrementPC];
            self.ram[(unsigned short)d16] = [self.currentState getA];
            PRINTDBG("0x%02x -- LD (a16),A -- A = 0x%02x; a16 = 0x%02x\n", currentInstruction,
                     [self.currentState getA], self.ram[(unsigned short)d16]);
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            // RST 28H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x28];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 28H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
    }
}
- (void) execute0xFInstruction:(unsigned char)currentInstruction
{
    int16_t d16 = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            // POP AF -- Pop two bytes from SP into AF, and increment SP twice
            [self.currentState setA:self.ram[(([self.currentState getSP] & 0xff00) >> 8)]];
            [self.currentState setF:self.ram[(([self.currentState getSP] & 0x00ff) << 8)]];
            [self.currentState setSP:([self.currentState getSP] + 2)];
            PRINTDBG("0x%02x -- POP AF -- AF = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getAF_big], [self.currentState getSP]);
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            // PUSH AF -- push AF onto SP, and decrement SP twice
            d16 = [self.currentState getAF_little];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH AF -- AF = 0x%02x -- SP is now at 0x%02x\n", currentInstruction,
                     [self.currentState getAF_big], [self.currentState getSP]);
            break;
        case 6:
            
            break;
        case 7:
            // RST 30H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x30];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 30H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            // RST 38H -- push PC onto stack, and jump to address 0x00
            d16 = [self.currentState getPC];
            [self.currentState setSP:([self.currentState getSP] - 2)];
            self.ram[[self.currentState getSP]] = (d16 & 0xff00) >> 8;
            self.ram[[self.currentState getSP]+1] = d16 & 0x00ff;
            [self.currentState setPC:0x38];
            incrementPC = false;
            PRINTDBG("0x%02x -- RST 38H -- SP is now at 0x%02x\n", currentInstruction, [self.currentState getSP]);
            break;
    }
}

#pragma mark - CB instruction methods

- (void) executeCBInstruction
{
    [self.currentState incrementPC];
    unsigned char CBInstruction = self.ram[[self.currentState getPC]];
    switch ((CBInstruction & 0xF0) >> 4) {
        case 0:
            [self CBexecute0x0Instruction:CBInstruction];
            break;
        case 1:
            [self CBexecute0x1Instruction:CBInstruction];
            break;
        case 2:
            [self CBexecute0x2Instruction:CBInstruction];
            break;
        case 3:
            [self CBexecute0x3Instruction:CBInstruction];
            break;
        case 4:
            [self CBexecute0x4Instruction:CBInstruction];
            break;
        case 5:
            [self CBexecute0x5Instruction:CBInstruction];
            break;
        case 6:
            [self CBexecute0x6Instruction:CBInstruction];
            break;
        case 7:
            [self CBexecute0x7Instruction:CBInstruction];
            break;
        case 8:
            [self CBexecute0x8Instruction:CBInstruction];
            break;
        case 9:
            [self CBexecute0x9Instruction:CBInstruction];
            break;
        case 0xA:
            [self CBexecute0xAInstruction:CBInstruction];
            break;
        case 0xB:
            [self CBexecute0xBInstruction:CBInstruction];
            break;
        case 0xC:
            [self CBexecute0xCInstruction:CBInstruction];
            break;
        case 0xD:
            [self CBexecute0xDInstruction:CBInstruction];
            break;
        case 0xE:
            [self CBexecute0xEInstruction:CBInstruction];
            break;
        case 0xF:
            [self CBexecute0xFInstruction:CBInstruction];
            break;
    }
}

- (void) CBexecute0x0Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x1Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x2Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x3Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x4Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x5Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x6Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x7Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            // BIT 7,H -- test 7th bit of H register
            [self.currentState setFlags:(bool)([self.currentState getH] & (int8_t)0b10000000)
                                      N:false
                                      H:true
                                      C:[self.currentState getCFlag]];
            PRINTDBG("0xCB%02x -- BIT 7,H -- H is 0x%02x -- Z is now %i\n", currentInstruction, \
                     [self.currentState getH], [self.currentState getZFlag]);
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x8Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0x9Instruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xAInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xBInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xCInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            // Instruction with 0xCB prefix
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xDInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xEInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}
- (void) CBexecute0xFInstruction:(unsigned char)currentInstruction
{
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
}

@end

