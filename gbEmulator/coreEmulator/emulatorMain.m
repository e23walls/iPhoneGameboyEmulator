//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "emulatorMain.h"
#include <sys/stat.h>

#define K 1024
#define RAMSIZE (64 * K)

#define MYDEBUG

@interface emulatorMain ()

@property char * ram;
@property rom * currentRom;
@property romState * currentState;

@end

@implementation emulatorMain

- (emulatorMain *) initWithRom:(rom *) theRom
{
    self = [super init];
    self.keys = calloc(8, sizeof(int));
    self.currentRom = theRom;
    self.ram = (char *)malloc(RAMSIZE * sizeof(unsigned char));
    
    // Load the ROM file into RAM
    
    FILE * romFileHandler = fopen([self.currentRom.fullPath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (romFileHandler == NULL)
    {
        printf("Some error occurred when opening the ROM.\n");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not load ROM!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
    NSLog(@"Loading the ROM '%@'\nLocation: %@\n", self.currentRom.romName, self.currentRom.fullPath);
    int ch;
    BOOL hitEOF = NO;
    int counter = 0;
    ch = fgetc(romFileHandler);
    while (counter < RAMSIZE)
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
    
    return self;
}

- (void) runRom
{
#warning Something here is causing a crash in the simulator, but not on a real device
    while ([self.currentState getPC] < RAMSIZE)
    {
#ifdef MYDEBUG
        printf("PC = 0x%2x\n", [self.currentState getPC]);
#endif
        [self executeInstruction];
        [self.currentState incrementPC];
    }
    self.ram = nil;
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
    unsigned char prev = 0;
    int prev_int = 0;
    unsigned char A = 0;
    unsigned short d16 = 0;
    unsigned char d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // No-op
#ifdef MYDEBUG
            printf("0x%02x -- no-op\n", currentInstruction);
#endif
            break;
        case 1:
            // LD BC, d16 -- Load 16-bit data into registers BC
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | self.ram[[self.currentState getPC]];
            [self.currentState incrementPC];
            [self.currentState setBC_big:d16];
#ifdef MYDEBUG
            printf("0x%02x -- LD BC, d16 -- d16 = %i\n", currentInstruction, d16);
#endif
            break;
        case 2:
            // LD BC, A -- Load A into (BC)
            // Use index % RAMSIZE for case where the number is negative, since it should
            // be interpreted unsigned, but becomes too large a value. -1 should be interpreted as RAMSIZE-1
            self.ram[[self.currentState getBC_big] % RAMSIZE] = [self.currentState getA];
#ifdef MYDEBUG
            printf("0x%02x -- LD (BC), A -- A is now %d\n", currentInstruction, [self.currentState getA]);
#endif
            break;
        case 3:
            // INC BC -- increment BC
            [self.currentState setBC_big:([self.currentState getBC_big] + 1)];
#ifdef MYDEBUG
            printf("0x%02x -- INC BC\n", currentInstruction);
#endif
            break;
        case 4:
            // INC B -- increment B and set flags
            prev = [self.currentState getB];
            [self.currentState setB:([self.currentState getB] + 1)];
            [self.currentState setFlags:([self.currentState getB] == 0)
                                    N:false
                                    H:(prev > [self.currentState getB])
                                    C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- INC B\n", currentInstruction);
#endif
            break;
        case 5:
            // DEC B -- decrement B and set flags
            prev = [self.currentState getB];
            [self.currentState setB:([self.currentState getB] - 1)];
            [self.currentState setFlags:([self.currentState getB] == 0)
                                      N:true
                                      H:(prev < [self.currentState getB])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- DEC B\n", currentInstruction);
#endif
            break;
        case 6:
            // LD B, d8 -- load following 8-bit data into B
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setB:d8];
#ifdef MYDEBUG
            printf("0x%02x -- LD B, d8 -- d8 = %i\n", currentInstruction, (int)d8);
#endif
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
            [self.currentState setFlags:false N:false H:false C:C];
#ifdef MYDEBUG
            printf("0x%02x -- RLCA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
#endif
            break;
        case 8:
            // LD (a16), SP -- put SP at address a16
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | self.ram[[self.currentState getPC]];
            [self.currentState incrementPC];
            self.ram[d16] = [self.currentState getSP];
#ifdef MYDEBUG
            printf("0x%02x -- LD (a16), SP -- put SP at 0x%02x -- SP is %02x -- [SP] = 0x%02x\n", currentInstruction, \
                                d16, [self.currentState getSP], self.ram[d16]);
#endif
            break;
        case 9:
            // ADD HL,BC -- add BC to HL
            // H == carry from bit 11
            // C == carry from bit 15
            prev_int = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getBC_big]+[self.currentState getHL_big])];
            Z = [self.currentState getZFlag];
            C = ([self.currentState getBC_big] >= 0 && prev_int > [self.currentState getHL_big]) || \
                    ([self.currentState getBC_big] < 0 && prev_int < [self.currentState getHL_big]);
#warning H must be set to be the boolean valuation of the statement, "There is carry from bit 11"
            H = 0;
            [self.currentState setFlags:Z N:false H:H C:C];
#ifdef MYDEBUG
            printf("0x%02x -- ADD HL,BC -- add BC (%i) and HL (%i) = %i\n", currentInstruction, \
                   [self.currentState getBC_big], prev_int, [self.currentState getHL_big]);
#endif
            break;
        case 0xA:
            // LD A,(BC) -- load (BC) into A
            [self.currentState setA:self.ram[([self.currentState getBC_big] % RAMSIZE)]];
#ifdef MYDEBUG
            printf("0x%02x -- LD A,(BC) -- load (BC == %i -> %i) into A\n", currentInstruction, \
                   [self.currentState getBC_big], (int)self.ram[[self.currentState getBC_big] % RAMSIZE]);
#endif
            break;
        case 0xB:
            // DEC BC -- decrement BC
            prev_int = [self.currentState getBC_big];
            [self.currentState setBC_big:([self.currentState getBC_big] - 1)];
#ifdef MYDEBUG
            printf("0x%02x -- DEC BC -- BC was %i; BC is now %i\n", currentInstruction, \
                   prev_int, [self.currentState getBC_big]);
#endif
            break;
        case 0xC:
            // INC C -- increment C
            prev = [self.currentState getC];
            [self.currentState setC:([self.currentState getC] + 1)];
            Z = [self.currentState getC] == 0;
            H = [self.currentState getC] < prev;
            [self.currentState setFlags:Z N:false H:H C:[self.currentState getCFlag]];
#ifdef MYDEBUG
            printf("0x%02x -- INC C -- C was %i; C is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getC]);
#endif
            break;
        case 0xD:
            // DEC C -- decrement C
            prev = [self.currentState getC];
            [self.currentState setC:([self.currentState getC] - 1)];
            Z = [self.currentState getC] == 0;
            H = [self.currentState getC] > prev;
            [self.currentState setFlags:Z N:true H:H C:[self.currentState getCFlag]];
#ifdef MYDEBUG
            printf("0x%02x -- DEC C -- C was %i; C is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getC]);
#endif
            break;
        case 0xE:
            // LD C, d8 -- load immediate 8-bit data into C
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setC:d8];
#ifdef MYDEBUG
            printf("0x%02x -- LD C, d8 -- d8 = %i\n", currentInstruction, (short)d8);
#endif
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
            [self.currentState setFlags:false N:false H:false C:C];
#ifdef MYDEBUG
            printf("0x%02x -- RRCA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
#endif
            break;
    }
}
- (void) execute0x1Instruction:(unsigned char)currentInstruction
{
    unsigned char prev = 0;
    int prev_int = 0;
    unsigned char A = 0;
    unsigned short d16 = 0;
    unsigned char d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // STOP
#warning Implement STOP instruction
            // Wait for button press before changing processor and screen
            break;
        case 1:
            // LD DE, d16 -- Load d16 into DE
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | self.ram[[self.currentState getPC]];
            [self.currentState incrementPC];
            [self.currentState setDE_big:d16];
#ifdef MYDEBUG
            printf("0x%02x -- LD DE, d16 -- d16 = %i\n", currentInstruction, d16);
#endif
            break;
        case 2:
            // LD (DE), A -- put A into (DE)
            self.ram[[self.currentState getDE_big] % RAMSIZE] = [self.currentState getA];
#ifdef MYDEBUG
            printf("0x%02x -- LD (DE), A -- A = %i\n", currentInstruction, (int)[self.currentState getA]);
#endif
            break;
        case 3:
            // INC DE -- Increment DE
            [self.currentState setDE_big:([self.currentState getDE_big] + 1)];
#ifdef MYDEBUG
            printf("0x%02x -- INC DE\n", currentInstruction);
#endif
            break;
        case 4:
            // INC D -- Increment D
            prev = [self.currentState getD];
            [self.currentState setD:([self.currentState getD] + 1)];
            [self.currentState setFlags:([self.currentState getD] == 0)
                                      N:false
                                      H:(prev > [self.currentState getD])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- INC D\n", currentInstruction);
#endif
            break;
        case 5:
            // DEC D -- Decrement D
            prev = [self.currentState getD];
            [self.currentState setD:([self.currentState getD] - 1)];
            [self.currentState setFlags:([self.currentState getD] == 0)
                                      N:true
                                      H:(prev < [self.currentState getD])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- DEC D\n", currentInstruction);
#endif
            break;
        case 6:
            // LD D, d8 -- load 8-bit immediate value into D
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setD:d8];
#ifdef MYDEBUG
            printf("0x%02x -- LD D, d8 -- d8 = %i\n", currentInstruction, (int)d8);
#endif
            break;
        case 7:
            // RLA -- Rotate A left through carry flag -- Does this mean take previous C value for A[0]? Else, what's
            // the difference between it and the RLCA instruction?
#warning Double-check this rotate is correct
            A = [self.currentState getA];
            temp = [self.currentState getCFlag];
            C = (bool)([self.currentState getA] & 0b10000000);
            [self.currentState setA:([self.currentState getA] << 1)];
            // Set LSb of A to its previous C-value
            temp ? [self.currentState setA:([self.currentState getA] | 1)] :
            [self.currentState setA:([self.currentState getA] & 0b11111110)];
            [self.currentState setFlags:false N:false H:false C:C];
#ifdef MYDEBUG
            printf("0x%02x -- RLA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
#endif
            break;
        case 8:
            // JR r8 (8-bit signed data, added to PC)
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setPC:([self.currentState getPC] + (int)d8)];
#ifdef MYDEBUG
            printf("0x%02x -- JR r8 (r8 = %d) -- PC is now %02x\n",
                   currentInstruction, (int)d8, [self.currentState getPC]);
#endif
            break;
        case 9:
            // ADD HL,DE -- add DE to HL
            // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
            prev_int = [self.currentState getHL_big];
            [self.currentState setHL_big:([self.currentState getDE_big]+[self.currentState getHL_big])];
            Z = [self.currentState getZFlag];
            C = ([self.currentState getDE_big] >= 0 && prev_int > [self.currentState getHL_big]) || \
            ([self.currentState getDE_big] < 0 && prev_int < [self.currentState getHL_big]);
#warning H must be set to be the boolean valuation of the statement, "There is carry from bit 11"
            H = 0;
            [self.currentState setFlags:Z N:false H:H C:C];
#ifdef MYDEBUG
            printf("0x%02x -- ADD HL,DE -- add DE (%i) and HL (%i) = %i\n", currentInstruction, \
                   [self.currentState getDE_big], prev_int, [self.currentState getHL_big]);
#endif
            break;
        case 0xA:
            // LD A,(DE) - load (DE) into A
            [self.currentState setA:(self.ram[[self.currentState getDE_big] % RAMSIZE])];
#ifdef MYDEBUG
            printf("0x%02x -- LD A,(DE) -- load (DE == %i -> %i) into A\n", currentInstruction, \
                   [self.currentState getDE_big], (int)self.ram[[self.currentState getDE_big] % RAMSIZE]);
#endif
            break;
        case 0xB:
            // DEC DE -- Decrement DE
            prev_int = [self.currentState getDE_big];
            [self.currentState setDE_big:([self.currentState getDE_big] - 1)];
#ifdef MYDEBUG
            printf("0x%02x -- DEC DE -- DE was %i; DE is now %i\n", currentInstruction, \
                   prev_int, [self.currentState getDE_big]);
#endif
            break;
        case 0xC:
            // INC E -- Increment E
            prev = [self.currentState getE];
            [self.currentState setE:([self.currentState getE] + 1)];
            [self.currentState setFlags:([self.currentState getE] == 0)
                                      N:false
                                      H:(prev > [self.currentState getE])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- INC E\n", currentInstruction);
#endif
            break;
        case 0xD:
            // DEC E -- Decrement E
            prev = [self.currentState getE];
            [self.currentState setE:([self.currentState getE] - 1)];
            Z = [self.currentState getE] == 0;
            H = [self.currentState getE] > prev;
            [self.currentState setFlags:Z N:true H:H C:[self.currentState getCFlag]];
#ifdef MYDEBUG
            printf("0x%02x -- DEC E -- E was %i; E is now %i\n", currentInstruction, \
                   prev, (int)[self.currentState getE]);
#endif
            break;
        case 0xE:
            // LD E,d8 -- Load immediate 8-bit data into E
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setE:d8];
#ifdef MYDEBUG
            printf("0x%02x -- LD E, d8 -- d8 = %i\n", currentInstruction, (short)d8);
#endif
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
            [self.currentState setFlags:false N:false H:false C:C];
#ifdef MYDEBUG
            printf("0x%02x -- RRA -- A was %02x; A is now %02x\n", currentInstruction, A, [self.currentState getA]);
#endif
            break;
    }
}
- (void) execute0x2Instruction:(unsigned char)currentInstruction
{
    unsigned char prev = 0;
    int prev_int = 0;
    unsigned char A = 0;
    unsigned short d16 = 0;
    unsigned char d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // JR NZ,r8 -- If !Z, add r8 to PC
            [self.currentState incrementPC];
            d8 = self.ram[([self.currentState getPC] % RAMSIZE)];
            if ([self.currentState getZFlag] == false)
            {
                [self.currentState setPC:([self.currentState getPC] + (int)d8)];
            }
#ifdef MYDEBUG
            printf("0x%02x -- JR NZ, r8 -- if !Z, PC += 0x%02x; PC is now 0x%02x\n",
                   currentInstruction, (int)d8, [self.currentState getPC]);
#endif
            break;
        case 1:
            // LD HL,d16 -- Load d16 into HL
            [self.currentState incrementPC];
            d16 = (self.ram[[self.currentState getPC] + 1] << 8) | self.ram[[self.currentState getPC]];
            [self.currentState incrementPC];
            [self.currentState setHL_big:d16];
#ifdef MYDEBUG
            printf("0x%02x -- LD HL, d16 -- d16 = %i\n", currentInstruction, d16);
#endif
            break;
        case 2:
            // LD (HL+),A -- Put A into (HL), and increment HL
            self.ram[[self.currentState getHL_big] % RAMSIZE] = [self.currentState getA];
            [self.currentState setHL_big:([self.currentState getHL_big] + 1)];
            break;
        case 3:
            // INC HL -- Increment HL
            [self.currentState setHL_big:([self.currentState getHL_big] + 1)];
#ifdef MYDEBUG
            printf("0x%02x -- INC HL\n", currentInstruction);
#endif
            break;
        case 4:
            // INC H -- Increment H
            prev = [self.currentState getH];
            [self.currentState setH:([self.currentState getH] + 1)];
            [self.currentState setFlags:([self.currentState getH] == 0)
                                      N:false
                                      H:(prev > [self.currentState getH])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- INC H\n", currentInstruction);
#endif
            break;
        case 5:
            // DEC H -- Decrement H
            prev = [self.currentState getH];
            [self.currentState setH:([self.currentState getH] - 1)];
            [self.currentState setFlags:([self.currentState getH] == 0)
                                      N:true
                                      H:(prev < [self.currentState getH])
                                      C:([self.currentState getCFlag])];
#ifdef MYDEBUG
            printf("0x%02x -- DEC H\n", currentInstruction);
#endif
            break;
        case 6:
            // LD H,d8 -- Load 8-bit immediate data into H
            [self.currentState incrementPC];
            d8 = self.ram[[self.currentState getPC]];
            [self.currentState setH:d8];
#ifdef MYDEBUG
            printf("0x%02x -- LD H, d8 -- d8 = %i\n", currentInstruction, (int)d8);
#endif
            break;
        case 7:
            // DAA -- Decimal adjust register A; adjust A so that correct BCD obtained
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
- (void) execute0x3Instruction:(unsigned char)currentInstruction
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
- (void) execute0x4Instruction:(unsigned char)currentInstruction
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
- (void) execute0x5Instruction:(unsigned char)currentInstruction
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
- (void) execute0x6Instruction:(unsigned char)currentInstruction
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
- (void) execute0x7Instruction:(unsigned char)currentInstruction
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
- (void) execute0x8Instruction:(unsigned char)currentInstruction
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
- (void) execute0x9Instruction:(unsigned char)currentInstruction
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
- (void) execute0xAInstruction:(unsigned char)currentInstruction
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
- (void) execute0xBInstruction:(unsigned char)currentInstruction
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
- (void) execute0xCInstruction:(unsigned char)currentInstruction
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
- (void) execute0xDInstruction:(unsigned char)currentInstruction
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
- (void) execute0xEInstruction:(unsigned char)currentInstruction
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
- (void) execute0xFInstruction:(unsigned char)currentInstruction
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

